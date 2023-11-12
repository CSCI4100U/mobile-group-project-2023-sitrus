import 'schedule_course_model.dart';

//for demo, it is fixed to 5 courses in a schedule object (i.e. courses list is length 5)

class Schedule {
  List<Course>? courses;

  Schedule(this.courses);

  static List<Schedule> validateSchedules(List<List<Course>> schedules) {
    List<Schedule> validatedSchedules = [];

    for (List<Course> schedule in schedules) {
      if (!conflictExists(schedule)) {
        validatedSchedules.add(Schedule(schedule));
      }
    }
    return validatedSchedules;
  }

  static bool conflictExists(List<Course> schedule) {
    int numOfCourses = schedule.length;
    //to check for conflict between every course in the schedule
    //iterate through each course in the list
    for (int currentCourseIndex = 0; currentCourseIndex < numOfCourses; currentCourseIndex++) {
      //for each course, compare it with every other course in the list by iterating
      // through each course in the list starting after the current course
      for (int courseBeingComparedIndex = currentCourseIndex + 1; courseBeingComparedIndex < numOfCourses; courseBeingComparedIndex++) {
        //to check if the current course conflicts with the course being compared to, must check
        // for conflict between the class times for both courses
        //to do this, iterate through each class's times in the list of class's times for current course
        for (ClassTime classTimeCurrentCourse
        in schedule[currentCourseIndex].times!) {
          //then iterate through each class's times in the list of class's time for course being compared to
          for (ClassTime classTimeCourseBeingCompared
          in schedule[courseBeingComparedIndex].times!) {
            //check for conflict between the two class's times by seeing if they intersect each other

            //if the classes are on different days, they don't intersect
            if (classTimeCurrentCourse.dayOfWeek !=
                classTimeCourseBeingCompared.dayOfWeek) {
              break;
            }
            //if classes are on same day, check for conflict
            //class times intersect if either course's start/end time is in between the other course's time
            //if statement 1 (splitting because the comparisons are too long...:
            // i.e. (currentCourse.starTime < courseBeingCompared.startTime < currentCourse.endTime) or
            //      (courseBeingComparedTo.startTime < currentCourse.endTime < courseBeingComparedTo.endTime)
            //visual representation:
            // currentCourse: start|------------|end
            // courseBeingCompared    start|------------|end
            if ((classTimeCurrentCourse.startTime!.convertToInt() <
                  classTimeCourseBeingCompared.startTime!.convertToInt()
                  &&
                  classTimeCourseBeingCompared.startTime!.convertToInt() <
                  classTimeCurrentCourse.endTime!.convertToInt())
                ||
                (classTimeCourseBeingCompared.startTime!.convertToInt() <
                  classTimeCurrentCourse.endTime!.convertToInt()
                  &&
                  classTimeCurrentCourse.endTime!.convertToInt() <
                  classTimeCourseBeingCompared.endTime!.convertToInt())) {
              return true;
            }
            //if statement 2:
            // i.e (currentCourse.startTime < courseBeingComparedTo.endTime < currentCourse.endTime) or
            //      (courseBeingComparedTo.startTime < currentCourse.startTime < courseBeingComparedTo.endTime)
            //visual representation
            // currentCourse:             start|------------|end
            // courseBeingCompared  start|------------|end
            if ((classTimeCurrentCourse.startTime!.convertToInt() <
                  classTimeCourseBeingCompared.endTime!.convertToInt()
                  &&
                  classTimeCourseBeingCompared.endTime!.convertToInt() <
                  classTimeCurrentCourse.endTime!.convertToInt())
                ||
                (classTimeCourseBeingCompared.startTime!.convertToInt() <
                  classTimeCurrentCourse.startTime!.convertToInt()
                  &&
                  classTimeCurrentCourse.startTime!.convertToInt() <
                  classTimeCourseBeingCompared.endTime!.convertToInt())) {
              return true;
            }
          }
        }
      }
    }
    //if no class times for the courses intersect, there are no conflicts, so return false
    return false;
  }

//containsCourse - used to check if the schedule contains a course with the given className.
  //plan to be used in future for searching schedules by class name
  bool containsCourse(String className) {
    //or maybe pass it a Course object? and do if paramCourse.clasName = course.className
    for (Course course in courses!) {
      if (course.className == className) {
        return true;
      }
    }
    return false;
  }

}