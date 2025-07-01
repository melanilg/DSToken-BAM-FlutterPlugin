import 'dart:async';

import 'package:DSTokenBam/src/db/DbProvider.dart';
import 'package:DSTokenBam/src/models/ReSyncTokenModel.dart';
import 'package:DSTokenBam/src/models/ResultServiceModel.dart';
import 'package:DSTokenBam/src/models/SyncTokenModel.dart';
import 'package:DSTokenBam/src/models/TokenModel.dart';
import 'package:DSTokenBam/src/models/UnSubscribeUserModel.dart';
import 'package:DSTokenBam/src/provider/ApiServices.dart';
import 'package:DSTokenBam/src/security/EncrypText.dart';
import 'package:dart_dash_otp/dart_dash_otp.dart';
import 'package:flutter/services.dart';

class DSTokenBam {
  static const MethodChannel _channel = const MethodChannel('DSTokenBam');

  ///
  /// TOKEN CONFIG
  ///

  /// Synchronize Token
  Future<Map<String, String?>> syncToken({
    required String username,
    required String channelId,
    required String deviceId,
    required String otp,
  }) async {
    SyncTokenModel syncTokenModel;
    ResultServiceModel resultServiceModel;
    var responseModel = new Map<String, String?>();
    ApiServices api = new ApiServices();

    /// Call Database
    TokenModel? findToken =
        await DbProvider.instance.getExistToken(username, channelId);

    if (findToken == null) {
      String usernameEncrypt = encryptText(username);
      String otpEncrypt = encryptText(otp);
      final smartId = await _getSmartId();

      syncTokenModel = new SyncTokenModel(
        username: usernameEncrypt ?? "",
        channelId: channelId,
        deviceId: smartId,
        timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
        otp: otpEncrypt ?? "",
      );

      /// Call Service
      resultServiceModel = await api.syncToken(syncToken: syncTokenModel);

      if (resultServiceModel.code == "002") {
        var seed = resultServiceModel.message!.split(',');
        try {
          /// Save Token in DB
          await DbProvider.instance.insertToken(
            new TokenModel(
              username: username,
              channel: channelId,
              seed: seed[0],
            ),
          );
        } catch (error) {
          responseModel['code'] = "0";
          responseModel['message'] = error.toString();
        }
        responseModel['code'] = resultServiceModel.code;
        responseModel['message'] = "Sincronización de Token Exitosa";
      } else if (resultServiceModel.code == "215") {
        responseModel['code'] = "215";
        responseModel['message'] =
            "Sincronización de Token Fallida | ${resultServiceModel.message}";
      } else {
        responseModel['code'] = "0";
        responseModel['message'] =
            "Sincronización de Token Fallida | ${resultServiceModel.message}";
      }
    } else {
      responseModel['code'] = "0";
      responseModel['message'] =
          "Sincronización de Token Fallida | Ya se encuentra sincronizado en el dispositivo el usuario: $username con canal: $channelId";
    }

    return responseModel;
  }

  /// ReSynchronize Token
  Future<Map<String, String?>> reSyncToken({
    required String deviceId,
  }) async {
    ReSyncTokenModel reSyncTokenModel;
    ResultServiceModel resultServiceModel;
    var responseModel = new Map<String, String?>();
    ApiServices api = new ApiServices();

    final smartId = await _getSmartId();

    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    List<User> usersModel = await DbProvider.instance.getUsers();

    final lastSmartId =
        await DbProvider.instance.getConfiguration('LastSmartId');

    final isForced = lastSmartId != smartId;

    reSyncTokenModel = new ReSyncTokenModel(
        deviceId: deviceId,
        timeStamp: timeStamp,
        users: usersModel,
        smartId: smartId,
        force: isForced);

    /// Call Service
    resultServiceModel = await api.reSyncToken(reSyncToken: reSyncTokenModel);

    if (resultServiceModel.code == "809") {
      responseModel['code'] = resultServiceModel.code;
      responseModel['message'] = "Re-Sincronización de Token Exitosa";
      await DbProvider.instance.setConfiguration('LastSmartId', smartId);
    } else {
      responseModel['code'] = "0";
      responseModel['message'] =
          "Re-Sincronización de Token Fallida | ${resultServiceModel.message}";
    }

    return responseModel;
  }

