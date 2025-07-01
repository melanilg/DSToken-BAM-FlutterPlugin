import 'package:DSTokenBam/src/models/TokenModel.dart';

class BaseParams {
  String? username;
  String? channelId;
  String? deviceId;
  String? timeStamp;
  String? installation;
  String? country;
  String? uuid;
  bool? force;
  List<User>? users;
  String? smartId;

  BaseParams(
      {this.username,
      this.channelId,
      this.deviceId,
      this.timeStamp,
      this.installation,
      this.country,
      this.uuid,
      this.force,
      this.users,
      this.smartId});
}
