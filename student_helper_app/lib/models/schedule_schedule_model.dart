import 'schedule_course_model.dart';
//schedule.dart
class Schedule {
  List<Course>? courses;

  //containsCourse - used to check if the schedule contains a course with the given className.
  //plan to be used for searching schedules by class name
  bool containsCourse(String className) {
    //or maybe pass it a Course object? and do if paramCourse.clasName = course.className
    for (Course course in courses!) {
      if (course.className == className) {
        return true;
      }
    }
    return false;
  }
  //maybe have a function that returns a map ??

  //don't worry about below... my brain stopped working or something and i started typing stuff
  //courses list is:
  // [course1, course2]
  //expands to a list of Course, each with className, and times list
  //[
  //  [className1, times],
  //  [className1, times],
  //]
  //
  //[
  //  [className1, [
  //    classTime1, classTime2
  //    ]
  //  ],
  //  [className1, [
  //    classTime1, classTime2
  //    ]
  //  ],
  //]

}