import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Renewal_Letters extends StatefulWidget {
  @override
  RenewalLettersState createState() => RenewalLettersState();
}

class RenewalLettersState extends State<Renewal_Letters> {
  late List<Item> _data;
  late List<Item> _filteredData;

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _data = generateItems();
    _filteredData = List.from(_data);
  }

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

  void _filterData(String query) {
    setState(() {
      _filteredData = _data
          .where((item) =>
      item.header.toLowerCase().contains(query.toLowerCase()) ||
          item.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Renew Accommodations"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterData,
              decoration: InputDecoration(
                labelText: 'Search for items...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filteredData = List.from(_data);
                  },
                ),
                //border: OutlineInputBorder(
                 // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                //),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: ExpansionPanelList.radio(
                elevation: 1,
                expandedHeaderPadding: EdgeInsets.all(0),
                children: _filteredData.map((Item item) {
                  return ExpansionPanelRadio(
                    value: item,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return new Text(item.header, style: TextStyle(fontSize: 20),);
                    },
                    body: ListTile(
                      title: Text(item.description,style: TextStyle(fontSize: 20)),
                      subtitle: Text(
                        item.link,
                          style: TextStyle(fontSize: 20, color: Colors.blue),

                      ),
                      onTap: () {
                        _showAlertDialog(context, item);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
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
    Item(
      isExpanded: false,
      header: 'SAS Disability Form.',
      description: 'This contains a link to the disability form. Needed for registering with Accessibility services.',
      link: 'https://studentlife.ontariotechu.ca/current-students/accessibility/students/new-students/index.php#tab1-2',
    ),
    Item(
      isExpanded: false,
      header: 'Uoit SAS Resources Page.',
      description: 'This contains a link to the SAS resource page on the UOIT studentlife website.',
      link: 'https://studentlife.ontariotechu.ca/current-students/accessibility/students/resources/index.php',
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
