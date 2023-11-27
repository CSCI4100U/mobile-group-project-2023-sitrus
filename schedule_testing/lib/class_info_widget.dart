import 'package:flutter/material.dart';

//classinfo = (name, time) i.e. contains info for a single class
//section = [(name, time), (name, time), +button] = (classinfo, classinfo) i.e. contains info for a single section, which is usually 1-2 classes
//course = [[(name, time), (name, time), +button], [(name, time), (name, time), +button], +button] = [(section), (section)] i.e. contains info for a single course, usually a course has 1-3 sections for lectures
//  course will also need to have lab/tut

//classinfo = (name, time) i.e. contains info for a single class
class ClassInfoContainer extends StatefulWidget {
  final String name;
  final VoidCallback onDelete;
  //int id

  ClassInfoContainer({required this.name, required this.onDelete});

  @override
  _ClassInfoContainerState createState() => _ClassInfoContainerState();
}

class _ClassInfoContainerState extends State<ClassInfoContainer> {
  double _lowerValue = 0.0;
  double _upperValue = 1.0;

  final List<String> leftValues = [
    '8:10 am', '9:40 am', '11:10 am', '12:40 pm', '2:10 pm', '3:40 pm', '5:10 pm', '6:40 pm', '8:10 pm',
    '9:30 pm' //buffer for the end, since the start and end share the same values. i.e. they both end
    // at 8.0 but only the right side can be at that value; the left side maxes out at 7.0
  ];

  final List<String> rightValues = [
    '8:10 am', //buffer for the start
    '9:30 am', '11:00 am', '12:30 pm', '2:00 pm', '3:30 pm', '5:00 pm', '6:30 pm', '8:00 pm', '9:30 pm'
  ];

  final double unitDistance = 1.0;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Color(0xFFe47c43),
        borderRadius: BorderRadius.circular(10.0),
        // border: Border.all(color: Colors.black),
        // borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child:
                  Text(widget.name, style: TextStyle(fontSize: 24.0, color: Colors.white)),
              ),
              IconButton(icon: Icon(Icons.close, color: Colors.white,),
                  onPressed: () {
                    widget.onDelete();
                  },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RangeSlider(
                values: RangeValues(_lowerValue, _upperValue),
                onChanged: (RangeValues values) {

                  // Ensure a fixed distance between the sliders
                  double newLowerValue = values.start;
                  double newUpperValue = values.end;

                  if (newUpperValue - newLowerValue < unitDistance) {
                    if (_lowerValue != newLowerValue) {
                      if (newUpperValue >= 9.0) {
                        newUpperValue = 9.0;
                        newLowerValue = newUpperValue - unitDistance;
                      } else {
                        newUpperValue = newLowerValue + unitDistance;
                      }
                    } else {
                      if (newLowerValue <= 0.0) {
                        newLowerValue = 0.0;
                        newUpperValue = newLowerValue + unitDistance;
                      } else {
                        newLowerValue = newUpperValue - unitDistance;
                      }
                    }
                  }
                  setState(() {
                    _lowerValue = newLowerValue;
                    _upperValue = newUpperValue;
                  });
                },
                min: 0.0,
                max: 9.0,
                divisions: leftValues.length - 1,
                labels: RangeLabels(
                  leftValues[_lowerValue.round()],
                  rightValues[_upperValue.round()],
                ),
              ),
              Text('${leftValues[_lowerValue.round()]} to ${rightValues[_upperValue.round()]}', style: TextStyle(fontSize: 24.0, color: Colors.white),),
            ],
          ),
        ],
      ),
    );
  }
}
