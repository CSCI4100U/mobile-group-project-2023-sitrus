import 'package:flutter/material.dart';
import 'class_info_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Picker App'),
      ),
      body: SectionList(),
    );
  }
}

class SectionList extends StatefulWidget {
  @override
  _SectionListState createState() => _SectionListState();
}

class _SectionListState extends State<SectionList> {
  @override
  Widget build(BuildContext context) {
    List<ClassContainerList> sectionList = [
      ClassContainerList(),
      // ClassContainerList(),
    ];

    return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sectionList.length,
              itemBuilder: (context, index) {
                return sectionList[index];
              },
            ),
          ),
        ],
    );
  }
}
