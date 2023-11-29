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

  List<Section> pl_secs = [pl_sec1,
    // pl_sec2
  ];
  List<Section> prob_secs = [prob_sec1];
  List<Section> md_secs = [md_sec1,
    // md_sec2
  ];
  List<Section> ada_secs = [ada_sec1];
  List<Section> eth_secs = [eth_sec1];
  List<Section> d_secs = [d_sec1];

  Tutorial ada_tut1 = Tutorial([thu9_11]);
  Tutorial ada_tut2 = Tutorial([fri2_3]);

  List<Tutorial> ada_tuts = [ada_tut1, ada_tut2];
  List<Tutorial> tutorials = [];  //empty tutorial list, represents courses with no tutorials

  Laboratory md_lab1 = Laboratory([mon2_3]);
  Laboratory md_lab2 = Laboratory([wed2_3]);

  List<Laboratory> md_labs = [md_lab1, md_lab2];
  List<Laboratory> labs = []; //empty lab list, represents courses with no labs

  Course pl = Course('1 pl', pl_secs, tutorials, labs, Colors.red);
  Course prob = Course('2 prob', prob_secs, tutorials, labs, Colors.green);
  Course md = Course('3 md', md_secs, tutorials, md_labs, Colors.brown);
  Course ada = Course('4 ada', ada_secs, ada_tuts, labs, Colors.blue);
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

  int? numOfCoursesInSchedule = 5; //this will be taken from user input; however, doing hard coded 5


  Combinations comb = Combinations(coursesFromInput: coursesFromInput);

  comb.getAllCourseCombinations(coursesFromInput, numOfCoursesInSchedule, []);
  // for (List<Course> schedule in comb.schedules!) {
  //   for (Course course in schedule) {
  //     print(course.courseName);
  //   }
  //   print('----schedule---');
  // }
  //expected output from above (with comb.schedules = [pl, prob, md, ada, eth, d]:
  //'1 pl'   '2 prob' '3 md'  '4 ada' '5 eth'
  //'1 pl'   '2 prob' '3 md'  '4 eth' '6 d'
  //'1 pl'   '2 prob' '3 ada' '5 eth' '6 d'
  //'1 pl'   '2 prob' '4 ada' '5 eth' '6 d'
  //'1 pl'   '3 md'   '4 ada' '5 eth' '6 d'
  //'2 prob' '3 md'   '4 ada' '5 eth' '6 d'

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
  //c1.sec[0],    c2.sec[0],        c3.sec[0],      c4.sec[0],    c5.sec[0]
  //1 pl monday,  2 prob wednesday, 3 md wednesday, 4 ada monday, 5 eth wednesday
  //c1.sec[0],    c2.sec[0],        c3.sec[1],      c4.sec[0],    c5.sec[0]
  //1 pl monday,  2 prob wednesday, 3 md tuesday,   4 ada monday, 5 eth wednesday
  //c1.sec[1],    c2.sec[0],        c3.sec[0],      c4.sec[0],    c5.sec[0]
  //1 pl tuesday, 2 prob wednesday, 3 md wednesday, 4 ada monday, 5 eth wednesday
  //c1.sec[1],    c2.sec[0],        c3.sec[1],      c4.sec[0],    c5.sec[0]
  //1 pl tuesday, 2 prob wednesday, 3 md tuesday,   4 ada monday, 5 eth wednesday

  for (List<Course> schedule in comb.schedulesOneSection) {
    comb.getAllOneSectionOneTutorialCombinations(schedule);
  }
  // for (List<Course> schedule in comb.schedulesOneSectionOneTut) {
  //   for (Course course in schedule) {
  //     if (course.tutorials.isNotEmpty) {
  //       print('${course.courseName}, lec: ${course.sections[0].lectureTimes?[0].dayOfWeek}, tut: ${course.tutorials[0].tutorialTimes?[0].dayOfWeek}');
  //     } else {
  //       print('${course.courseName}, lec: ${course.sections[0].lectureTimes?[0].dayOfWeek}, no tut');
  //     }
  //   }
  //   print('----schedule---');
  // }
  //expected output from above,
  // with comb.schedulesOneSection = [pl.sec[0], prob.sec[0], md.sec[0], ada.sec[0], eth.sec[0]]: *note only ada has tutorial in this example
  //    c1.sec[0]+<NA>,            c2.sec[0]+<NA>,                 c3.sec[0]+<NA>,               c4.sec[0]+tut[0],                  c5.sec[0]+<NA>
  //    1 pl, lec: monday, no tut, 2 prob, lec: wednesday, no tut, 3 md, lec: wednesday, no tut, 4 ada, lec: monday, tut: thursday, 5 eth, lec: wednesday, no tut
  //    c1.sec[0]+<NA>,            c2.sec[0]+<NA>,                 c3.sec[0]+<NA>,               c4.sec[0]+tut[1],                  c5.sec[0]+<NA>
  //    1 pl, lec: monday, no tut, 2 prob, lec: wednesday, no tut, 3 md, lec: wednesday, no tut, 4 ada, lec: monday, tut: friday, 5 eth, lec: wednesday, no tut

  for (List<Course> schedule in comb.schedulesOneSectionOneTut) {
    comb.getAllOneSectionOneTutorialOneLabCombinations(schedule);
  }
  for (List<Course> schedule in comb.schedulesOneSectionOneTutOneLab) {
    for (Course course in schedule) {
      if (course.tutorials.isNotEmpty) {
        print('${course.courseName}, lec: ${course.sections[0].lectureTimes?[0].dayOfWeek}, tut: ${course.tutorials[0].tutorialTimes?[0].dayOfWeek}');
      } else if (course.labs.isNotEmpty) {
        print('${course.courseName}, lec: ${course.sections[0].lectureTimes?[0].dayOfWeek}, lab: ${course.labs[0].labTimes?[0].dayOfWeek}');
      } else {
        print('${course.courseName}, no lab');
      }
    }
    print('----schedule---');
  }
  //expected output from above,
  // with comb.schedulesOneSection = [pl.sec[0]+<NA>, prob.sec[0]+<NA>, md.sec[0]+<NA>, ada.sec[0]+tut[0], eth.sec[0]+<NA>]: *note only md has labs in this example
  //    c1.sec[0]+<NA>+<NA>,       c2.sec[0]+<NA>+<NA>,            c3.sec[0]+<NA>+lab[0],             c4.sec[0]+tut[0]+<NA>,      c5.sec[0]+<NA>+<NA>
  //    1 pl, lec: monday, no lab, 2 prob, lec: wednesday, no lab, 3 md, lec: wednesday, lab: monday, 4 ada, lec: monday, no lab, 5 eth, lec: wednesday, no lab
  //    c1.sec[0]+<NA>+<NA>,       c2.sec[0]+<NA>+<NA>,            c3.sec[0]+<NA>+lab[0],                c4.sec[0]+tut[1]+<NA>,      c5.sec[0]+<NA>+<NA>
  //    1 pl, lec: monday, no lab, 2 prob, lec: wednesday, no lab, 3 md, lec: wednesday, lab: wednesday, 4 ada, lec: monday, no lab, 5 eth, lec: wednesday, no lab
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
  //todo: call this after user clicks 'next' button, then show them a list of all the schedules (gesturedectector?) that they can click on to view the displayed schedules...
  // todo:  e.g. choose: [c1, c2, c3, c4, c5], [c1, c2, c3, c4, c6], ..., [c2, c3, c4, c5, c6], then first one gets chosen -> (getAllOneSectionCombination) show all (non-conflicting) section schedules
  // todo:  which can also be clicked on to show all possible tut/lab for that section schedule ? or just show all section_tut_lab schedules for those courses
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

  //takes a list of courses that have been 'reduced' to length k (e.g. 5), k = numOfCoursesInSchedule from above
  //  create all the combinations of k courses with the different sections
  //  e.g. pass List<Course> = [c1, c2, c3, c4, c5]. for each section, create new List<Course> (1st iteration) = [c1.sec1, c2.sec1, c3.sec1, c4.sec1, c5.sec1]
  //                                                                                           (2nd iteration) = [c1.sec2, c2.sec1, c3.sec1, c4.sec1, c5.sec1]
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

  //takes a list of courses with each course now having only one lecture(s) section, create all the combinations of the courses with different tutorial times
  //  e.g. pass List<Course> = [c1.sec1, c2.sec1, c3.sec1, c4.sec1, c5.sec1] (and only c1 and c3 have tutorials),
  //  for each tutorial, create new List<Course> (1st iteration) = [c1.sec1+tut1, c2.sec1+<NA>, c3.sec1+tut1, c4.sec1+<NA>, c5.sec1+<NA>]
  //                                             (2nd iteration) = [c1.sec1+tut2, c2.sec1+<NA>, c3.sec1+tut1, c4.sec1+<NA>, c5.sec1+<NA>]
  void getAllOneSectionOneTutorialCombinations(List<Course> schedule) {
    List<int> tutorialNumbers = [];
    tutorialNumbers = List.filled(schedule.length, 0);
    List<Course> currentSchedule = [];

    void generateTutorialCombinations(List<Course> currentSchedule, int currentIndex) {
      if (currentIndex == schedule.length) {
        int currentCourse = 0;
        for (Course course in schedule) {
          currentSchedule.add(Course(course.courseName, course.sections,
              tutorialNumbers[currentCourse] == 0 ? course.tutorials : [course.tutorials[tutorialNumbers[currentCourse] - 1]], course.labs, course.color));
          currentCourse++;
        }
        schedulesOneSectionOneTut.add(currentSchedule);
        return;
      }

      for (int tutorialNumber = ((schedule[currentIndex].tutorials.isNotEmpty) ? 1 : 0); tutorialNumber < schedule[currentIndex].tutorials.length + 1; tutorialNumber++) {
        currentSchedule = [];
        tutorialNumbers[currentIndex] = tutorialNumber;
        generateTutorialCombinations(currentSchedule, currentIndex + 1);
      }
    }

    generateTutorialCombinations(currentSchedule, 0);
  }

  //takes a list of courses with each course now having only one lecture(s) section and only one tutorial, create all the combinations of the courses with different lab times
  //  e.g. pass List<Course> = [c1.sec1+tut1, c2.sec1+<NA>, c3.sec1+tut1, c4.sec1+<NA>, c5.sec1+<NA>] (and only c2 and c3 have labs),
  //    for each lab, create new List<Course> (1st iteration) = [c1.sec1+tut1+<NA>, c2.sec1+<NA>+lab1, c3.sec1+tut1+lab1, c4.sec1+<NA>+<NA>, c5.sec1+<NA>+<NA>]
  //                                          (2nd iteration) = [c1.sec1+tut1+<NA>, c2.sec1+<NA>+lab2, c3.sec1+tut1+lab1, c4.sec1+<NA>+<NA>, c5.sec1+<NA>+<NA>]
  void getAllOneSectionOneTutorialOneLabCombinations(List<Course> schedule) {
    List<int> labNumbers = [];
    labNumbers = List.filled(schedule.length, 0);
    List<Course> currentSchedule = [];

    void generateLabCombinations(List<Course> currentSchedule, int currentIndex) {
      if (currentIndex == schedule.length) {
        int currentCourse = 0;
        for (Course course in schedule) {
          currentSchedule.add(Course(course.courseName, course.sections, course.tutorials,
              labNumbers[currentCourse] == 0 ? course.labs : [course.labs[labNumbers[currentCourse] - 1]], course.color));
          currentCourse++;
        }
        schedulesOneSectionOneTutOneLab.add(currentSchedule);
        return;
      }

      for (int labNumber = ((schedule[currentIndex].labs.isNotEmpty) ? 1 : 0); labNumber < schedule[currentIndex].labs.length + 1; labNumber++) {
        currentSchedule = [];
        labNumbers[currentIndex] = labNumber;
        generateLabCombinations(currentSchedule, currentIndex + 1);
      }
    }

    generateLabCombinations(currentSchedule, 0);
  }


  //check for conflict between lectures - need to modify current conflict check a little. i.e classtimes -> sections.lecturetimes
  //get new schedules with no lecture conflicts

}