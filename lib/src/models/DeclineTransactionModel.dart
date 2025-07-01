import 'package:DSTokenBam/src/models/BaseParams.dart';

class DeclineTransactionModel extends BaseParams {
  DeclineTransactionModel({
    required installation,
    required username,
    required channelId,
    required country,
    required uuid,
  }) : super(
            installation: installation,
            username: username,
            channelId: channelId,
            country: country,
            uuid: uuid);
}
