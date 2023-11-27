import 'package:flutter/material.dart';
import 'schedule_saved_list_page.dart';
import 'schedule_create_new_page.dart';

void _goto_scheduleSavedList_page(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ScheduleSavedListPage()),
  );
}

void _goto_createNewSchedule_page(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CreateNewSchedulePage()),
  );
}

class ScheduleMakerHomePage extends StatelessWidget {
  ScheduleMakerHomePage({super.key});

  final buttonHeight = 80.0;
  final buttonWidth = 200.0;
  final buttonFontSize = 30.0;
  final iconSize = 60.0;
  final buttonSpacing = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text("Schedule Maker"),

      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Container(
            color: Colors.red,
            width: 200,
            height: 300,
            child: Text("primary schedule, empty if not set"),
          ),
          SizedBox(height: buttonSpacing),
          OutlinedButton.icon(
              icon: Icon(
                Icons.calendar_view_week,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {_goto_scheduleSavedList_page(context);},
              label: Text("View Saved Courses")),
          SizedBox(height: buttonSpacing),
          OutlinedButton.icon(
              icon: Icon(
                Icons.search,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {},
              label: const Text("Search Courses by Term")),
          SizedBox(height: buttonSpacing),
          OutlinedButton.icon(
              icon: Icon(
                Icons.link,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {},
              label: const Text("Program Map")),
          SizedBox(height: buttonSpacing),
          
          OutlinedButton.icon(
              icon: Icon(
                Icons.add,
                size: iconSize,
              ),


              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {_goto_createNewSchedule_page(context);},
              label: const Text("Make New Schedules")),
        ],
      ),
    );
  }
}