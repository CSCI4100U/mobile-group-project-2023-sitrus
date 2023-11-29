import 'package:flutter/material.dart';
import 'package:schedule_testing/models/schedule_course_model.dart';
import 'section_info_widget.dart';
import 'tutorial_info_widget.dart';
import 'lab_info_widget.dart';

//course = [[(name, time), (name, time), +button], [(name, time), (name, time), +button], +button] = [(section), (section)] i.e. contains info for a single course, usually a course has 1-3 sections for lectures
//  course will also need to have lab/tut
class CourseInfoContainer extends StatefulWidget {
  final String name;
  CourseInfoContainer({required this.name});

  @override
  _CourseInfoContainerState createState() => _CourseInfoContainerState();
}

class _CourseInfoContainerState extends State<CourseInfoContainer> {

  final TextEditingController courseNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Color(0xFF243f6e),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                color: Color(0xFF243f6e),
                // padding: EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text(widget.name, style: const TextStyle(fontSize: 36.0, color: Colors.white),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white,),
                          onPressed: () {
                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      child:
                        TextField(
                          style: TextStyle(fontSize: 24.0),
                          controller: courseNameController,
                          decoration: InputDecoration(
                            labelText: 'Enter course name',
                            labelStyle: TextStyle(fontSize: 24.0),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                            ),
                          ),
                        ),
                    ),

                    SectionList(),
                    TutsInfoContainer(name: "Tutorials"),
                    LabsInfoContainer(name: "Laboratories"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//simply a class for building a widget holding section containers and a button to add more section containers to the listview
class SectionList extends StatefulWidget {

  @override
  _SectionListState createState() => _SectionListState();
}

class _SectionListState extends State<SectionList> {

  List<SectionInfoContainer> sectionInfoContainerList = [SectionInfoContainer(name: 'Section 1')];

  void addSectionContainer() {
    sectionInfoContainerList.add(SectionInfoContainer(name: 'Section ${sectionInfoContainerList.length + 1}'));
  }

  void deleteSectionContainer() {
    sectionInfoContainerList.removeLast();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: sectionInfoContainerList.length,
          itemBuilder: (context, index) {
            return sectionInfoContainerList[index];
          },
        ),
        Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 15.0, right: 5.0, left: 5.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFeae3d6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: EdgeInsets.all(5.0),
                  ),
                  onPressed: () {
                    setState(() {
                      addSectionContainer();
                    });
                  },
                  child: const Icon(
                    Icons.add,
                    size: 60.0,
                    color: Color(0xFFe47c43),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}