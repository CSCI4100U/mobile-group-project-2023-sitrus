import 'package:flutter/material.dart';
import 'package:schedule_testing/course_model.dart';
import 'class_info_widget.dart';

//basically the same as lab (which is like a section)
//lab = [(name, time), (name, time), +button] = (classinfo, classinfo, +button) i.e. contains info for all tut sections, each tut is essentially just 1 class
//can also be thought of as a widget holding class info containers and a button to add more class containers to the listview
class TutsInfoContainer extends StatefulWidget {
  final String name;
  TutsInfoContainer({required this.name});

  List<ClassInfoContainer> tutsInfoContainer = [];

  List<Tutorial> getTutorialsInfo() {
    List<Tutorial> tutorials = [];
    for (ClassInfoContainer classInfoContainer in tutsInfoContainer) {
      ClassTime tutorialTime = classInfoContainer.getClassInfo();
      tutorials.add(Tutorial(tutorialTime: tutorialTime));
    }
    return tutorials;
  }

  @override
  _TutsInfoContainerState createState() => _TutsInfoContainerState();

}

class _TutsInfoContainerState extends State<TutsInfoContainer> {
  // List<ClassInfoContainer> classInfoContainerList = [ClassInfoContainer(name: 'Tutorial 1')];


  void addClassContainer() {
    widget.tutsInfoContainer.add(ClassInfoContainer(
        name: 'Tutorial',
        id: widget.tutsInfoContainer.length,
        onDelete: (int id) {
          setState(() {
            widget.tutsInfoContainer.removeAt(id);
            updateID();
          });
        })
    );
  }

  void updateID() {
    for (int i = 0; i < widget.tutsInfoContainer.length; i++) {
      widget.tutsInfoContainer[i].id = i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Color(0xFFeae3d6),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(widget.name, style: const TextStyle(fontSize: 24.0, color: Color(0xFFe47c43)),),
              ),
              // IconButton(
              //   icon: const Icon(
              //     Icons.close,
              //     color: Color(0xFFe47c43),
              //   ),
              //   onPressed: () {},
              // ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.tutsInfoContainer.length,
            itemBuilder: (context, index) {
              return widget.tutsInfoContainer[index];
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFe47c43),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.all(5.0),
                    ),
                    onPressed: () {
                      setState(() {
                        addClassContainer();
                      });
                    },
                    child: const Icon(
                      Icons.add,
                      size: 60.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}