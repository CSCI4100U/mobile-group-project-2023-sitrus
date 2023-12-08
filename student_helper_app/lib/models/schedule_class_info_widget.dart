import 'package:flutter/material.dart';
import 'schedule_course_model.dart';

//classinfo = (name, time) i.e. contains info for a single class
//section = [(name, time), (name, time), +button] = (classinfo, classinfo) i.e. contains info for a single section, which is usually 1-2 classes
//course = [[(name, time), (name, time), +button], [(name, time), (name, time), +button], +button] = [(section), (section)] i.e. contains info for a single course, usually a course has 1-3 sections for lectures
//  course will also need to have lab/tut

//classinfo = (name, time) i.e. contains info for a single class
class ClassInfoContainer extends StatefulWidget {
  final String name;
  int id;
  final Function(int) onDelete;

  ClassInfoContainer({required this.name, required this.id, required this.onDelete});

  String selectedDay = 'Monday';
  double lowerValue = 0.0;
  double upperValue = 1.0;

  ClassTime getClassInfo() {
    ClassTime classTime = ClassTime(
        startTime: getStartTime(),
        endTime: getEndTime(),
        dayOfWeek: selectedDay);
    return classTime;
  }

  HourMinute getStartTime() {
    if (lowerValue == 0) {
      return HourMinute(hour: 8, minute: 10);
    } else if (lowerValue == 1) {
      return HourMinute(hour: 9, minute: 40);
    } else if (lowerValue == 2) {
      return HourMinute(hour: 11, minute: 10);
    } else if (lowerValue == 3) {
      return HourMinute(hour: 12, minute: 40);
    } else if (lowerValue == 4) {
      return HourMinute(hour: 14, minute: 10);
    } else if (lowerValue == 5) {
      return HourMinute(hour: 15, minute: 40);
    } else if (lowerValue == 6) {
      return HourMinute(hour: 17, minute: 10);
    } else if (lowerValue == 7) {
      return HourMinute(hour: 18, minute: 40);
    } else  {
      return HourMinute(hour: 20, minute: 10);
    }
  }

  HourMinute getEndTime() {
    if (upperValue == 0) {
      return HourMinute(hour: 9, minute: 30);
    } else if (upperValue == 1) {
      return HourMinute(hour: 11, minute: 00);
    } else if (upperValue == 2) {
      return HourMinute(hour: 12, minute: 30);
    } else if (upperValue == 3) {
      return HourMinute(hour: 14, minute: 00);
    } else if (upperValue == 4) {
      return HourMinute(hour: 15, minute: 30);
    } else if (upperValue == 5) {
      return HourMinute(hour: 17, minute: 00);
    } else if (upperValue == 6) {
      return HourMinute(hour: 18, minute: 30);
    } else if (upperValue == 7) {
      return HourMinute(hour: 20, minute: 00);
    } else  {
      return HourMinute(hour: 21, minute: 30);
    }
  }

  @override
  _ClassInfoContainerState createState() => _ClassInfoContainerState();

}

class _ClassInfoContainerState extends State<ClassInfoContainer> {

  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  final List<String> leftValues = [
    '8:10am', '9:40am', '11:10am', '12:40pm', '2:10pm', '3:40pm', '5:10pm', '6:40pm', '8:10pm',
    '9:30pm' //buffer for the end, since the start and end share the same values. i.e. they both end
    // at 8.0 but only the right side can be at that value; the left side maxes out at 7.0
  ];

  final List<String> rightValues = [
    '8:10am', //buffer for the start
    '9:30am', '11:00am', '12:30pm', '2:00pm', '3:30pm', '5:00pm', '6:30pm', '8:00pm', '9:30pm'
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
                Text('${widget.name} ${widget.id + 1}', style: TextStyle(fontSize: 24.0, color: Colors.white)),
              ),
              IconButton(icon: Icon(Icons.close, color: Colors.white,),
                onPressed: () {
                  widget.onDelete(widget.id);
                },
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var day in daysOfWeek)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selectedDay = day;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.selectedDay == day ? Color(0xFF243f6e) : Color(0xFFeae3d6),
                              border: Border.all(color: Color(0xFFe47c43)),
                            ),
                            child: Text(
                              day.substring(0, 1),
                              style: TextStyle(fontSize: 20.0, color: widget.selectedDay == day ? Color(0xFFeae3d6) : Color(0xFFe47c43)),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              RangeSlider(
                activeColor: Color(0xFF243f6e),
                values: RangeValues(widget.lowerValue, widget.upperValue),
                onChanged: (RangeValues values) {

                  // Ensure a fixed distance between the sliders
                  double newLowerValue = values.start;
                  double newUpperValue = values.end;

                  if (newUpperValue - newLowerValue < unitDistance) {
                    if (widget.lowerValue != newLowerValue) {
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
                    widget.lowerValue = newLowerValue;
                    widget.upperValue = newUpperValue;
                  });
                },
                min: 0.0,
                max: 9.0,
                divisions: leftValues.length - 1,
                labels: RangeLabels(
                  leftValues[widget.lowerValue.round()],
                  rightValues[widget.upperValue.round()],
                ),
              ),
              Text('${widget.selectedDay} ${leftValues[widget.lowerValue.round()]} to ${rightValues[widget.upperValue.round()]}', style: TextStyle(fontSize: 24.0, color: Colors.white),),
            ],
          ),
        ],
      ),
    );
  }
}
