import 'package:flutter/material.dart';
import 'package:schedule_testing/course_model.dart';
import 'class_info_widget.dart';

//basically the same as tutorial (which is like a section)
//lab = [(name, time), (name, time), +button] = (classinfo, classinfo, +button) i.e. contains info for all lab sections, each lab is essentially just 1 class
//can also be thought of as a widget holding class info containers and a button to add more class containers to the listview
class LabsInfoContainer extends StatefulWidget {
  final String name;
  LabsInfoContainer({required this.name});

  List<ClassInfoContainer> labsInfoContainer = [];

  List<Laboratory> getLabsInfo() {
    List<Laboratory> labs = [];
    for (ClassInfoContainer classInfoContainer in labsInfoContainer) {
      ClassTime labTime = classInfoContainer.getClassInfo();
      labs.add(Laboratory(labTime: labTime));
    }
    return labs;
  }

  @override
  _LabsInfoContainerState createState() => _LabsInfoContainerState();

}

class _LabsInfoContainerState extends State<LabsInfoContainer> {

  void addClassContainer() {
    widget.labsInfoContainer.add(ClassInfoContainer(
        name: 'Laboratory',
        id: widget.labsInfoContainer.length,
        onDelete: (int id) {
          setState(() {
            widget.labsInfoContainer.removeAt(id);
            updateID();
          });
        })
    );
  }

  void updateID() {
    for (int i = 0; i < widget.labsInfoContainer.length; i++) {
      widget.labsInfoContainer[i].id = i;
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
              // IconButton(icon: const Icon(Icons.close, color: Color(0xFFe47c43),),
              //   onPressed: () {},
              // ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.labsInfoContainer.length,
            itemBuilder: (context, index) {
              return widget.labsInfoContainer[index];
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
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