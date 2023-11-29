import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFe47c43)),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Day Selector'),
        ),
        body: DaySelector(),
      ),
    );
  }
}

class DaySelector extends StatefulWidget {
  @override
  _DaySelectorState createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  String selected = 'Monday';
  final ValueNotifier<String> selectedDay = ValueNotifier<String>('Monday');

  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var day in daysOfWeek)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = day;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected == day ? Color(0xFF243f6e) : Color(0xFFeae3d6),
                    border: Border.all(color: Color(0xFFe47c43)),
                  ),
                  child: Text(
                    day.substring(0, 1),
                    style: TextStyle(fontSize: 20.0, color: selected == day ? Color(0xFFeae3d6) : Color(0xFFe47c43)),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 20.0),
        Text(
          '$selected',
          style: TextStyle(fontSize: 24.0),
        ),
        // ValueListenableBuilder<String>(
        //   valueListenable: selectedDay,
        //   builder: (context, value, child) {
        //     return Row(
        //       children: [
        //         for (String day in daysOfWeek)
        //         Row(
        //           children: [
        //             Radio(
        //               value: value,
        //               groupValue: selectedDay.value,
        //               onChanged: (String? value) {
        //                 selectedDay.value = value!;
        //               },
        //             ),
        //             Text(
        //               day.substring(0, 1), // Display only the initial letter
        //               style: TextStyle(fontSize: 20.0),
        //             ),
        //           ],
        //         ),
        //       ],
        //     );
        //   },
        // ),
        // Text(
        //   selectedDay.value, // Display only the initial letter
        //   style: TextStyle(fontSize: 20.0),
        // ),
        SizedBox(height: 40.0,),
        ValueListenableBuilder<String>(
          valueListenable: selectedDay,
          builder: (context, value, child) {
            return DropdownButton<String>(
              style:
              TextStyle(fontSize: 32.0, color: Colors.black),
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
      ],
    );
  }
}
