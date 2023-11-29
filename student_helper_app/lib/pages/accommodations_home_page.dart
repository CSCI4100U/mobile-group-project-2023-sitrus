//home page with a list of buttons (list tiles?) leading to new pages - list of accommodations page,
// upcoming assessments page, letter/email to professors page,
// search accommodations page (not sure what is being searched)
//also buttons leading to external site (university website) for renewing accommodations and potential other things

import 'package:flutter/material.dart';
import 'package:student_helper_project/pages/accommodations_upcoming_assessments_page.dart';
import 'accommodations_list_page.dart';
import 'accommodations_letter_email_page.dart';


class SASHomePage extends StatelessWidget {
  SASHomePage({super.key});

  final buttonHeight = 100.0;
  final buttonWidth = 200.0;
  final buttonFontSize = 30.0;
  final iconSize = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("SAS Home"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          OutlinedButton.icon(
              icon: Icon(
                Icons.accessibility_new,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.background,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize

                  )),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ViewAccommodations()),
                );
              },
              label: const Text("View Accommodations")),
          SizedBox(height: 10,),
          OutlinedButton.icon(
              icon: Icon(
                Icons.accessibility_new,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.background,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  UpcomingPage()),
                );
              },
              label: const Text("View Upcoming Assessments")),
          SizedBox(height: 10,),
          OutlinedButton.icon(
              icon: Icon(
                Icons.accessibility_new,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.background,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  Renewal_Letters()),
                );
              },
              label: const Text("Send Accommodation Letters")),
          SizedBox(height: 10,),
          OutlinedButton.icon(
              icon: Icon(
                Icons.accessibility_new,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.background,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  Renewal_Letters()),
                );
              },
              label: const Text("Renew Accommodations")),
        ],
      ),
    );
  }
}
