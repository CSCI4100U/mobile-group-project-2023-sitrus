import 'package:flutter/material.dart';
import 'course_model.dart';

/*
class ScheduleFormsWidget {

  Course getCourse() {
    ClassTime classTime = ClassTime(
        HourMinute(startHour.value, startMinute.value),
        HourMinute(endHour.value, endMinute.value));
    Course course = Course("${courseNameController.text}", [classTime]);
    return course;
  }

  final ValueNotifier<int> startHour = ValueNotifier<int>(0);
  final ValueNotifier<int> startMinute = ValueNotifier<int>(0);
  final ValueNotifier<int> endHour = ValueNotifier<int>(0);
  final ValueNotifier<int> endMinute = ValueNotifier<int>(0);
  final ValueNotifier<String> selectedDay = ValueNotifier<String>('Monday');
  final TextEditingController courseNameController = TextEditingController();

  List<int> hours = List.generate(24, (index) => index);
  List<int> minutes = List.generate(60, (index) => index);
  List<String> daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  int? courseNum;

  //
  // int? numClasses;
  // int? numDependencies;
  //
  // ScheduleFormsWidget(this.courseNum, this.numClasses, this.numDependencies);

  Widget build(BuildContext context) {

    return Container(
        color: Colors.blue,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Course ${courseNum! + 1}'),
              TextField(
                controller: courseNameController,
                decoration: InputDecoration(
                  labelText: 'Enter course name',
                ),
              ),
              Container(
                color: Colors.blue[400],
                child:
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Class Meeting Time"),
                          ValueListenableBuilder<String>(
                            valueListenable: selectedDay,
                            builder: (context, value, child) {
                              return DropdownButton<String>(
                                value: value,
                                items: daysOfWeek.map((day) {
                                  return DropdownMenuItem<String>(
                                    value: day,
                                    child: Text(day),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  selectedDay.value = value!;
                                },
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Start Time: ", style: TextStyle(fontSize: 18.0)),
                              ValueListenableBuilder<int>(
                                valueListenable: startHour,
                                builder: (context, value, child) {
                                  return DropdownButton<int>(
                                    value: value,
                                    items: hours.map((hour) {
                                      return DropdownMenuItem<int>(
                                        value: hour,
                                        child: Text('$hour'.padLeft(2, '0')),
                                      );
                                    }).toList(),
                                    onChanged: (int? value) {
                                      startHour.value = value!;
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
                              Text("End Time: ", style: TextStyle(fontSize: 18.0)),
                              ValueListenableBuilder<int>(
                                valueListenable: endHour,
                                builder: (context, value, child) {
                                  return DropdownButton<int>(
                                    value: value,
                                    items: hours.map((hour) {
                                      return DropdownMenuItem<int>(
                                        value: hour,
                                        child: Text('$hour'.padLeft(2, '0')),
                                      );
                                    }).toList(),
                                    onChanged: (int? value) {
                                      endHour.value = value!;
                                    },
                                  );
                                },
                              ),
                              ValueListenableBuilder<int>(
                                valueListenable: endMinute,
                                builder: (context, value, child) {
                                  return DropdownButton<int>(
                                    value: value,
                                    items: minutes.map((minute) {
                                      return DropdownMenuItem<int>(
                                        value: minute,
                                        child: Text('$minute'.padLeft(2, '0')),
                                      );
                                    }).toList(),
                                    onChanged: (int? value) {
                                      endMinute.value = value!;
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
*/