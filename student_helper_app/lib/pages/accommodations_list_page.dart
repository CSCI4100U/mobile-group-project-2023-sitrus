//list of the accommodations that the user has

import 'package:flutter/material.dart';

//import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:student_helper_project/models/sas_model/Accommodation.dart';
import 'package:student_helper_project/models/sas_model/Sas_ModelSQLite.dart';
import 'accommodations_add_page.dart';

enum SortOrder { byName, byDate }

SortOrder _currentSortOrder = SortOrder.byName;

TextEditingController _searchController = TextEditingController();


class ViewAccommodations extends StatefulWidget {
  @override
  ViewAccommodationsState createState() => ViewAccommodationsState();
}

class ViewAccommodationsState extends State<ViewAccommodations> {

  SASModel sas_model = SASModel();

  List<Accommodation> _accommodations = [

  ];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() async {
    final List<Accommodation> accommodations = await sas_model.getAll();
    setState(() {
      _accommodations = accommodations;
      _sortAccommodations(); // Call the sorting method
    });
  }



  String selectedOption = "NA";
  List<String> testOptions = ["NA", "Example1", "Example2", "ASL", "Extra time", "Scribe"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Accommodations'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              _toggleSortOrder();
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              _showExplanationPopup(context);
            },
          ),

        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _refreshList(); // Reset the list when clearing the search
                  },
                ),
              ),
              onChanged: (value) {
                _filterAccommodations(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
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
              },),),],),


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
      sas_model.insertAcmdn(Accommodation(name: g, desc: studentId, assessments: [''], eventDate: DateTime.now()));
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
                    //id: acmdn.id,
                    desc: editedNotes,
                    name: editedName,
                    assessments: ['Test'],
                    //eventDate: DateTime.now(),
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
  //---------------------------------------------------------------------------------------------
  void _toggleSortOrder() {
    setState(() {
      _currentSortOrder = (_currentSortOrder == SortOrder.byName)
          ? SortOrder.byDate
          : SortOrder.byName;

      _sortAccommodations();
    });
  }
  void _sortAccommodations() {
    setState(() {
      switch (_currentSortOrder) {
        case SortOrder.byName:
          _accommodations.sort((a, b) => a.name?.compareTo(b.name as String) as int);
          break;
        case SortOrder.byDate:
          _accommodations.sort((a, b) => a.eventDate?.compareTo(b.eventDate as DateTime) as int);
          break;
      }
    });
  }
//------------------------------------------------------------------------------------

  void _showExplanationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Page Explanation'),
          content: Text(
            'This page allows you to view and manage accommodations. '
                'Tap on an item to edit it, press the delete button to remove it, '
                'and use the add button to create a new accommodation.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  //---------------------------------------------------------------------------
  void _filterAccommodations(String query) {
    List<Accommodation> filteredList = _accommodations
        .where((accommodation) =>
    accommodation.name!.toLowerCase().contains(query.toLowerCase()) ||
        accommodation.desc!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _accommodations = filteredList;
    });
  }


}



