import 'package:flutter/material.dart';

// import 'schedule_model.dart';
import 'course_model.dart';
// import 'rectangle_model.dart';

//treat this as the build method?
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
  // Section md_sec2 = Section([wed2_3, fri2_3]);
  Section md_sec2 = Section([tue2_3, thu2_3]);
  Section ada_sec1 = Section([mon11_12, thu11_12]);
  // Section ada_sec2 = Section([mon2_3, thu2_3]);
  Section ada_sec2 = Section([tue2_3, thu2_3]);
  Section eth_sec1 = Section([wed11_12]);
  Section d_sec1 = Section([mon9_11, tue9_11]);

  List<Section> pl_secs = [pl_sec1, pl_sec2];
  List<Section> prob_secs = [prob_sec1];
  List<Section> md_secs = [md_sec1, md_sec2];
  List<Section> ada_secs = [ada_sec1];
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
    d,
  ];

  int? numOfCoursesInSchedule = 5; //this will be taken from user input like; however, doing hard coded 5


  Combinations comb = Combinations(coursesFromInput: coursesFromInput);

  comb.getAllCourseCombinations(coursesFromInput, numOfCoursesInSchedule, []);
  // for (List<Course> schedule in comb.schedules!) {
  //   for (Course course in schedule) {
  //     print(course.courseName);
  //   }
  //   print('----schedule---');
  // }
  //expected output from above (with comb.schedules = [pl, prob, md, ada, eth]:
  //'pl' 'prob' 'md' 'ada' 'eth'

  for (List<Course> schedule in comb.schedules) {
    comb.getAllOneSectionCombinations(schedule);
  }
  for (List<Course> schedule in comb.schedulesOneSection) {
    for (Course course in schedule) {
      print('${course.courseName}, ${course.sections[0].lectureTimes?[0].dayOfWeek}');
    }
    print('----schedule---');
  }
  //expected output from above (with comb.schedules = [pl, prob, md, ada, eth]:
  //c1.sec[0],   c2.sec[0],        c3.sec[0],      c4.sec[0],    c5.sec[0]
  //1 pl monday, 2 prob wednesday, 3 md wednesday, 4 ada monday, 5 eth wednesday
  //c1.sec[0],   c2.sec[0],        c3.sec[1],    c4.sec[0],  c5.sec[0]
  //1 pl monday, 2 prob wednesday, 3 md tuesday, 4 ada monday, 5 eth wednesday
  //c1.sec[1],    c2.sec[0],        c3.sec[0],      c4.sec[0],    c5.sec[0]
  //1 pl tuesday, 2 prob wednesday, 3 md wednesday, 4 ada monday, 5 eth wednesday
  //c1.sec[1],    c2.sec[0],        c3.sec[1],    c4.sec[0],    c5.sec[0]
  //1 pl tuesday, 2 prob wednesday, 3 md tuesday, 4 ada monday, 5 eth wednesday


}

class Combinations {
  List<Course> coursesFromInput;

  Combinations({required this.coursesFromInput});

  //'re-initialize' this
  List<List<Course>> schedules = [];
  List<List<Course>> schedulesOneSection = [];
  List<List<Course>> schedulesOneSectionOneTut = [];
  List<List<Course>> schedulesOneSectionOneTutOneLab = [];

  //given a list of courses, create all combinations of k (e.g. 5) courses, (n Choose k) n = coursesFromInput.length k = numOfCoursesInSchedule
  void getAllCourseCombinations(List<Course> courses, int numOfCoursesInSchedule, List<Course> currentCombination) {
    if (numOfCoursesInSchedule == 0) {
      schedules!.add(List.from(currentCombination));
      return;
    }

    for (int i = 0; i <= courses.length - numOfCoursesInSchedule; i++) {
      currentCombination.add(courses[i]);
      getAllCourseCombinations(courses.sublist(i + 1), numOfCoursesInSchedule - 1, currentCombination);
      currentCombination.removeLast();
    }
  }

  //want to create new schedule with 11111, then 21111, then 12111, then 22111, then 11211, and so on
  // 1 represents sec 1, 2 represents sec 2. place of digit represents
  //given a list of courses that have been 'reduced' to length k (e.g. 5), k = numOfCoursesInSchedule from above
  //  create all the combinations of k courses with the different sections
  //  e.g. pass List<Course> = [c1, c2, c3, c4, c5]. for each section, create new List<Course> (1st iteration) = [c1.sec1, c2.sec1, c3.sec1, c4.sec1, c5.sec1]
  //                                                   (2nd iteration) = [c1.sec2, c2.sec1, c3.sec1, c4.sec1, c5.sec1]
  void getAllOneSectionCombinations(List<Course> schedule) {

    List<int> sectionNumbers = [];
    sectionNumbers = List.filled(schedule.length, 0);

    List<Course> currentSchedule = [];

    void generateSectionCombinations(List<Course> currentSchedule, int currentIndex) {
      if (currentIndex == schedule.length) {
        int currentCourse = 0;
        for (Course course in schedule) {
          currentSchedule.add(Course(course.courseName, [course.sections[sectionNumbers[currentCourse]]], course.tutorials, course.labs, course.color));
          currentCourse++;
        }
        schedulesOneSection.add(currentSchedule);
        return;
      }

      for (int sectionNumber = 0; sectionNumber < schedule[currentIndex].sections.length; sectionNumber++) {
        currentSchedule = [];
        sectionNumbers[currentIndex] = sectionNumber;
        generateSectionCombinations(currentSchedule, currentIndex + 1);
      }
    }

    generateSectionCombinations(currentSchedule, 0);
  }

  void getAllOneSectionOneTutorialCombinations(List<Course> schedule) {

  }

  void getAllOneSectionOneTutorialOneLabCombinations(List<Course> schedule) {

  }


  //check for conflict between lectures - need to modify current conflict check a little. i.e classtimes -> sections.lecturetimes
  //get new schedules with no lecture conflicts

}