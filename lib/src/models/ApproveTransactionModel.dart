import 'package:DSTokenBam/src/models/BaseParams.dart';

class ApproveTransactionModel extends BaseParams {
  String transactionId;
  double transactionAmount;
  String transactionValue;
  String ip;
  String token;
  String resultType;

  ApproveTransactionModel({
    required String installation,
    required String username,
    required String channelId,
    required String country,
    required String uuid,
    required this.transactionId,
    required this.transactionAmount,
    required this.transactionValue,
    required this.ip,
    required String datetime,
    required this.token,
    required this.resultType,
  }) : super(
          installation: installation,
          username: username,
          channelId: channelId,
          country: country,
          uuid: uuid,
          timeStamp: datetime,
        );
}
