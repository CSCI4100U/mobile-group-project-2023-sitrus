// import 'package:flutter/material.dart';
// import 'schedule_course_model.dart';
//
// class InputCourseWidget {
//   Course getCourse(Color color) {
//     ClassTime classTime = ClassTime(
//         HourMinute(startHour.value, startMinute.value),
//         HourMinute(endHour.value, endMinute.value),
//         "${selectedDay.value}");
//     Course course = Course("${courseNameController.text}", [classTime], color);
//     return course;
//   }
//
//   final ValueNotifier<int> startHour = ValueNotifier<int>(8);
//   final ValueNotifier<int> startMinute = ValueNotifier<int>(0);
//   final ValueNotifier<int> endHour = ValueNotifier<int>(8);
//   final ValueNotifier<int> endMinute = ValueNotifier<int>(0);
//   final ValueNotifier<String> selectedDay = ValueNotifier<String>('Monday');
//   final TextEditingController courseNameController = TextEditingController();
//
//   //temp
//   final ValueNotifier<int> startHour2 = ValueNotifier<int>(8);
//   final ValueNotifier<int> startMinute2 = ValueNotifier<int>(0);
//   final ValueNotifier<int> endHour2 = ValueNotifier<int>(8);
//   final ValueNotifier<int> endMinute2 = ValueNotifier<int>(0);
//   final ValueNotifier<String> selectedDay2 = ValueNotifier<String>('Monday');
//
//   List<int> hours = List.generate(14,
//       (index) => index + 8); //list from [8, 9, ..., 21] -> 8am, 9am,..., 9pm
//   List<int> minutes = List.generate(60, (index) => index);
//   List<String> daysOfWeek = [
//     'Sunday',
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday'
//   ];
//
//   // int? courseNum;
//
//   //todo (for final): add in dependencies input form inside this widget
//   //todo (for final): add buttons in each input form to allow the user to add \
//   // \ more inputs so it's dynamic and adjusts to the number of courses, class \
//   // \ times per course, and number of dependencies the user needs
//   //some potential variables for future (final) use
//   // int? numClasses;
//   // int? numDependencies;
//   // ScheduleFormsWidget(this.courseNum, this.numClasses, this.numDependencies);
//
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.blue,
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               // Text('Course ${courseNum! + 1}'),
//               TextField(
//                 controller: courseNameController,
//                 decoration: InputDecoration(
//                     labelText: 'Enter course name',
//                     labelStyle: TextStyle(fontSize: 24.0)
//                 ),
//               ),
//               Container(
//                 color: Colors.blue[400],
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(children: [
//                         Text("Class Meeting Time 1", style: TextStyle(fontSize: 24.0)),
//                       ]),
//                       ValueListenableBuilder<String>(
//                         valueListenable: selectedDay,
//                         builder: (context, value, child) {
//                           return DropdownButton<String>(
//                             style:
//                                 TextStyle(fontSize: 32.0, color: Colors.black),
//                             value: value,
//                             items: daysOfWeek.map((day) {
//                               return DropdownMenuItem<String>(
//                                 value: day,
//                                 child: Text(day),
//                               );
//                             }).toList(),
//                             onChanged: (String? value) {
//                               selectedDay.value = value!;
//                             },
//                           );
//                         },
//                       ),
//                       Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("Start ", style: TextStyle(fontSize: 32.0)),
//                             ValueListenableBuilder<int>(
//                               valueListenable: startHour,
//                               builder: (context, value, child) {
//                                 return DropdownButton<int>(
//                                   style: TextStyle(
//                                       fontSize: 32.0, color: Colors.black),
//                                   value: value,
//                                   items: hours.map((hour) {
//                                     return DropdownMenuItem<int>(
//                                       value: hour,
//                                       child: Text('$hour'.padLeft(2, '0')),
//                                     );
//                                   }).toList(),
//                                   onChanged: (int? value) {
//                                     startHour.value = value!;
//                                   },
//                                 );
//                               },
//                             ),
//                             Text(
//                               ':',
//                               style: TextStyle(fontSize: 32.0),
//                             ),
//                             ValueListenableBuilder<int>(
//                               valueListenable: startMinute,
//                               builder: (context, value, child) {
//                                 return DropdownButton<int>(
//                                   style: TextStyle(
//                                       fontSize: 32.0, color: Colors.black),
//                                   value: value,
//                                   items: minutes.map((minute) {
//                                     return DropdownMenuItem<int>(
//                                       value: minute,
//                                       child: Text('$minute'.padLeft(2, '0')),
//                                     );
//                                   }).toList(),
//                                   onChanged: (int? value) {
//                                     startMinute.value = value!;
//                                   },
//                                 );
//                               },
//                             ),
//                           ]),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("End ", style: TextStyle(fontSize: 32.0)),
//                           ValueListenableBuilder<int>(
//                             valueListenable: endHour,
//                             builder: (context, value, child) {
//                               return DropdownButton<int>(
//                                 style: TextStyle(
//                                     fontSize: 32.0, color: Colors.black),
//                                 value: value,
//                                 items: hours.map((hour) {
//                                   return DropdownMenuItem<int>(
//                                     value: hour,
//                                     child: Text('$hour'.padLeft(2, '0')),
//                                   );
//                                 }).toList(),
//                                 onChanged: (int? value) {
//                                   endHour.value = value!;
//                                 },
//                               );
//                             },
//                           ),
//                           Text(
//                             ':',
//                             style: TextStyle(fontSize: 32.0),
//                           ),
//                           ValueListenableBuilder<int>(
//                             valueListenable: endMinute,
//                             builder: (context, value, child) {
//                               return DropdownButton<int>(
//                                 style: TextStyle(
//                                     fontSize: 32.0, color: Colors.black),
//                                 value: value,
//                                 items: minutes.map((minute) {
//                                   return DropdownMenuItem<int>(
//                                     value: minute,
//                                     child: Text('$minute'.padLeft(2, '0')),
//                                   );
//                                 }).toList(),
//                                 onChanged: (int? value) {
//                                   endMinute.value = value!;
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                       ValueListenableBuilder<int>(
//                           valueListenable: startHour,
//                           builder: (context, startHourValue, child) {
//                             return ValueListenableBuilder<int>(
//                               valueListenable: startMinute,
//                               builder: (context, startMinuteValue, child) {
//                                 return ValueListenableBuilder<int>(
//                                     valueListenable: endHour,
//                                     builder: (context, endHourValue, child) {
//                                       return ValueListenableBuilder<int>(
//                                         valueListenable: endMinute,
//                                         builder:
//                                             (context, endMinuteValue, child) {
//                                           return ValueListenableBuilder<String>(
//                                             valueListenable: selectedDay,
//                                             builder: (context, selectedDayValue,
//                                                 child) {
//                                               return Text(
//                                                 '${startHourValue.toString().padLeft(2, '0')}:${startMinuteValue.toString().padLeft(2, '0')} to ${endHourValue.toString().padLeft(2, '0')}:${endMinuteValue.toString().padLeft(2, '0')} on $selectedDayValue',
//                                                 style: TextStyle(fontSize: 18),
//                                               );
//                                             },
//                                           );
//                                         },
//                                       );
//                                     });
//                               },
//                             );
//                           }),
//                     ]),
//               ),
//               // //temp
//               // Container(
//               //   color: Colors.blue[400],
//               //   child: Column(
//               //       mainAxisAlignment: MainAxisAlignment.center,
//               //       children: [
//               //         Row(children: [
//               //           Text("Class Meeting Time 2", style: TextStyle(fontSize: 24.0)),
//               //         ]),
//               //         ValueListenableBuilder<String>(
//               //           valueListenable: selectedDay2,
//               //           builder: (context, value, child) {
//               //             return DropdownButton<String>(
//               //               style:
//               //               TextStyle(fontSize: 32.0, color: Colors.black),
//               //               value: value,
//               //               items: daysOfWeek.map((day) {
//               //                 return DropdownMenuItem<String>(
//               //                   value: day,
//               //                   child: Text(day),
//               //                 );
//               //               }).toList(),
//               //               onChanged: (String? value) {
//               //                 selectedDay2.value = value!;
//               //               },
//               //             );
//               //           },
//               //         ),
//               //         Row(
//               //             mainAxisAlignment: MainAxisAlignment.center,
//               //             children: [
//               //               Text("Start ", style: TextStyle(fontSize: 32.0)),
//               //               ValueListenableBuilder<int>(
//               //                 valueListenable: startHour2,
//               //                 builder: (context, value, child) {
//               //                   return DropdownButton<int>(
//               //                     style: TextStyle(
//               //                         fontSize: 32.0, color: Colors.black),
//               //                     value: value,
//               //                     items: hours.map((hour) {
//               //                       return DropdownMenuItem<int>(
//               //                         value: hour,
//               //                         child: Text('$hour'.padLeft(2, '0')),
//               //                       );
//               //                     }).toList(),
//               //                     onChanged: (int? value) {
//               //                       startHour2.value = value!;
//               //                     },
//               //                   );
//               //                 },
//               //               ),
//               //               Text(
//               //                 ':',
//               //                 style: TextStyle(fontSize: 32.0),
//               //               ),
//               //               ValueListenableBuilder<int>(
//               //                 valueListenable: startMinute2,
//               //                 builder: (context, value, child) {
//               //                   return DropdownButton<int>(
//               //                     style: TextStyle(
//               //                         fontSize: 32.0, color: Colors.black),
//               //                     value: value,
//               //                     items: minutes.map((minute) {
//               //                       return DropdownMenuItem<int>(
//               //                         value: minute,
//               //                         child: Text('$minute'.padLeft(2, '0')),
//               //                       );
//               //                     }).toList(),
//               //                     onChanged: (int? value) {
//               //                       startMinute2.value = value!;
//               //                     },
//               //                   );
//               //                 },
//               //               ),
//               //             ]),
//               //         Row(
//               //           mainAxisAlignment: MainAxisAlignment.center,
//               //           children: [
//               //             Text("End ", style: TextStyle(fontSize: 32.0)),
//               //             ValueListenableBuilder<int>(
//               //               valueListenable: endHour2,
//               //               builder: (context, value, child) {
//               //                 return DropdownButton<int>(
//               //                   style: TextStyle(
//               //                       fontSize: 32.0, color: Colors.black),
//               //                   value: value,
//               //                   items: hours.map((hour) {
//               //                     return DropdownMenuItem<int>(
//               //                       value: hour,
//               //                       child: Text('$hour'.padLeft(2, '0')),
//               //                     );
//               //                   }).toList(),
//               //                   onChanged: (int? value) {
//               //                     endHour2.value = value!;
//               //                   },
//               //                 );
//               //               },
//               //             ),
//               //             Text(
//               //               ':',
//               //               style: TextStyle(fontSize: 32.0),
//               //             ),
//               //             ValueListenableBuilder<int>(
//               //               valueListenable: endMinute2,
//               //               builder: (context, value, child) {
//               //                 return DropdownButton<int>(
//               //                   // focusColor: Colors.indigo,
//               //                   style: TextStyle(
//               //                       fontSize: 32.0, color: Colors.black),
//               //                   value: value,
//               //                   items: minutes.map((minute) {
//               //                     return DropdownMenuItem<int>(
//               //                       value: minute,
//               //                       child: Text('$minute'.padLeft(2, '0')),
//               //                     );
//               //                   }).toList(),
//               //                   onChanged: (int? value) {
//               //                     endMinute2.value = value!;
//               //                   },
//               //                 );
//               //               },
//               //             ),
//               //           ],
//               //         ),
//               //         ValueListenableBuilder<int>(
//               //             valueListenable: startHour2,
//               //             builder: (context, startHourValue, child) {
//               //               return ValueListenableBuilder<int>(
//               //                 valueListenable: startMinute2,
//               //                 builder: (context, startMinuteValue, child) {
//               //                   return ValueListenableBuilder<int>(
//               //                       valueListenable: endHour2,
//               //                       builder: (context, endHourValue, child) {
//               //                         return ValueListenableBuilder<int>(
//               //                           valueListenable: endMinute2,
//               //                           builder:
//               //                               (context, endMinuteValue, child) {
//               //                             return ValueListenableBuilder<String>(
//               //                               valueListenable: selectedDay2,
//               //                               builder: (context, selectedDayValue,
//               //                                   child) {
//               //                                 return Text(
//               //                                   '${startHourValue.toString().padLeft(2, '0')}:${startMinuteValue.toString().padLeft(2, '0')} to ${endHourValue.toString().padLeft(2, '0')}:${endMinuteValue.toString().padLeft(2, '0')} on $selectedDayValue',
//               //                                   style: TextStyle(fontSize: 18),
//               //                                 );
//               //                               },
//               //                             );
//               //                           },
//               //                         );
//               //                       });
//               //                 },
//               //               );
//               //             }),
//               //       ]),
//               // ),
//               // OutlinedButton.icon(
//               //     icon: Icon(
//               //       Icons.add,
//               //       size: 30,
//               //     ),
//               //     style: OutlinedButton.styleFrom(
//               //         foregroundColor: Colors.black,
//               //         backgroundColor: Colors.blue[400],
//               //         minimumSize: Size(300, 30),
//               //         shape: RoundedRectangleBorder(
//               //             borderRadius: BorderRadius.circular(0.0)),
//               //         textStyle: TextStyle(
//               //           fontSize: 24,
//               //         )),
//               //     onPressed: () {},
//               //     label: Text("Add Class")),
//               // //
//               SizedBox(
//                 height: 10.0,
//               ),
//             ]));
//   }
// }
