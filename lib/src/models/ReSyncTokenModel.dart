import 'package:DSTokenBam/src/models/BaseParams.dart';

import 'TokenModel.dart';

class ReSyncTokenModel extends BaseParams {
  ReSyncTokenModel(
      {required String deviceId,
      required String timeStamp,
      required List<User> users,
      required String smartId,
      required bool force})
      : super(
            deviceId: deviceId,
            timeStamp: timeStamp,
            users: users,
            smartId: smartId,
            force: force);
}
