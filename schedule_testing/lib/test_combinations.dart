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

  int? numOfCoursesInSchedule = 5; //this will be taken from user input like; however, doing hard coded 5


  Combinations comb = Combinations(coursesFromInput: coursesFromInput);

  comb.getAllCourseCombinations(coursesFromInput, numOfCoursesInSchedule, []);
  for (List<Course> schedule in comb.schedules!) {
    for (Course course in schedule) {
      print(course.courseName);
    }
    print('----schedule---');
  }



}

class Combinations {
  List<Course> coursesFromInput;

  Combinations({required this.coursesFromInput});

  //'re-initialize' this
  List<List<Course>>? schedules = [];
  List<List<Course>>? schedulesOneSection = [];
  List<List<Course>>? schedulesOneSectionOneTut = [];
  List<List<Course>>? schedulesOneSectionOneTutOneLab = [];

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

  List<List<int>> generateCombinations(List<int> maxSizes) {
    List<List<int>> combinations = [];

    void generate(List<int> currentCombination, int currentIndex) {
      if (currentIndex == maxSizes.length) {
        combinations.add(List.from(currentCombination));
        return;
      }

      for (int i = 0; i <= maxSizes[currentIndex]; i++) {
        currentCombination[currentIndex] = i;
        generate(currentCombination, currentIndex + 1);
      }
    }

    generate(List.filled(maxSizes.length, 0), 0);
    return combinations;
  }

  void getAllSectionCombinations(List<Course> courses) {
    //given a list of courses that have been 'reduced' to length k (e.g. 5), k = numOfCoursesInSchedule from above
    //  create all the combinations of k courses with the different sections
    //  e.g. pass List<Course> = [c1, c2, c3, c4, c5]. for each section, create new List<Course> (1st iteration) = [c1.sec1, c2.sec1, c3.sec1, c4.sec1, c5.sec1]
    //                                                   (2nd iteration) = [c1.sec2, c2.sec1, c3.sec1, c4.sec1, c5.sec1]

    List<int> sectionNumbers = [];
    List<Course> coursesButOnlyOneSection = [];

    for (Course course in courses) {
      sectionNumbers.add(0);
    }

    int upperPosition = 0;
    int lowerPosition = 0;
    coursesButOnlyOneSection = [];
    int sectionCount = 0;


      //start at course 0, go through every course and add the first section
      //for Course course in courses, add Course(course.courseName, course.sections[sectionNumbers[currentPosition], course.tutorials, course.labs, course.color)

      //increment course 0's sectionNumber

    //reset courseButOnlyOneSection
    //add each course but with only one section:
    //  for int i = 0; i < courses.length:
    //    courseButOnlyOneSection.add(Course(courses[i].courseName, courses[i].sections[sectionNumbers[i], courses[i].tutorials, courses[i].labs, courses[i].color))
    //    schedulesOneSection.add(coursesButOnlyOneSection)
    //check if there are more sections for the currentPosition course; sectionNumber[currentPosition] < courses[currentPosition].sections.length, if yes:
    //  increment sectionNumber[currentPosition]
    //if no, no more sections for current course, move current to next course:
    //  increment currentPosition
    //  check if we reached 'most significant' digit, want to increment it and go back to loop to it again. currentPosition >= upperPosition, if yes:
    //    MUST CHECK IF ALL PREVIOUS POSITIONS HAVE MAX SECTION NUMBERS, IF NO, KEEP UPPER POSITION AND ITS SECTION NUMBER SAME, GO BACK AND INCREMENT FROM LEAST
    //      IF YES THEN CAN PROCEED WITH INCREMENTING UPPER POSITION AND RESETTING PREVIOUS SECTION NUMBERS (l167)
    //    reset currentPosition to start; currentPosition = 0
    //    check if there are more sections for the upperPosition course; sectionNumber[upperPosition] < courses[upperPosition].sections.length, if yes:
    //      increment sectionNumber[upperPosition]
    //      reset sectionNumbers before upperPosition, sectionNumbers[< upperPosition] = 0
    //    if no, go to next course and make combinations with all its sections:
    //      reset sectionNumbers
    //      increment upperPosition
    //      increment sectionNumbers[upperPosition]

    // for (int upperPosition = 0; upperPosition < courses.length; upperPosition++) {  //0, 1, 2, 3, 4
      // for (int currentPosition = 0; currentPosition < courses.length; currentPosition++) {  //0, 1, 2, 3, 4
      //   coursesButOnlyOneSection.add(Course(
      //       courses[currentPosition].courseName,
      //       [courses[currentPosition].sections[sectionNumbers[currentPosition]]],
      //       courses[currentPosition].tutorials,
      //       courses[currentPosition].labs,
      //       courses[currentPosition].color));
      // }
      //for Course course in courses, add Course(course.courseName, course.sections[sectionNumbers[currentPosition], course.tutorials, course.labs, course.color)
    // }
    //make an one section schedule
    // for (Course course in courses) {
    //   coursesButOnlyOneSection.add(Course(course.courseName, course.sections, course.tutorials, course.labs, course.color));
    // }

  }

  //for schedule in schedules
  //  for courses in schedule
  //
  //for each course in courses? ... List<Course> new_courses.add(Course(courses[i].courseName, courses[i].sections[ints[i]], courses[i].tutorials, courses[i].labs))
  //schedulesbutwithonlyonesection.add(Schedule(new_courses))
  //check for conflict between lectures - need to modify current conflict check a little. i.e classtimes -> sections.lecturetimes
  //get new schedules with no lecture conflicts

  //for each schedule in schedules
  //  for courses in schedule
  //    for course in courses
  //      List
}