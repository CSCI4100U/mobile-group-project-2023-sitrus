import 'package:flutter/material.dart';

class ClassContainerList extends StatefulWidget {
  // final String name;
  // ClassContainerList({required this.name});

  @override
  _ClassContainerListState createState() => _ClassContainerListState();
}

class _ClassContainerListState extends State<ClassContainerList> {
  List<ClassContainer> classContainers = [ClassContainer(name: 'Lecture 1')];

  void addClassContainer() {
    classContainers.add(ClassContainer(name: 'Lecture ${classContainers.length + 1}'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Section ',
          style: TextStyle(fontSize: 24.0),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: classContainers.length,
          itemBuilder: (context, index) {
            return classContainers[index];
          },
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          child: OutlinedButton.icon(
            icon: Icon(
              Icons.add,
              size: 36.0,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
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
            label: Text("Add Lecture"),
          ),
        ),
      ],
    );
  }
}

class ClassContainer extends StatefulWidget {
  final String name;
  ClassContainer({required this.name});

  @override
  _ClassContainerState createState() => _ClassContainerState();
}

class _ClassContainerState extends State<ClassContainer> {
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
      padding: EdgeInsets.all(16.0),
      // margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name, style: TextStyle(fontSize: 24.0)),
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
              Text('${leftValues[_lowerValue.round()]} to ${rightValues[_upperValue.round()]}', style: TextStyle(fontSize: 24.0),),
            ],
          ),
        ],
      ),
    );
  }
}
