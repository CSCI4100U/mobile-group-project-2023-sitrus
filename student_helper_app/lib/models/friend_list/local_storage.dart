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
    // Lazily instantiate the db the first time it is accessed.
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create it if it doesn't exist
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT NOT NULL,
            sender TEXT NOT NULL,
            receiver TEXT NOT NULL,
            content TEXT NOT NULL,
            edited INTEGER NOT NULL
          )
          ''');
  }

  // Method to insert a message into the database
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Method to query all rows (messages) from the database
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Method to delete a message from the database by id
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // Method to update a message in the database
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  // Method to query messages for a specific conversation
  Future<List<Map<String, dynamic>>> queryMessages(String sender, String receiver) async {
    Database db = await instance.database;
    return await db.query(
      table,
      where: '(sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?)',
      whereArgs: [sender, receiver, receiver, sender],
    );
  }

  // Method to delete all messages in a specific conversation
  Future<int> deleteConversation(String sender, String receiver) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '(sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?)',
      whereArgs: [sender, receiver, receiver, sender],
    );
  }

  // Method to delete all messages from the database
  Future<int> deleteAllMessages() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}
