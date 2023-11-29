import 'package:flutter/material.dart';
import 'class_info_widget.dart';

//section = [(name, time), (name, time), +button] = (classinfo, classinfo) i.e. contains info for a single section, which is usually 1-2 classes
//can also be thought of as a widget holding class info containers and a button to add more class containers to the listview
class SectionInfoContainer extends StatefulWidget {
  final String name;
  SectionInfoContainer({required this.name});

  @override
  _SectionInfoContainerState createState() => _SectionInfoContainerState();
}

class _SectionInfoContainerState extends State<SectionInfoContainer> {
  List<ClassInfoContainer> classInfoContainerList = [];

  void addClassContainer() {
    classInfoContainerList.add(ClassInfoContainer(
        name: 'Lecture ${classInfoContainerList.length + 1}',
        onDelete: () {
          setState(() {
            classInfoContainerList.removeAt(0);
          });
        }));
  }

  void deleteClassContainer() {
    classInfoContainerList.removeLast();
  }

  @override
  Widget build(BuildContext context) {

    // classInfoContainerList.add(ClassInfoContainer(
    //   name: 'Lecture 1',
    //   onDelete: () {
    //     setState(() {
    //       classInfoContainerList.removeAt(classInfoContainerList.length);
    //     });
    //   },
    // ));

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
                onPressed: () {

                },
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: classInfoContainerList.length,
            itemBuilder: (context, index) {
              return classInfoContainerList[index];
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