import 'package:flutter/material.dart';

class ScheduleFormsWidget {
  int? courseNum;

  List<int> hours = List.generate(24, (index) => index);
  List<int> minutes = List.generate(60, (index) => index);
  final ValueNotifier<int> selectedHour = ValueNotifier<int>(0);
  final ValueNotifier<int> selectedMinute = ValueNotifier<int>(0);

  //
  int? numClasses;
  int? numDependencies;

  ScheduleFormsWidget(this.courseNum, this.numClasses, this.numDependencies);

  Widget build(BuildContext context) {

    return Container(
        color: Colors.blue,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Course ${courseNum! + 1} Name:'),
              ),
              Container(
                color: Colors.blue[400],
                child:
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Class Meeting Time"),
                          //NEED TO FIGURE OUT HOW TO MAKE THE DROPDOWN ACTUALLY WORK
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Start Time: ", style: TextStyle(fontSize: 18.0)),
                              ValueListenableBuilder<int>(
                                valueListenable: selectedHour,
                                builder: (context, value, child) {
                                  return DropdownButton<int>(
                                    value: value,
                                    items: hours.map((hour) {
                                      return DropdownMenuItem<int>(
                                        value: hour,
                                        child: Text('$hour' + 'h'),
                                      );
                                    }).toList(),
                                    onChanged: (int? value) {
                                      selectedHour.value = value!;
                                    },
                                  );
                                },
                              ),
                              ValueListenableBuilder<int>(
                                valueListenable: selectedMinute,
                                builder: (context, value, child) {
                                  return DropdownButton<int>(
                                    value: value,
                                    items: minutes.map((minute) {
                                      return DropdownMenuItem<int>(
                                        value: minute,
                                        child: Text('$minute' + 'm'),
                                      );
                                    }).toList(),
                                    onChanged: (int? value) {
                                      selectedMinute.value = value!;
                                    },
                                  );
                                },
                              ),
                              ],
                          ),
                          Text(
                    'Selected Time: ${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 18),
                  ),
            ]),
          ),
        ]));
  }
}
