import 'course_model.dart';

//for demo, it is fixed to 5 courses in a schedule object (i.e. courses list is length 5)

class Schedule {
  List<Course>? courses;

  Schedule(this.courses);

  //to check for conflict between every course in the schedule
  //must check for conflict between each section's lecture times of a course; check section's lectures against all courses' section's lectures
  //this will create a list of schedules that have non conflicting sections/lectures

  static List<List<Course>> validateSchedulesSections(List<List<Course>> schedules) {
    List<List<Course>> validatedSchedules = [];

    for (List<Course> schedule in schedules) {
      // print('check lecture conflict');
      for (Course course in schedule) {
      }
      if (!lectureConflictExists(schedule)) {
        validatedSchedules.add(schedule);
      }
    }
    return validatedSchedules;
  }

  //then check for conflict between each course's tutorial times
  //this will create a list of schedules that have non conflicting sections/lectures and tutorials (i.e. only schedules with valid lecture and tutorial times
  static List<List<Course>> validateSchedulesTuts(List<List<Course>> schedules) {
    List<List<Course>> validatedSchedules = [];

    for (List<Course> schedule in schedules) {
      // print('check tut conflict');
      if (!tutorialConflictExists(schedule)) {
        validatedSchedules.add(schedule);
      }
    }
    return validatedSchedules;
  }

  //finally check for conflict between each course's lab times
  //this will create the final list of schedules that have no conflict between any of it's classes (lectures, tuts, labs); a valid schedule
  static List<List<Course>> validateSchedulesLabs(List<List<Course>> schedules) {
    List<List<Course>> validatedSchedules = [];

    for (List<Course> schedule in schedules) {
      // print('check lab conflict');
      if (!labConflictExists(schedule)) {
        validatedSchedules.add(schedule);
      }
    }
    return validatedSchedules;
  }

  static bool timeConflictExists (ClassTime class1, ClassTime class2) {
    //check for conflict between the two class's times by seeing if they intersect each other

    //if the classes are on different days, they don't intersect
    if (class1.dayOfWeek != class2.dayOfWeek) {
      // print('days arent same, no conflict');
      return false;
    }
    // print('days r same');

    //if classes are on same day, check for conflict
    //class times intersect if either course's start/end time is in between the other course's time
    //if statement 1 (splitting because the comparisons are too long...:
    // i.e. (class1.starTime < class2.startTime < class1.endTime) or
    //      (class2.startTime < class1.endTime < class2.endTime)
    //visual representation:
    // class1: start|------------|end
    // class2        start|------------|end
    if ((class1.startTime.convertToInt() <= class2.startTime.convertToInt()
          &&
          class2.startTime.convertToInt() <= class1.endTime.convertToInt())
        ||
        (class2.startTime.convertToInt() <= class1.endTime.convertToInt()
          &&
          class1.endTime.convertToInt() <= class2.endTime.convertToInt())) {
      return true;
    }
    //if statement 2:
    // i.e (class1.startTime < class2.endTime < class1.endTime) or
    //      (class2.startTime < class1.startTime < class2.endTime)
    //visual representation
    // class1:        start|------------|end
    // class2  start|------------|end
    if ((class1.startTime.convertToInt() <= class2.endTime.convertToInt()
          &&
          class2.endTime.convertToInt() <= class1.endTime.convertToInt())
        ||
        (class2.startTime.convertToInt() <= class1.startTime.convertToInt()
          &&
          class1.startTime.convertToInt() <= class2.endTime.convertToInt())) {
      return true;
    }
    //if no class times for the courses intersect, there are no conflicts, so return false
    return false;
  }

  //check for conflict between the courses' section's lecture times
  //from making the combinations, each course in this schedule (schedulesOneSection) has only one section (but still multiple tutorials and labs)
  static bool lectureConflictExists(List<Course> schedule) {
    int numOfCourses = schedule.length;

    //iterate through each course in the list
    for (int currentCourseIndex = 0; currentCourseIndex < numOfCourses; currentCourseIndex++) {
      //for each course, compare it with every other course in the list by iterating
      // through each course in the list starting after the current course
      for (int courseBeingComparedIndex = currentCourseIndex + 1; courseBeingComparedIndex < numOfCourses; courseBeingComparedIndex++) {
        //to check if the current course's section's lectures conflicts with the course being compared to, must check
        // for conflict between the section's lectures for both courses
        //to do this, iterate through each lecture times in the current course's section
        for (Section currentCourseSection in schedule[currentCourseIndex].sections) { //this will only run once and could just be replaced with schedule[currentCourseIndex].sections[0] since there is only one section
          // print('$currentCourseIndex course section');

          for (ClassTime classTimeCurrentCourse in currentCourseSection.lectureTimes!) {

            //then iterate through each lecture times in the section for course being compared to
            for (Section courseBeingComparedSection in schedule[courseBeingComparedIndex].sections) {  //likewise, this will also only iterate once since there should only be one section

              for (ClassTime classTimeCourseBeingCompared in courseBeingComparedSection.lectureTimes) {
                //check for conflict between the two class's times by seeing if they intersect each other
                if (timeConflictExists(classTimeCurrentCourse, classTimeCourseBeingCompared)) {
                  return true;
                }
              }
            }
          }
        }
      }
    }
    //no courses have section lecture conflicts, return false
    return false;
  }

