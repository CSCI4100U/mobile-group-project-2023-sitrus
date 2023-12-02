import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Renewal_Letters extends StatefulWidget {
  @override
  RenewalLettersState createState() => RenewalLettersState();
}

class RenewalLettersState extends State<Renewal_Letters> {
  List<Item> _data = generateItems();

  void _showAlertDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Popup Message"),
          content: Text(item.description),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                final Uri url = Uri.parse(item.link);
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
    return Scaffold( // Fixed typo here: PopScope -> Scaffold
      appBar: AppBar(

        title: const Text("Renew Accommodations"),
        backgroundColor: Theme.of(context).colorScheme.secondary,


      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionPanelList(
              elevation: 1,
              expandedHeaderPadding: EdgeInsets.all(0),
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _data[index].isExpanded = !_data[index].isExpanded;
                });
              },

              //child: const Text("Go to university site"),

              children: _data.map((Item item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return new Text(item.header);

                  },
                  /*body: ListTile(
                    title: new Text(item.description),
                    subtitle: Text(item.link),
                    onTap: () {
                      _showAlertDialog(context, item);
                    },
                  ),*/
                  isExpanded: item.isExpanded,
                  body:
                      ListTile(
                        title:
                          Text(item.description),
                      subtitle: Text(item.link),
                        onTap: () {
                          _showAlertDialog(context, item);
                        },
                      )


                );
              }).toList(),

            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  Item({
    required this.isExpanded,
    required this.header,
    required this.description,
    required this.link,
  });

  bool isExpanded;
  String header;
  String description;
  String link;
}

List<Item> generateItems() {
  return [
    Item(
      isExpanded: false,
      header: 'Renew Accommodations',
      description: 'This contains a link to renew accommodations.',
      link: 'https://disabilityservices.ontariotechu.ca/uoitclockwork/custom/misc/home.aspx',
    ),
    Item(
      isExpanded: false,
      header: 'Intake Form.',
      description: 'This contains a link to the intake form. Needed for registering with Accessibility services.',
      link: 'https://shared.ontariotechu.ca/shared/department/student-life/student-accessibility-services/documentation/new-sas-student-intake-package.pdf',
    ),
  ];
}

Future<bool> launchUrl(Uri url) async {
  if (await canLaunchUrlString(url.toString())) { // Fixed method name: canLaunchUrlString -> canLaunch
    await launchUrlString(url.toString());
    return true;
  } else {
    return false;
  }
}
