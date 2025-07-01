import 'package:DSTokenBam/src/models/ApproveTransactionModel.dart';
import 'package:DSTokenBam/src/models/DeclineTransactionModel.dart';
import 'package:DSTokenBam/src/models/ReSyncTokenModel.dart';
import 'package:DSTokenBam/src/models/ResultServiceModel.dart';
import 'package:DSTokenBam/src/models/SyncTokenModel.dart';
import 'package:DSTokenBam/src/models/UnSubscribeUserModel.dart';
import 'package:DSTokenBam/src/provider/ApiProvider.dart';
import 'package:DSTokenBam/src/security/EncrypText.dart';
import 'package:dio/dio.dart';

class ApiServices {
  late Dio _dio;

  static final ApiServices _instance = ApiServices._internal();

  factory ApiServices() => _instance;

  ApiServices._internal() {
    BaseOptions options = BaseOptions(
        headers: {"content-type": "application/json; charset=utf-8"});
    _dio = new Dio(options);
  }

  static ApiServices getInstance() {
    return _instance;
  }

  Future<ResultServiceModel> syncToken({
    required SyncTokenModel syncToken,
  }) async {
    String _api = ApiProvider.URL_BASE + ApiProvider.SYNC_DEVICE;

    try {
      _dio.options.headers["Authorization"] = "Bearer " + ApiProvider.API_KEY;

      String? idPushToken = await encryptText("abc123");

      Response res = await _dio.post(_api, data: {
        "Param1": syncToken.username,
        "ChannelId": syncToken.channelId,
        "DeviceId": syncToken.deviceId,
        "Param2": syncToken.otp,
        "timestamp": syncToken.timeStamp,
        "Param3": idPushToken,
      });

      return ResultServiceModel.fromJson(res.data['AdministrativeModel']);
    } catch (error) {
      return ResultServiceModel.withError(_handleError(error));
    }
  }

  Future<ResultServiceModel> reSyncToken({
    required ReSyncTokenModel reSyncToken,
  }) async {
    String _api = ApiProvider.URL_BASE + ApiProvider.RESYNC_DEVICE;

    try {
      _dio.options.headers["Authorization"] = "Bearer " + ApiProvider.API_KEY;

      Response res = await _dio.post(_api, data: {
        "DeviceId": reSyncToken.deviceId,
        "Timestamp": reSyncToken.timeStamp,
        "Users": reSyncToken.users?.map((u) => u.toJson()).toList(),
        "SmartId": reSyncToken.smartId,
        "Force": reSyncToken.force,
      });

      return ResultServiceModel.fromJson(res.data['AdministrativeModel']);
    } catch (error) {
      return ResultServiceModel.withError(_handleError(error));
    }
  }

  Future<ResultServiceModel> approveTransaction({
    required ApproveTransactionModel approveTransaction,
  }) async {
    String _api = ApiProvider.URL_BASE + ApiProvider.APPROVE_TRANSACTION;

    try {
      _dio.options.headers["Authorization"] = "Bearer " + ApiProvider.API_KEY;

      Response res = await _dio.post(_api, data: {
        "Installation": approveTransaction.installation,
        "Param1": approveTransaction.username, //cifrado
        "ChannelId": approveTransaction.channelId,
        "Country": approveTransaction.country,
        "Param2": approveTransaction.uuid, // cifrado
        "transaction_id": approveTransaction.transactionId,
        "transaction_amount": approveTransaction.transactionAmount, // cero
        "transaction_value": approveTransaction.transactionValue,
        "ip": approveTransaction.ip,
        "datetime": approveTransaction.timeStamp,
        "Param3": approveTransaction.token, // cifrado
        "ResultType": approveTransaction.resultType
      });

      return ResultServiceModel.fromJson(res.data['AdministrativeModel']);
    } catch (error) {
      return ResultServiceModel.withError(_handleError(error));
    }
  }

  Future<ResultServiceModel> declineTransaction({
    required DeclineTransactionModel declineTransaction,
  }) async {
    String _api = ApiProvider.URL_BASE + ApiProvider.DECLINE_TRANSACTION;

    try {
      _dio.options.headers["Authorization"] = "Bearer " + ApiProvider.API_KEY;

      Response res = await _dio.post(_api, data: {
        "Installation": declineTransaction.installation,
        "Param1": declineTransaction.username, // cifrados
        "ChannelId": declineTransaction.channelId,
        "Country": declineTransaction.country,
        "Param2": declineTransaction.uuid // cifrado
      });

      return ResultServiceModel.fromJson(res.data['AdministrativeModel']);
    } catch (error) {
      return ResultServiceModel.withError(_handleError(error));
    }
  }

  Future<ResultServiceModel> unSubscribeUser({
    required UnSubscribeUserModel unSubscribeUser,
  }) async {
    String _api = ApiProvider.URL_BASE + ApiProvider.UN_SUBSCRIBE_USER;

    try {
      _dio.options.headers["Authorization"] = "Bearer " + ApiProvider.API_KEY;

      Response res = await _dio.post(_api, data: {
        "Param1": unSubscribeUser.username,
        "ChannelId": unSubscribeUser.channelId,
      });

      return ResultServiceModel.fromJson(res.data['AdministrativeModel']);
    } catch (error) {
      return ResultServiceModel.withError(_handleError(error));
    }
  }

  String _handleError(dynamic anError) {
    String errorDescription = "";
    if (anError is DioException) {
      switch (anError.type) {
        case DioExceptionType.connectionTimeout:
          errorDescription = "Server connection timeout timed out.";
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = "Server connection timeout timed out.";
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = "Server connection timeout timed out.";
          break;
        case DioExceptionType.badCertificate:
          errorDescription = "Failed due to internet connection.";
          break;
        case DioExceptionType.badResponse:
          errorDescription =
              "Received invalid status code: ${anError.response!.statusCode}";
          break;
        case DioExceptionType.cancel:
          errorDescription = "The request to the server was canceled.";
          break;
        case DioExceptionType.connectionError:
          errorDescription = "Failed due to internet connection.";
          break;
        case DioExceptionType.unknown:
          errorDescription = "Failed due to internet connection.";
          break;
      }
    } else {
      errorDescription = "Unexpected error ocurred";
    }
    return errorDescription;
  }
}
