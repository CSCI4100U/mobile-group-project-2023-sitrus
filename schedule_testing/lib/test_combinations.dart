import 'package:flutter/material.dart';

// import 'schedule_model.dart';
import 'course_model.dart';
// import 'rectangle_model.dart';

void main() {

  HourMinute eight_ten = HourMinute(8, 10);
  HourMinute nine_fourty = HourMinute(9, 40);
  HourMinute eleven_ten = HourMinute(11, 10);
  HourMinute twelve_forty = HourMinute(12, 40);
  HourMinute two_ten = HourMinute(2 +12, 10);
  HourMinute three_fourty = HourMinute(3 +12, 40);

  HourMinute nine_thirty = HourMinute(9, 30);
  HourMinute eleven_0 = HourMinute(11, 00);
  HourMinute twelve_thirty = HourMinute(12, 30);
  HourMinute two_0 = HourMinute(2 +12, 00);
  HourMinute three_thirty = HourMinute(3 +12, 30);
  HourMinute five_0 = HourMinute(5 +12, 00);

  ClassTime mon8_9 = ClassTime(eight_ten, nine_thirty, 'Monday');
  ClassTime mon9_11 = ClassTime(nine_fourty, eleven_0, 'Monday');
  ClassTime mon11_12 = ClassTime(eleven_ten, twelve_thirty, 'Monday');
  ClassTime mon2_3 = ClassTime(two_ten, three_thirty, 'Monday');
  ClassTime tue8_9 = ClassTime(eight_ten, nine_thirty, 'Tuesday');
  ClassTime tue9_11 = ClassTime(nine_fourty, eleven_0, 'Tuesday');
  ClassTime tue11_12 = ClassTime(eleven_ten, twelve_thirty, 'Tuesday');
  ClassTime tue2_3 = ClassTime(two_ten, three_thirty, 'Tuesday');
  ClassTime wed8_9 = ClassTime(eight_ten, nine_thirty, 'Wednesday');
  ClassTime wed9_11 = ClassTime(nine_fourty, eleven_0, 'Wednesday');
  ClassTime wed11_12 = ClassTime(eleven_ten, twelve_thirty, 'Wednesday');
  ClassTime wed2_3 = ClassTime(two_ten, three_thirty, 'Wednesday');
  ClassTime thu8_9 = ClassTime(eight_ten, nine_thirty, 'Thursday');
  ClassTime thu9_11 = ClassTime(nine_fourty, eleven_0, 'Thursday');
  ClassTime thu11_12 = ClassTime(eleven_ten, twelve_thirty, 'Thursday');
  ClassTime thu2_3 = ClassTime(two_ten, three_thirty, 'Thursday');
  ClassTime fri8_9 = ClassTime(eight_ten, nine_thirty, 'Friday');
  ClassTime fri9_11 = ClassTime(nine_fourty, eleven_0, 'Friday');
  ClassTime fri11_12 = ClassTime(eleven_ten, twelve_thirty, 'Friday');
  ClassTime fri2_3 = ClassTime(two_ten, three_thirty, 'Friday');

  Section pl_sec1 = Section([mon8_9]);
  Section pl_sec2 = Section([tue8_9]);
  Section prob_sec1 = Section([wed8_9, fri8_9]);
  Section md_sec1 = Section([wed9_11, fri9_11]);
  Section md_sec2 = Section([wed2_3, fri2_3]);
  Section ada_sec1 = Section([mon11_12, thu11_12]);
  Section ada_sec2 = Section([mon2_3, thu2_3]);
  Section eth_sec1 = Section([wed11_12]);
  Section d_sec1 = Section([mon9_11, tue9_11]);

  List<Section> pl_secs = [pl_sec1, pl_sec2];
  List<Section> prob_secs = [prob_sec1];
  List<Section> md_secs = [md_sec1, md_sec2];
  List<Section> ada_secs = [ada_sec1, ada_sec2];
  List<Section> eth_secs = [eth_sec1];
  List<Section> d_secs = [d_sec1];

  List<Tutorial> tutorials = [];
  List<Laboratory> labs = [];

  Course pl = Course('1 pl', pl_secs, tutorials, labs, Colors.red);
  Course prob = Course('2 prob', prob_secs, tutorials, labs, Colors.green);
  Course md = Course('3 md', md_secs, tutorials, labs, Colors.brown);
  Course ada = Course('4 ada', ada_secs, tutorials, labs, Colors.blue);
  Course eth = Course('5 eth', eth_secs, tutorials, labs, Colors.purple);
  Course d = Course('6 d', d_secs, tutorials, labs, Colors.orange);

  List<Course> coursesFromInput = [
    pl,
    prob,
    md,
    ada,
    eth,
    // d,
  ];

  int? numOfCoursesInSchedule = 5; //this will be taken from user input like; however, doing hard coded 5 for demo

  Combinations comb = Combinations(coursesFromInput: coursesFromInput);

  comb.getAllCombinations(coursesFromInput, numOfCoursesInSchedule, []);
  for (List<Course> schedule in comb.schedules!) {
    for (Course course in schedule) {
      print(course.courseName);
    }
    print('----schedule---');
  }

  //want to create new schedule with 11111, then 21111, then 12111, then 22111, then 11211, and so on
  // 1 represents sec 1, 2 represents sec 2. place of digit represents

}

class Combinations {
  List<Course> coursesFromInput;

  Combinations({required this.coursesFromInput});

  List<List<Course>>? schedules = [];

  void getAllCombinations(List<Course> courses, int numOfCoursesInSchedule, List<Course> currentCombination) {
    if (numOfCoursesInSchedule == 0) {
      schedules!.add(List.from(currentCombination));
      return;
    }

    for (int i = 0; i <= courses.length - numOfCoursesInSchedule; i++) {
      currentCombination.add(courses[i]);
      getAllCombinations(courses.sublist(i + 1), numOfCoursesInSchedule - 1,
          currentCombination);
      currentCombination.removeLast();
    }
  }

}