import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'messages';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
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
    // If you are moving from version 1 to version 2
    if (oldVersion < 2) {
      // Add a new 'uid' column of type TEXT
      await db.execute('ALTER TABLE $table ADD COLUMN uid TEXT');
    }
    // Handle any other upgrades here...
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> delete(int uid) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'uid = ?', whereArgs: [uid]);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int uid = row['uid'];
    return await db.update(table, row, where: 'uid = ?', whereArgs: [uid]);
  }

  Future<List<Map<String, dynamic>>> queryMessages(String senderUid, String receiverUid) async {
    Database db = await instance.database;
    return await db.query(
      table,
      where: '(senderUid = ? AND receiverUid = ?) OR (senderUid = ? AND receiverUid = ?)',
      whereArgs: [senderUid, receiverUid, receiverUid, senderUid],
    );
  }

  Future<int> deleteConversation(String senderUid, String receiverUid) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '(senderUid = ? AND receiverUid = ?) OR (senderUid = ? AND receiverUid = ?)',
      whereArgs: [senderUid, receiverUid, receiverUid, senderUid],
    );
  }

  Future<int> deleteAllMessages() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}
