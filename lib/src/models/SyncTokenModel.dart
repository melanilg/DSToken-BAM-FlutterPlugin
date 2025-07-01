import 'BaseParams.dart';

class SyncTokenModel extends BaseParams {
  String otp;
  SyncTokenModel({
    required String username,
    required String channelId,
    required String deviceId,
    required String timeStamp,
    required this.otp,
  }) : super(
            username: username,
            channelId: channelId,
            deviceId: deviceId,
            timeStamp: timeStamp);
}
