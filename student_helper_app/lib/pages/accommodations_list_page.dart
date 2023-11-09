//list of the accommodations that the user has

import 'package:flutter/material.dart';

class SASPage extends StatefulWidget {
  @override
  SASPageState createState() => SASPageState();
}

class SASPageState extends State<SASPage> {

  SASModel sas_model = SASModel();

  List<Accessibility> _accommodations = [];

  @override
  void initState() {
    super.initState();
    _refreshList(); // Initialize _grades inside initState
  }

  void _refreshList() async {
    final List<Accessibility> accommodations = await sas_model.getAll();
    setState(() {
      _accommodations = accommodations;
    });
  }


  String selectedGrade = "NA";
  List<String> gradeOptions = ["NA", "Example1", "Example2", "ASL", "Extra time", "Scribe"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Accommodations'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _accommodations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_accommodations[index].name ?? "NA"),
            subtitle: Text(_accommodations[index].notes ?? "NA"),
            onTap: () {
              _editAcmdn(context, _accommodations[index]);
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteAcmdn(_accommodations[index].id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print ("Add button printed");
          _addAcmdn(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }


//Note: Using a page bc of how long accessibility names are rip
  Future<void> _addAcmdn(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute<List<String>>(builder: (BuildContext context) {
        return AddAccommodation();
      }),
    );

    if (result != null) {
      // Handle the result, which contains the studentId and grade
      final studentId = result[0];
      final g = result[1];
      sas_model.insertAcmdn(Accessibility(name: g, notes: studentId));
      _refreshList();
      // Perform any additional logic, such as adding the new grade to the list or database
    }
  }

  Future<void> _editAcmdn(BuildContext context, Accessibility acmdn) async {
    final editedAcmdn = await showDialog<Accessibility>(
      context: context,
      builder: (BuildContext context) {
        final notesController = TextEditingController(text: acmdn.notes);
        final nameController = TextEditingController(text: acmdn.name);

        return AlertDialog(
          title: Text('Edit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: notesController,
                decoration: InputDecoration(labelText: 'Notes'),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                final editedNotes = notesController.text;
                final editedName = nameController.text;

                if (editedNotes.isNotEmpty && editedName.isNotEmpty) {
                  final updatedAcmdn = Accessibility(
                    id: acmdn.id,
                    notes: editedNotes,
                    name: editedName,
                  );
                  Navigator.of(context).pop(updatedAcmdn);
                }
              },
            ),
          ],
        );
      },
    );

    if (editedAcmdn != null) {
      final rowsUpdated = await sas_model.updateAcmdn(editedAcmdn);

      if (rowsUpdated > 0) {
        // The update was successful, update the list of grades
        _refreshList();
      }
    }}
  Future<void> _deleteAcmdn(int? id) async {
    // Delete the grade from the database and get the number of rows deleted
    final rowsDeleted = await sas_model.deleteAcmdnById(id);

    if (rowsDeleted > 0) {
      // The deletion was successful, update the list of grades
      _refreshList();
    }
  }
}

class AddAccommodation extends StatefulWidget {
  AddAccommodation();

  @override
  AddAccommodation_State createState() => AddAccommodation_State();


}
class AddAccommodation_State extends State<AddAccommodation> {
  String selectedOption = "Not Available";
  List<String> Options = ["Not Available", "Deadline Extension", "Accommodated Testing", "Sign Language Interpretation (ASL)", "Extra time", "Computerized Notetaking",
    "Alternative Testing space", "Scribe"];
  final studentIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            DropdownButton<String>(
              value: selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue!;
                });
              },
              items: Options.map((String grade) {
                return DropdownMenuItem<String>(
                  value: grade,
                  child: Text(grade),
                );
              }).toList(),
            ),
            TextField(
              controller: studentIdController,
              decoration: InputDecoration(labelText: 'notes'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String n = studentIdController.text;
          String g = selectedOption;
          final newAcmdn = Accessibility(
            notes: n,
            name: g,
          );

          SASModel gradesModel=new SASModel();
          gradesModel.insertAcmdn(newAcmdn).then((newNotes) {
            if (newNotes != null) {
              //Navigator.of(context).pop(newGrade);
              Navigator.of(context).push(
                MaterialPageRoute<List<String>>(builder: (BuildContext context) {
                  return SASPage();
                }),
              );
            }
          });
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

//-----------------------------------------------------------------
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

//------------------------------------------------------------------------------

class SASModel{

  //Grade_Model grade_model=Grade_Model();
  Future<List<Accessibility>> getAll() async {
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> gradeMaps = await db.query('accessibility');

    List<Accessibility> accommodations = [];

    for (var map in gradeMaps) {

      accommodations.add(Accessibility.fromMap(map));
    }

    return accommodations;
  }

  Future<int> insertAcmdn(Accessibility g) async {
    final db = await DBUtils.init();
    final id = await db.insert(
      'accessibility',
      g.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> updateAcmdn(Accessibility g) async {
    final db = await DBUtils.init();
    final rowsUpdated = await db.update(
      'accessibility',
      g.toMap(),
      where: 'id = ?',
      whereArgs: [g.id],
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
