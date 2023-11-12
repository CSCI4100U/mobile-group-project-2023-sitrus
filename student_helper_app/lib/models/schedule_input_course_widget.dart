import 'package:flutter/material.dart';
import 'schedule_course_model.dart';

class InputCourseWidget {
  Course getCourse(Color color) {
    ClassTime classTime = ClassTime(
        HourMinute(startHour.value, startMinute.value),
        HourMinute(endHour.value, endMinute.value),
        "${selectedDay.value}");
    Course course = Course("${courseNameController.text}", [classTime], color);
    return course;
  }

  final ValueNotifier<int> startHour = ValueNotifier<int>(8);
  final ValueNotifier<int> startMinute = ValueNotifier<int>(0);
  final ValueNotifier<int> endHour = ValueNotifier<int>(8);
  final ValueNotifier<int> endMinute = ValueNotifier<int>(0);
  final ValueNotifier<String> selectedDay = ValueNotifier<String>('Monday');
  final TextEditingController courseNameController = TextEditingController();

  List<int> hours = List.generate(14,
      (index) => index + 8); //list from [8, 9, ..., 21] -> 8am, 9am,..., 9pm
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

  //todo (for final): add in dependencies input form inside this widget
  //todo (for final): add buttons in each input form to allow the user to add \
  // \ more inputs so it's dynamic and adjusts to the number of courses, class \
  // \ times per course, and number of dependencies the user needs
  //some potential variables for future (final) use
  // int? numClasses;
  // int? numDependencies;
  // ScheduleFormsWidget(this.courseNum, this.numClasses, this.numDependencies);

  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Course ${courseNum! + 1}'),
              TextField(
                controller: courseNameController,
                decoration: InputDecoration(
                  labelText: 'Enter course name',
                ),
              ),
              Container(
                color: Colors.blue[400],
                child: Column(
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
                          Text("Start Time: ",
                              style: TextStyle(fontSize: 18.0)),
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
                          Text(
                            ':',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: startMinute,
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
                                  startMinute.value = value!;
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
                          Text("End Time: ", style: TextStyle(fontSize: 18.0)),
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
                    ]),
              ),
              ValueListenableBuilder<int>(
                  valueListenable: startHour,
                  builder: (context, startHourValue, child) {
                    return ValueListenableBuilder<int>(
                      valueListenable: startMinute,
                      builder: (context, startMinuteValue, child) {
                        return ValueListenableBuilder<int>(
                            valueListenable: endHour,
                            builder: (context, endHourValue, child) {
                              return ValueListenableBuilder<int>(
                                valueListenable: endMinute,
                                builder: (context, endMinuteValue, child) {
                                  return ValueListenableBuilder<String>(
                                    valueListenable: selectedDay,
                                    builder:
                                        (context, selectedDayValue, child) {
                                      return Text(
                                        '${startHourValue.toString().padLeft(2, '0')}:${startMinuteValue.toString().padLeft(2, '0')} to ${endHourValue.toString().padLeft(2, '0')}:${endMinuteValue.toString().padLeft(2, '0')} on $selectedDayValue',
                                        style: TextStyle(fontSize: 18),
                                      );
                                    },
                                  );
                                },
                              );
                            });
                      },
                    );
                  }),
            ]));
  }
}
