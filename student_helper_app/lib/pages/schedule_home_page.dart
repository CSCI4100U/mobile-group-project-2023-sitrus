import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _launchURL(String url) async {

    final Uri uri = Uri(scheme: "https", host: url);
    if(!await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView,
    )) {
      throw "Can not launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          Container(
            color: Theme.of(context).colorScheme.primary,
            width: 200,
            height: 300,
            child: const Text("primary schedule, empty if not set"),
          ),
          SizedBox(height: buttonSpacing),
          OutlinedButton.icon(
              icon: Icon(
                Icons.calendar_view_week,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {_goto_scheduleSavedList_page(context);},
              label: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("View Saved Courses"),
                ],
              )),
          SizedBox(height: buttonSpacing),
          OutlinedButton.icon(
              icon: Icon(
                Icons.search,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {
                final Uri _url = Uri.parse('https://registrar.ontariotechu.ca/registration/scheduling/available-courses.php');
                launchUrl(_url);

              },
              label: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Search Courses"),
                ],
              )),
          SizedBox(height: buttonSpacing),
          OutlinedButton.icon(
              icon: Icon(
                Icons.link,
                size: iconSize,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {
                final Uri _url = Uri.parse('https://calendar.ontariotechu.ca/content.php?catoid=62&navoid=2811');
                launchUrl(_url);
              },
              label: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Program Map"),
                ],
              )),
          SizedBox(height: buttonSpacing),
          
          OutlinedButton.icon(
              icon: Icon(
                Icons.add,
                size: iconSize,
              ),


              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  maximumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  textStyle: TextStyle(
                    fontSize: buttonFontSize,
                  )),
              onPressed: () {_goto_createNewSchedule_page(context);},
              label: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Make New Schedules"),
                ],
              )),
        ],
      ),
    );
  }
}