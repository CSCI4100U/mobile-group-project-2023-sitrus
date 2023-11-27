//home page with a list of buttons (list tiles?) leading to new pages - list of accommodations page,
// upcoming assessments page, letter/email to professors page,
// search accommodations page (not sure what is being searched)
//also buttons leading to external site (university website) for renewing accommodations and potential other things

import 'package:flutter/material.dart';
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
        backgroundColor: Colors.indigo,
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
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
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
                  MaterialPageRoute(builder: (context) =>  ViewAccommodations()),
                );
              },
              label: Text("View Accommodations")),
          SizedBox(height: 10,),
          OutlinedButton.icon(
              icon: Icon(
                Icons.accessibility_new,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {},
              label: Text("View Upcoming Assessments")),
          SizedBox(height: 10,),
          OutlinedButton.icon(
              icon: Icon(
                Icons.accessibility_new,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
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
              label: Text("Send Accommodation Letters")),
          SizedBox(height: 10,),
          OutlinedButton.icon(
              icon: Icon(
                Icons.accessibility_new,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,
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
              label: Text("Renew Accommodations")),
        ],
      ),
    );
  }
}