  /// Generate Token
  Future<Map<String, String?>> generateToken({
    required String username,
    required String channelId,
  }) async {
    var responseMap = new Map<String, String?>();

    /// Call Database
    TokenModel? findToken =
        await DbProvider.instance.getExistToken(username, channelId);

    // Time
    int _interval = 30;
    var timeAvailable = _interval - (_getSeconds() % _interval);

    if (findToken != null) {
      String seedDecrypt = (await _getSeedDecrypt(findToken.seed)) ?? "";
      var totp = TOTP(secret: seedDecrypt, digits: 6, interval: _interval);

      responseMap['code'] = "200";
      responseMap['message'] = "Token Generado Exitosamente";
      responseMap['token'] = totp.now();
      responseMap['timeAvailable'] = timeAvailable.toString();
    } else {
      responseMap['code'] = "0";
      responseMap['message'] =
          "Generación de Token Fallida | No se encontro el usuario y canal.";
      responseMap['token'] = "000000";
    }

    return responseMap;
  }

  Future<String?> _getSeedDecrypt([String? seedEncrypt]) async {
    final String? seed =
        await _channel.invokeMethod('getSeedDecrypt', {'seed': seedEncrypt});
    return seed;
  }

  Future<String> _getSmartId() async {
    final String? smartId = await _channel.invokeMethod('getSmartId', {});
    return smartId ?? "";
  }

  /// Delete Token
  Future<Map<String, String?>> deleteToken({
    required String username,
    required String channelId,
  }) async {
    int response;

    /// Call Database
    TokenModel? findToken =
        await DbProvider.instance.getExistToken(username, channelId);
    var responseModel = new Map<String, String?>();
    if (findToken != null) {
      /// Call Database
      response = await DbProvider.instance.deleteTokenById(findToken.id);

      if (response > 0) {
        responseModel['code'] = '200';
        responseModel['message'] = 'Token Eliminado Exitosamente';
      } else {
        responseModel['code'] = '0';
        responseModel['message'] = 'Token Eliminado Exitosamente';
      }
    } else {
      responseModel['code'] = '0';
      responseModel['message'] = 'No se encontro el usuario y canal.';
    }
    return responseModel;
  }

  /// UnSubscribe User
  Future<Map<String, String?>> unSubscribeUser({
    required String username,
    required String channelId,
  }) async {
    UnSubscribeUserModel unSubscribeUserModel;
    ResultServiceModel resultServiceModel;
    var responseModel = new Map<String, String?>();
    ApiServices api = new ApiServices();

    /// Call Database
    TokenModel? findToken =
        await DbProvider.instance.getExistToken(username, channelId);

    if (findToken != null) {
      String? usernameEncrypt = await encryptText(username);
      unSubscribeUserModel = new UnSubscribeUserModel(
        username: usernameEncrypt ?? "",
        channelId: channelId,
      );

      /// Call Service
      resultServiceModel =
          await api.unSubscribeUser(unSubscribeUser: unSubscribeUserModel);

      if (resultServiceModel.code == "205") {
        //deleteToken(username: username, channelId: channelId);
        responseModel['code'] = '205';
        responseModel['message'] = 'Dispositivo desafiliado exitosamente';
      } else {
        responseModel['code'] = '210';
        responseModel['message'] = 'Desafiliación de Dispositivo Fallida';
      }
    } else {
      responseModel['code'] = '0';
      responseModel['message'] = 'No se encontro el usuario y canal.';
    }
    return responseModel;
  }

  static int _getSeconds() {
    var ms = (DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }
}
