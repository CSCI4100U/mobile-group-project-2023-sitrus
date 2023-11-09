import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Accommodation.dart';


//will add firebase version later
class SASModel{

  Future<List<Accommodation>> getAll() async {
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> sasMaps = await db.query('accessibility');

    List<Accommodation> accommodations = [];

    for (var map in sasMaps) {

      accommodations.add(Accommodation.fromMap(map));
    }

    return accommodations;
  }

  Future<int> insertAcmdn(Accommodation a) async {
    final db = await DBUtils.init();
    final id = await db.insert(
      'accessibility',
      a.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> updateAcmdn(Accommodation a) async {
    final db = await DBUtils.init();
    final rowsUpdated = await db.update(
      'accessibility',
      a.toMap(),
      where: 'id = ?',
      whereArgs: [a.id],
    );
    return rowsUpdated;
  }

  Future<int> deleteAcmdnById(int? id) async {
    final db = await DBUtils.init();
    final rowsDeleted = await db.delete(
      'accessibility',
      where: 'id = ?',
      whereArgs: [id],
    );
    return rowsDeleted;
  }
}

class DBUtils{
  static Future init() async{
    late Database db;
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'accessibility.db');


    db = await openDatabase(path, version: 1, onCreate: (Database db, int version) {

      db.execute('''
        CREATE TABLE accessibility (
          id INTEGER PRIMARY KEY,
          name TEXT,
          notes TEXT
        )
      ''');
    });


    return db;
  }
}
