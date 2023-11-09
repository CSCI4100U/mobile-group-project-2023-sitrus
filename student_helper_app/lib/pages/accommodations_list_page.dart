//list of the accommodations that the user has

import 'package:flutter/material.dart';

//import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/sas_model/Accommodation.dart';
import 'models/sas_model/Sas_ModelSQLite.dart';
import 'pages/accommodations_add_page.dart';
class ViewAccommodations extends StatefulWidget {
  @override
  ViewAccommodationsState createState() => ViewAccommodationsState();
}

class ViewAccommodationsState extends State<ViewAccommodations> {

  SASModel sas_model = SASModel();

  List<Accommodation> _accommodations = [];

  @override
  void initState() {
    super.initState();
    _refreshList(); // Initialize _grades inside initState
  }

  void _refreshList() async {
    final List<Accommodation> accommodations = await sas_model.getAll();
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
            subtitle: Text(_accommodations[index].desc ?? "NA"),
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
      sas_model.insertAcmdn(Accommodation(name: g, desc: studentId));
      _refreshList();
      // Perform any additional logic, such as adding the new grade to the list or database
    }
  }

  Future<void> _editAcmdn(BuildContext context, Accommodation acmdn) async {
    final editedAcmdn = await showDialog<Accommodation>(
      context: context,
      builder: (BuildContext context) {
        final notesController = TextEditingController(text: acmdn.desc);
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
                  final updatedAcmdn = Accommodation(
                    id: acmdn.id,
                    desc: editedNotes,
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
