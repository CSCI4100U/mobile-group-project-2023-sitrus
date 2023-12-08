import 'package:flutter/material.dart';
import 'schedule_class_info_widget.dart';
import 'schedule_course_model.dart';

//section = [(name, time), (name, time), +button] = (classinfo, classinfo) i.e. contains info for a single section, which is usually 1-2 classes
//can also be thought of as a widget holding class info containers and a button to add more class containers to the listview
class SectionInfoContainer extends StatefulWidget {
  final String name;
  int id;
  final Function(int) onDelete;

  SectionInfoContainer({required this.name, required this.id, required this.onDelete});

  List<ClassInfoContainer> classInfoContainerList = [];

  Section getSectionInfo() {
    List<ClassTime> lectureTimes = [];

    for (ClassInfoContainer classInfoContainer in classInfoContainerList) {
      lectureTimes.add(classInfoContainer.getClassInfo());
    }
    Section section = Section(lectureTimes: lectureTimes);
    return section;
  }

  @override
  _SectionInfoContainerState createState() => _SectionInfoContainerState();

}

class _SectionInfoContainerState extends State<SectionInfoContainer> {

  @override
  void initState() {
    super.initState();

    addClassContainer();
  }

  void addClassContainer() {
    widget.classInfoContainerList.add(ClassInfoContainer(
        name: 'Lecture',
        id: widget.classInfoContainerList.length,
        onDelete: (int id) {
          setState(() {
            // print(classInfoContainerList[id].selectedDay);
            widget.classInfoContainerList.removeAt(id);
            updateID();
          });
        })
    );
  }

  void updateID() {
    for (int i = 0; i < widget.classInfoContainerList.length; i++) {
      widget.classInfoContainerList[i].id = i;
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
                child: Text('${widget.name} ${widget.id + 1}', style: const TextStyle(fontSize: 24.0, color: Color(0xFFe47c43)),),
              ),
              IconButton(icon: const Icon(Icons.close, color: Color(0xFFe47c43),),
                onPressed: () {
                  widget.onDelete(widget.id);
                },
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.classInfoContainerList.length,
            itemBuilder: (context, index) {
              return widget.classInfoContainerList[index];
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