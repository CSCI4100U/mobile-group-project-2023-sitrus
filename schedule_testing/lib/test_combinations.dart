import 'package:flutter/material.dart';

import 'schedule_model.dart';
import 'course_model.dart';
// import 'rectangle_model.dart';

//treat this as the build method?
void main() {

  HourMinute eight_ten = HourMinute(hour: 8, minute: 10);
  HourMinute nine_fourty = HourMinute(hour: 9, minute: 40);
  HourMinute eleven_ten = HourMinute(hour: 11, minute: 10);
  HourMinute twelve_forty = HourMinute(hour: 12, minute: 40);
  HourMinute two_ten = HourMinute(hour: 2 +12, minute: 10);
  HourMinute three_fourty = HourMinute(hour: 3 +12, minute: 40);

  HourMinute nine_thirty = HourMinute(hour: 9, minute: 30);
  HourMinute eleven_0 = HourMinute(hour: 11, minute: 00);
  HourMinute twelve_thirty = HourMinute(hour: 12, minute: 30);
  HourMinute two_0 = HourMinute(hour: 2 +12, minute: 00);
  HourMinute three_thirty = HourMinute(hour: 3 +12, minute: 30);
  HourMinute five_0 = HourMinute(hour: 5 +12, minute: 00);

  ClassTime mon8_9 = ClassTime(startTime: eight_ten, endTime: nine_thirty, dayOfWeek: 'Monday');
  ClassTime mon9_11 = ClassTime(startTime: nine_fourty, endTime: eleven_0, dayOfWeek: 'Monday');
  ClassTime mon11_12 = ClassTime(startTime: eleven_ten, endTime: twelve_thirty, dayOfWeek: 'Monday');
  ClassTime mon2_3 = ClassTime(startTime: two_ten, endTime: three_thirty, dayOfWeek: 'Monday');
  ClassTime tue8_9 = ClassTime(startTime: eight_ten, endTime: nine_thirty, dayOfWeek: 'Tuesday');
  ClassTime tue9_11 = ClassTime(startTime: nine_fourty, endTime: eleven_0, dayOfWeek: 'Tuesday');
  ClassTime tue11_12 = ClassTime(startTime: eleven_ten, endTime: twelve_thirty, dayOfWeek: 'Tuesday');
  ClassTime tue2_3 = ClassTime(startTime: two_ten, endTime: three_thirty, dayOfWeek: 'Tuesday');
  ClassTime wed8_9 = ClassTime(startTime: eight_ten, endTime: nine_thirty, dayOfWeek: 'Wednesday');
  ClassTime wed9_11 = ClassTime(startTime: nine_fourty, endTime: eleven_0, dayOfWeek: 'Wednesday');
  ClassTime wed11_12 = ClassTime(startTime: eleven_ten, endTime: twelve_thirty, dayOfWeek: 'Wednesday');
  ClassTime wed2_3 = ClassTime(startTime: two_ten, endTime: three_thirty, dayOfWeek: 'Wednesday');
  ClassTime thu8_9 = ClassTime(startTime: eight_ten, endTime: nine_thirty, dayOfWeek: 'Thursday');
  ClassTime thu9_11 = ClassTime(startTime: nine_fourty, endTime: eleven_0, dayOfWeek: 'Thursday');
  ClassTime thu11_12 = ClassTime(startTime: eleven_ten, endTime: twelve_thirty, dayOfWeek: 'Thursday');
  ClassTime thu2_3 = ClassTime(startTime: two_ten, endTime: three_thirty, dayOfWeek: 'Thursday');
  ClassTime fri8_9 = ClassTime(startTime: eight_ten,endTime:  nine_thirty, dayOfWeek: 'Friday');
  ClassTime fri9_11 = ClassTime(startTime: nine_fourty, endTime: eleven_0, dayOfWeek: 'Friday');
  ClassTime fri11_12 = ClassTime(startTime: eleven_ten, endTime: twelve_thirty, dayOfWeek: 'Friday');
  ClassTime fri2_3 = ClassTime(startTime: two_ten, endTime: three_thirty, dayOfWeek: 'Friday');

  Section pl_sec1 = Section(lectureTimes: [mon8_9]);
  Section pl_sec2 = Section(lectureTimes: [tue8_9]);
  Section prob_sec1 = Section(lectureTimes: [wed8_9, fri8_9]);
  Section md_sec1 = Section(lectureTimes: [wed9_11, fri9_11]);
  // Section md_sec2 = Section(lectureTimes: [wed2_3, fri2_3]);
  Section md_sec2 = Section(lectureTimes: [tue2_3, thu2_3]);
  Section md_sec3 = Section(lectureTimes: [mon11_12, thu11_12]);
  Section ada_sec1 = Section(lectureTimes: [mon11_12, thu11_12]);
  // Section ada_sec2 = Section(lectureTimes: [mon2_3, thu2_3]);
  Section ada_sec2 = Section(lectureTimes: [tue2_3, thu2_3]);
  Section eth_sec1 = Section(lectureTimes: [wed11_12]);
  Section d_sec1 = Section(lectureTimes: [mon9_11, tue9_11]);

  List<Section> pl_secs = [pl_sec1,
    // pl_sec2
  ];
  List<Section> prob_secs = [prob_sec1];
  List<Section> md_secs = [md_sec1,
    md_sec2,
    md_sec3
  ];
  List<Section> ada_secs = [ada_sec1];
  List<Section> eth_secs = [eth_sec1];
  List<Section> d_secs = [d_sec1];

  Tutorial ada_tut1 = Tutorial(tutorialTime: thu9_11);
  Tutorial ada_tut2 = Tutorial(tutorialTime: fri2_3);

  List<Tutorial> ada_tuts = [ada_tut1, ada_tut2];
  List<Tutorial> tutorials = [];  //empty tutorial list, represents courses with no tutorials

  Laboratory md_lab1 = Laboratory(labTime: mon2_3);
  Laboratory md_lab2 = Laboratory(labTime: fri2_3);

  List<Laboratory> md_labs = [md_lab1, md_lab2];
  List<Laboratory> labs = []; //empty lab list, represents courses with no labs

  Course pl = Course(courseName: '1 pl', sections: pl_secs, tutorials: tutorials, labs: labs, color: Colors.red);
  Course prob = Course(courseName: '2 prob', sections: prob_secs, tutorials: tutorials, labs: labs, color: Colors.green);
  Course md = Course(courseName: '3 md', sections: md_secs, tutorials: tutorials, labs: md_labs, color: Colors.brown);
  Course ada = Course(courseName: '4 ada', sections: ada_secs, tutorials: ada_tuts, labs: labs, color: Colors.blue);
  Course eth = Course(courseName:  '5 eth', sections: eth_secs, tutorials: tutorials, labs: labs, color: Colors.purple);
  Course d = Course(courseName: '6 d', sections: d_secs, tutorials: tutorials, labs: labs, color: Colors.orange);

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
    //validate schedule sections
    comb.schedulesOneSection = Schedule.validateSchedulesSections(comb.schedulesOneSection);
    // print(comb.schedulesOneSection.length);
  }
  for (List<Course> schedule in comb.schedulesOneSection) {
    for (Course course in schedule) {
      print('${course.courseName}, ${course.sections[0].lectureTimes[0].dayOfWeek} ${course.sections[0].lectureTimes[0].startTime.convertToInt()}');
    }
    print('----schedule---');
  }
  //expected output from above (with comb.schedules = [pl, prob, md, ada, eth]:
  //c1.sec[0],        c2.sec[0],            c3.sec[0],          c4.sec[0],         c5.sec[0]
  //1 pl monday 810,  2 prob wednesday 810, 3 md wednesday 940, 4 ada monday 1110, 5 eth wednesday 1110
  //c1.sec[0],        c2.sec[0],            c3.sec[1],          c4.sec[0],         c5.sec[0]
  //1 pl monday 810,  2 prob wednesday 810, 3 md tuesday 210,   4 ada monday 1110, 5 eth wednesday 1110
  //c1.sec[1],        c2.sec[0],            c3.sec[0],          c4.sec[0],         c5.sec[0]
  //1 pl tuesday 810, 2 prob wednesday 810, 3 md wednesday 940, 4 ada monday 1110, 5 eth wednesday 1110
  //c1.sec[1],        c2.sec[0],            c3.sec[1],          c4.sec[0],         c5.sec[0]
  //1 pl tuesday 810, 2 prob wednesday 810, 3 md tuesday 210,   4 ada monday 1110, 5 eth wednesday 1110

  for (List<Course> schedule in comb.schedulesOneSection) {
    comb.getAllOneSectionOneTutorialCombinations(schedule);
  }
  // print(comb.schedulesOneSectionOneTut.length);
  // validate schedule tuts
  comb.schedulesOneSectionOneTut = Schedule.validateSchedulesTuts(comb.schedulesOneSectionOneTut);
  // for (List<Course> schedule in comb.schedulesOneSectionOneTut) {
  //   for (Course course in schedule) {
  //     if (course.tutorials.isNotEmpty) {
  //       print('${course.courseName}, lec: ${course.sections[0].lectureTimes?[0].dayOfWeek} ${course.sections[0].lectureTimes[0].startTime.convertToInt()}, '
  //           'tut: ${course.tutorials[0].tutorialTime.dayOfWeek} ${course.tutorials[0].tutorialTime.startTime.convertToInt()}');
  //     } else {
  //       print('${course.courseName}, lec: ${course.sections[0].lectureTimes?[0].dayOfWeek} ${course.sections[0].lectureTimes[0].startTime.convertToInt()}, '
  //           'no tut');
  //     }
  //   }
  //   print('----schedule---');
  // }
  //expected output from above,
  // with comb.schedulesOneSection = [pl.sec[0], prob.sec[0], md.sec[0], ada.sec[0], eth.sec[0]]: *note only ada has tutorial in this example
  //    c1.sec[0]+<NA>,                c2.sec[0]+<NA>,                     c3.sec[0]+<NA>,                   c4.sec[0]+tut[0],                           c5.sec[0]+<NA>
  //    1 pl, lec: monday 810, no tut, 2 prob, lec: wednesday 810, no tut, 3 md, lec: wednesday 940, no tut, 4 ada, lec: monday 1110  tut: thursday 940, 5 eth, lec: wednesday 1110, no tut
  //    c1.sec[0]+<NA>,                c2.sec[0]+<NA>,                     c3.sec[0]+<NA>,                   c4.sec[0]+tut[1],                          c5.sec[0]+<NA>
  //    1 pl, lec: monday 810, no tut, 2 prob, lec: wednesday 810, no tut, 3 md, lec: wednesday 940, no tut, 4 ada, lec: monday 1110, tut: friday 210, 5 eth, lec: wednesday 1110, no tut

  for (List<Course> schedule in comb.schedulesOneSectionOneTut) {
    comb.getAllOneSectionOneTutorialOneLabCombinations(schedule);
  }
  //validate scheulde labs
  // print(comb.schedulesOneSectionOneTutOneLab.length);
  comb.schedulesOneSectionOneTutOneLab = Schedule.validateSchedulesLabs(comb.schedulesOneSectionOneTutOneLab);
  // print(comb.schedulesOneSectionOneTutOneLab.length);
  // for (List<Course> schedule in comb.schedulesOneSectionOneTutOneLab) {
  //   for (Course course in schedule) {
  //     if (course.tutorials.isNotEmpty) {
  //       if (course.labs.isNotEmpty) {
  //         print('${course.courseName}, lec: ${course.sections[0].lectureTimes?[0].dayOfWeek} ${course.sections[0].lectureTimes[0].startTime.convertToInt()}, '
  //             'tut: ${course.tutorials[0].tutorialTime.dayOfWeek} ${course.tutorials[0].tutorialTime.startTime.convertToInt()}, '
  //             'lab: ${course.labs[0].labTime.dayOfWeek} ${course.labs[0].labTime.startTime.convertToInt()}');
  //       } else {
  //         print('${course.courseName}, lec: ${course.sections[0].lectureTimes?[0].dayOfWeek} ${course.sections[0].lectureTimes[0].startTime.convertToInt()}, '
  //             'tut: ${course.tutorials[0].tutorialTime.dayOfWeek} ${course.tutorials[0].tutorialTime.startTime.convertToInt()}, '
  //             'no lab');
  //       }
  //     } else if (course.labs.isNotEmpty) {
  //       print('${course.courseName}, lec: ${course.sections[0].lectureTimes[0].dayOfWeek} ${course.sections[0].lectureTimes[0].startTime.convertToInt()}, '
  //           'lab: ${course.labs[0].labTime.dayOfWeek} ${course.labs[0].labTime.startTime.convertToInt()}');
  //     } else {
  //       print('${course.courseName}, lec: ${course.sections[0].lectureTimes[0].dayOfWeek} ${course.sections[0].lectureTimes[0].startTime.convertToInt()}, '
  //           'no tut, '
  //           'no lab');
  //     }
  //   }
  //   print('----schedule---');
  // }
  //expected output from above,
  // with comb.schedulesOneSection = [pl.sec[0]+<NA>, prob.sec[0]+<NA>, md.sec[0]+<NA>, ada.sec[0]+tut[0], eth.sec[0]+<NA>]: *note only md has labs in this example
  //    c1.sec[0]+<NA>+<NA>,                   c2.sec[0]+<NA>+<NA>,                        c3.sec[0]+<NA>+lab[0],                             c4.sec[0]+tut[0]+<NA>,                              c5.sec[0]+<NA>+<NA>
  //    1 pl, lec: monday 810, no tut, no lab, 2 prob, lec: wednesday 810, no tut, no lab, 3 md, lec: wednesday 940, no tut, lab: monday 210, 4 ada, lec: monday 1110, tut: thursday 940, no lab, 5 eth, lec: wednesday 1110, no tut, no lab
  //    c1.sec[0]+<NA>+<NA>,                   c2.sec[0]+<NA>+<NA>,                        c3.sec[0]+<NA>+lab[1],                                c4.sec[0]+tut[1]+<NA>,                              c5.sec[0]+<NA>+<NA>
  //    1 pl, lec: monday 810, no tut, no lab, 2 prob, lec: wednesday 810, no tut, no lab, 3 md, lec: wednesday 940, no tut, lab: wednesday 210, 4 ada, lec: monday 1110, tut: thursday 940, no lab, 5 eth, lec: wednesday 1110, no tut, no lab
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
          currentSchedule.add(Course(
              courseName: course.courseName,
              sections: [course.sections[sectionNumbers[currentCourse]]],
              tutorials: course.tutorials,
              labs: course.labs,
              color: course.color));
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
          currentSchedule.add(Course(
              courseName: course.courseName,
              sections: course.sections,
              tutorials: tutorialNumbers[currentCourse] == 0 ? course.tutorials : [course.tutorials[tutorialNumbers[currentCourse] - 1]],
              labs: course.labs,
              color: course.color));
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
          currentSchedule.add(Course(
              courseName: course.courseName,
              sections: course.sections,
              tutorials: course.tutorials,
              labs: labNumbers[currentCourse] == 0 ? course.labs : [course.labs[labNumbers[currentCourse] - 1]],
              color: course.color));
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

  //get new schedules with no lecture conflicts

}