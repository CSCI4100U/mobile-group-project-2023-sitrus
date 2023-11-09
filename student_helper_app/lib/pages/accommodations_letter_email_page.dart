import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class Renewal_Letters extends StatefulWidget {
  @override
  Renewal_LettersState createState() => Renewal_LettersState();
}
class Renewal_LettersState extends State<Renewal_Letters>{
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Popup Message"),
          content: Text("This contains a link to renew accommodations."),
          actions: [
            TextButton(
              onPressed:  () async {
                Navigator.of(context).pop();

                final Uri url = Uri.parse('https://disabilityservices.ontariotechu.ca/uoitclockwork/custom/misc/home.aspx');
                if (!await launchUrl(url)) {
                throw Exception('Error launching page');
                }
              },
              child: Text("Continue?"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Renew Accommodations"),
      ),
      body: Column(

          children: [

            const Text(
                'Insert Instructions here.'
            ),

            ElevatedButton(
              onPressed: () {
                _showAlertDialog(context);
              },
              child: Text("Go to university site"),
            ),


          ]),
    );
  }
}
