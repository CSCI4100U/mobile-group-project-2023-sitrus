import 'course_model.dart';

class ScheduleCombinations {
  List<Course> coursesFromInput;
  //num of courses

  ScheduleCombinations({required this.coursesFromInput});

  //'re-initialize' this
  List<List<Course>> schedules = [];
  List<List<Course>> schedulesOneSection = [];
  List<List<Course>> schedulesOneSectionOneTut = [];
  List<List<Course>> schedulesOneSectionOneTutOneLab = [];


  //todo: call this after user clicks 'next' button, then show them a list of all the schedules (gesturedectector?) that they can click on to view the displayed schedules...
  // todo:  e.g. choose: [c1, c2, c3, c4, c5], [c1, c2, c3, c4, c6], ..., [c2, c3, c4, c5, c6], then first one gets chosen -> (getAllOneSectionCombination) show all (non-conflicting) section schedules
  // todo:  which can also be clicked on to show all possible tut/lab for that section schedule ? or just show all section_tut_lab schedules for those courses

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