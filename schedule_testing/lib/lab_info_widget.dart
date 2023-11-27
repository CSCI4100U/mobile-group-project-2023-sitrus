import 'package:flutter/material.dart';
import 'class_info_widget.dart';

//basically the same as tutorial (which is like a section)
//lab = [(name, time), (name, time), +button] = (classinfo, classinfo, +button) i.e. contains info for all lab sections, each lab is essentially just 1 class
//can also be thought of as a widget holding class info containers and a button to add more class containers to the listview
class LabsInfoContainer extends StatefulWidget {
  final String name;
  LabsInfoContainer({required this.name});

  @override
  _LabsInfoContainerState createState() => _LabsInfoContainerState();
}

class _LabsInfoContainerState extends State<LabsInfoContainer> {
  // List<ClassInfoContainer> classInfoContainerList = [ClassInfoContainer(name: 'Laboratory 1')];
  List<ClassInfoContainer> labsInfoContainer = [];

  void addClassContainer() {
    labsInfoContainer.add(ClassInfoContainer(
        name: 'Laboratory ${labsInfoContainer.length + 1}',
        onDelete: () {
          setState(() {
            labsInfoContainer.removeAt(labsInfoContainer.length - 1);
          });
        }));
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
              IconButton(icon: const Icon(Icons.close, color: Color(0xFFe47c43),),
                onPressed: () {},
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: labsInfoContainer.length,
            itemBuilder: (context, index) {
              return labsInfoContainer[index];
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
            child: OutlinedButton.icon(
              icon: Icon(
                Icons.add,
                size: 36.0,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFe47c43),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                textStyle: TextStyle(
                  fontSize: 36.0,
                ),
              ),
              onPressed: () {
                setState(() {
                  addClassContainer();
                });
              },
              label: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    EdgeInsets.only(right: 32.0, top: 20.0, bottom: 20.0),
                    child: Text(
                      "Add Laboratory",
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}