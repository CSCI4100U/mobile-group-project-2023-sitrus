import 'package:flutter/material.dart';
import 'schedule_section_info_widget.dart';
import 'schedule_tutorial_info_widget.dart';
import 'schedule_lab_info_widget.dart';

import 'schedule_course_model.dart';

//course = [[(name, time), (name, time), +button], [(name, time), (name, time), +button], +button] = [(section), (section)] i.e. contains info for a single course, usually a course has 1-3 sections for lectures
//  course will also need to have lab/tut
class CourseInfoContainer extends StatefulWidget {
  final String name;
  int id;
  final Function(int) onDelete;

  CourseInfoContainer({required this.name, required this.id, required this.onDelete});

  final TextEditingController courseNameController = TextEditingController();

  SectionList sectionList = SectionList();
  TutsInfoContainer tutInfoContainer = TutsInfoContainer(name: "Tutorials");
  LabsInfoContainer labInfoContainer = LabsInfoContainer(name: "Laboratories");

  Course getCourse() {
    List<Section> sections = sectionList.getSectionInfo();
    List<Tutorial> tutorials = tutInfoContainer.getTutorialsInfo();
    List<Laboratory> labs = labInfoContainer.getLabsInfo();

    Course course = Course(
        courseName: courseNameController.text,
        sections: sections,
        tutorials: tutorials,
        labs: labs,
        color: Colors.purple);

    return course;
  }

  @override
  _CourseInfoContainerState createState() => _CourseInfoContainerState();
}

class _CourseInfoContainerState extends State<CourseInfoContainer> {

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
                          child: Text('${widget.name} ${widget.id + 1}', style: const TextStyle(fontSize: 36.0, color: Colors.white),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white,),
                          onPressed: () {
                            widget.onDelete(widget.id);
                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      child:
                      TextField(
                        style: TextStyle(fontSize: 24.0),
                        controller: widget.courseNameController,
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
                    widget.sectionList,
                    widget.tutInfoContainer,
                    widget.labInfoContainer,
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

  List<SectionInfoContainer> sectionInfoContainerList = [];

  List<Section> getSectionInfo() {
    List<Section> sections = [];
    for (SectionInfoContainer section in sectionInfoContainerList) {
      sections.add(section.getSectionInfo());
    }
    return sections;
  }

  @override
  _SectionListState createState() => _SectionListState();
}

class _SectionListState extends State<SectionList> {

  @override
  void initState() {
    super.initState();

    addSectionContainer();
  }

  void addSectionContainer() {

    widget.sectionInfoContainerList.add(SectionInfoContainer(
        name: 'Section',
        id: widget.sectionInfoContainerList.length,
        onDelete: (int id) {
          setState(() {
            widget.sectionInfoContainerList.removeAt(id);
            updateID();
          });
        })
    );

  }

  void updateID() {
    for (int i = 0; i < widget.sectionInfoContainerList.length; i++) {
      widget.sectionInfoContainerList[i].id = i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.sectionInfoContainerList.length,
          itemBuilder: (context, index) {
            return widget.sectionInfoContainerList[index];
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