  //check for conflict between the courses' tutorial times
  //from making the tutorial combinations, each course in this schedule (schedulesOneSectionOneTut) has only one section and one/no tutorial (but still has multiple labs)
  static bool tutorialConflictExists(List<Course> schedule) {
    int numOfCourses = schedule.length;

    //must check current tutorial time with every course's section's lecture times and every other course's tutorial times
    // checking current tutorial against its own course's section's lecture times just in case - I don't think any courses have conflicting tutorial / lab times with itself

    //iterate through each course in the list
    for (int currentCourseIndex = 0; currentCourseIndex < numOfCourses; currentCourseIndex++) {
      for (Tutorial currentCourseTutorial in schedule[currentCourseIndex].tutorials) { //this will either iterate once or none since there should be one or no tutorial
        ClassTime currentCourseTutorialTime = currentCourseTutorial.tutorialTime;

        //compare current tutorial to every course's section's lecture times (including self) in the list
        for (int courseBeingComparedIndex = 0; courseBeingComparedIndex < numOfCourses; courseBeingComparedIndex++) {
          //to check if current tutorial conflicts with the course being compared to,
          // must check for conflict between (current tutorial and compared to course's section's lectures times), AND (current tutorial and compared to course's tutorial times)
          //first check tutorial time against the compared to course's section's lecture times
          for (Section courseBeingComparedSection in schedule[courseBeingComparedIndex].sections) { //only iterates once since there should only be one section
            for (ClassTime classTimeCourseBeingCompared in courseBeingComparedSection.lectureTimes) {
              if (timeConflictExists(currentCourseTutorialTime, classTimeCourseBeingCompared)) {
                return true;
              }
            }
          }

          //then check current tutorial time against the compared to course's tutorial time
          for (Tutorial compareCourseTutorial in schedule[courseBeingComparedIndex].tutorials) {
            //if it's the same course, don't compare because it's the same tutorial
            if (currentCourseIndex == courseBeingComparedIndex) {
              break;
            }
            ClassTime compareCourseTutorialTime = compareCourseTutorial.tutorialTime;
            if (timeConflictExists(currentCourseTutorialTime, compareCourseTutorialTime)) {
              return true;
            }
          }

        }
      }
    }
    //if made to end, no conflicts
    return false;
  }

  //check for conflict between the course's lab times
  //from making the lab combinations, each course in this schedule (schedulesOneSectionOneTutOneLab) has only one section and one/non tutorial and one/non lab
  static bool labConflictExists(List<Course> schedule) {
    int numOfCourses = schedule.length;
    // print('num ${numOfCourses}');

    //like tutorials, must check current lab time against every course's section's lecture times and tutorial times, and every other course's lab times

    //iterate through each course in the list
    for (int currentCourseIndex = 0; currentCourseIndex < numOfCourses; currentCourseIndex++) {
      // print(currentCourseIndex);
      for (Laboratory currentCourseLab in schedule[currentCourseIndex].labs) {
        // print('lab exists course${currentCourseIndex}');
        ClassTime currentCourseLabTime = currentCourseLab.labTime;

        //compare current lab to every course's class times (including self)
        for (int courseBeingComparedIndex = 0; courseBeingComparedIndex < numOfCourses; courseBeingComparedIndex++) {
          // print(courseBeingComparedIndex);
          // print('checking sections');
          //first check for conflict between the current lab time and the compared to course's section's lecture times
          for (Section courseBeingComparedSection in schedule[courseBeingComparedIndex].sections) { //only iterates once since there should only be one section
            for (ClassTime classTimeCourseBeingCompared in courseBeingComparedSection.lectureTimes) {
              if (timeConflictExists(currentCourseLabTime, classTimeCourseBeingCompared)) {
                return true;
              }
            }
          }
          //then compare current lab time against all tutorial times (including self)
          for (Tutorial compareCourseTutorial in schedule[courseBeingComparedIndex].tutorials) { //iterates either once or none since there can be one / no tutorial
            // print('checking tuts');
            ClassTime tutorialTime = compareCourseTutorial.tutorialTime;
            if (timeConflictExists(currentCourseLabTime, tutorialTime)) {
              return true;
            }
          }
          //finally, check current lab time against the compared to course's lab time
          for (Laboratory compareCourseLab in schedule[courseBeingComparedIndex].labs) {
            // print('checking lab');
            //if it's the same course, don't compare because it's the same lab time
            if (currentCourseIndex == courseBeingComparedIndex) {
              break;
            }
            ClassTime compareCourseLabTime = compareCourseLab.labTime;
            if (timeConflictExists(currentCourseLabTime, compareCourseLabTime)) {
              return true;
            }
          }
        }
      }
    }
    //if made it to end, no conflicts
    return false;
  }


//containsCourse - used to check if the schedule contains a course with the given className.
  //plan to be used in future for searching schedules by class name
  bool containsCourse(String className) {
    //or maybe pass it a Course object? and do if paramCourse.clasName = course.className
    for (Course course in courses!) {
      if (course.courseName == className) {
        return true;
      }
    }
    return false;
  }

}