class TokenModel {
  int? id;
  String username;
  String channel;
  String seed;

  TokenModel({
    this.id,
    required this.username,
    required this.channel,
    required this.seed,
  });

  Map<String, dynamic> toMap() => {
        "_id": id,
        "col_username": username,
        "col_channel": channel,
        "col_seed": seed,
      };

  factory TokenModel.fromMap(Map<String, dynamic> json) => new TokenModel(
        id: json["_id"],
        username: json["col_username"],
        channel: json["col_channel"],
        seed: json["col_seed"],
      );

  @override
  String toString() {
    return 'TokenModel{id: $id, username: $username,channel: $channel}';
  }
}

class User {
  final String username;
  final int channel;

  User({required this.username, required this.channel});

  Map<String, dynamic> toJson() => {
        'username': username,
        'channel': channel,
      };
}
