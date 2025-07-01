import 'package:DSTokenBam/src/models/BaseParams.dart';

class UnSubscribeUserModel extends BaseParams {
  UnSubscribeUserModel({
    required String username,
    required String channelId,
  }) : super(username: username, channelId: channelId);
}
