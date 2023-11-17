//user can add their accommodations 

import 'package:flutter/material.dart';

//import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_helper_project/models/sas_model/Accommodation.dart';
import 'package:student_helper_project/models/sas_model/Sas_ModelSQLite.dart';
import 'accommodations_list_page.dart';

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
          final newAcmdn = Accommodation(
            desc: n,
            name: g,
            assessments: ['Test'],
              
          );

          SASModel gradesModel=new SASModel();
          gradesModel.insertAcmdn(newAcmdn).then((newNotes) {
            if (newNotes != null) {
              //Navigator.of(context).pop(newGrade);
              Navigator.of(context).push(
                MaterialPageRoute<List<String>>(builder: (BuildContext context) {
                  return ViewAccommodations();
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
