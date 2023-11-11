import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'message.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const tableMessages = 'messages';
  static const tableUserInfo = 'userInfo'; // New table for user login info

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future _onCreate(Database db, int version) async {
    // Create messages table
    await db.execute('''
          CREATE TABLE $tableMessages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uid TEXT,
            timestamp TEXT NOT NULL,
            sender TEXT NOT NULL,
            senderUid TEXT NOT NULL,
            receiver TEXT NOT NULL,
            receiverUid TEXT NOT NULL,
            content TEXT NOT NULL,
            edited INTEGER NOT NULL,
            deleted INTEGER NOT NULL DEFAULT 0
          )
          ''');

    // Create userInfo table
    await db.execute('''
          CREATE TABLE $tableUserInfo (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL,
            password TEXT NOT NULL
          )
          ''');
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade); // Add the onUpgrade parameter here
  }

  // This is called when the database version is incremented.
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle any upgrades here...
  }

  // Insert message into the database
  Future<int> insertMessage(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableMessages, row);
  }

  // Insert user login info into the database
  Future<int> insertUserInfo(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableUserInfo, row);
  }

  // Query all messages
  Future<List<Map<String, dynamic>>> queryAllMessages() async {
    Database db = await instance.database;
    return await db.query(tableMessages);
  }

  // Query all user info
  Future<List<Map<String, dynamic>>> queryAllUserInfo() async {
    Database db = await instance.database;
    return await db.query(tableUserInfo);
  }

  // Delete specific message
  Future<int> deleteMessage(String uid) async {
    Database db = await instance.database;
    return await db.delete(tableMessages, where: 'uid = ?', whereArgs: [uid]);
  }

  // Delete specific user info
  Future<int> deleteUserInfo(String email) async {
    Database db = await instance.database;
    return await db.delete(tableUserInfo, where: 'email = ?', whereArgs: [email]);
  }

  // Update message in the database
  Future<int> updateMessage(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String uid = row['uid'];
    return await db.update(tableMessages, row, where: 'uid = ?', whereArgs: [uid]);
  }

  // Update user info in the database
  Future<int> updateUserInfo(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String email = row['email'];
    return await db.update(tableUserInfo, row, where: 'email = ?', whereArgs: [email]);
  }

  // Method to query messages between two specific users
  Future<List<Message>> queryMessagesBetween(String userUid, String friendUid) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> messageMaps = await db.query(
      tableMessages,
      where: '(senderUid = ? AND receiverUid = ?) OR (senderUid = ? AND receiverUid = ?)',
      whereArgs: [userUid, friendUid, friendUid, userUid],
    );

    return messageMaps.map((map) => Message.fromMap(map)).toList();
  }
}
