import 'dart:io';

import 'package:DSTokenBam/src/models/TokenModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  DbProvider._();

  static final DbProvider instance = DbProvider._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await getDatabaseInstance();
    return _database!;
  }

  static const String TABLE_TOKEN = "TokenBam";
  static const String TABLE_CONFIGURATION = "Configuration";
  static const String COLUMN_ID = "_id";
  static const String COLUMN_USERNAME = "col_username";
  static const String COLUMN_CHANNEL = "col_channel";
  static const String COLUMN_SEED = "col_seed";
  static const String COLUMN_KEY = "col_key";
  static const String COLUMN_VALUE = "col_value";

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "/dstokenbam.db";
    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute("""CREATE TABLE $TABLE_TOKEN (
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_USERNAME TEXT,
        $COLUMN_CHANNEL TEXT,
        $COLUMN_SEED TEXT
      );""");

        await db.execute("""CREATE TABLE IF NOT EXISTS $TABLE_CONFIGURATION (
        $COLUMN_KEY TEXT PRIMARY KEY,
        $COLUMN_VALUE TEXT
      );""");

        await db.insert(
          '$TABLE_CONFIGURATION',
          {COLUMN_KEY: 'LastSmartId', COLUMN_VALUE: ''},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute("""CREATE TABLE IF NOT EXISTS $TABLE_CONFIGURATION (
          $COLUMN_KEY TEXT PRIMARY KEY,
          $COLUMN_VALUE TEXT
        );""");

          await db.insert(
            '$TABLE_CONFIGURATION',
            {COLUMN_KEY: 'LastSmartId', COLUMN_VALUE: ''},
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllTokens() async {
    final Database db = (await database);
    List<Map<String, dynamic>> response = await db.query(TABLE_TOKEN);
    return response;
  }

  Future<int> insertToken(TokenModel token) async {
    final Database db = (await database);
    var insertId = await db.insert(TABLE_TOKEN, token.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return insertId;
  }

  Future<TokenModel?> getExistToken(String username, String channelId) async {
    final Database db = (await database);
    var res = await db.query(TABLE_TOKEN,
        where: '$COLUMN_USERNAME = ? and $COLUMN_CHANNEL = ?',
        whereArgs: [username, channelId]);
    return res.isNotEmpty ? TokenModel.fromMap(res.first) : null;
  }

  Future<int> deleteTokenById(int? tokenId) async {
    final db = (await database);

    int? deleteId = tokenId;

    return await db
        .delete(TABLE_TOKEN, where: "_id = ?", whereArgs: [deleteId]);
  }

  Future<List<User>> getUsers() async {
    final Database db = await database;
    final response = await db.query(
      TABLE_TOKEN,
      columns: ['$COLUMN_USERNAME', '$COLUMN_CHANNEL'],
    );

    return response.map((row) {
      return User(
        username: row['$COLUMN_USERNAME'].toString(),
        channel: int.tryParse(row['$COLUMN_CHANNEL'].toString()) ?? 0,
      );
    }).toList();
  }

  Future<String?> getConfiguration(String key) async {
    final Database db = await database;
    final result = await db.query(
      '$TABLE_CONFIGURATION',
      where: '$COLUMN_KEY = ?',
      whereArgs: [key],
    );

    if (result.isNotEmpty) {
      final value = result.first[COLUMN_VALUE];
      return value.toString();
    }

    return '';
  }

  Future<void> setConfiguration(String key, String value) async {
    final Database db = await database;
    await db.insert(
      '$TABLE_CONFIGURATION',
      {COLUMN_KEY: key, COLUMN_VALUE: value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
