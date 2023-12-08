import 'package:flutter/material.dart';
import 'schedule_course_model.dart';
import 'schedule_schedule_model.dart';

class ClassRectangle {
  final double x;
  final double y;
  final double width;
  final double height;
  final Color color;
  final String rectangleName;

  ClassRectangle(
      {
        required this.x,
        required this.y,
        required this.width,
        required this.height,
        required this.color,
        required this.rectangleName
      });

  //generates a list of lists of rectangles representing the the list of schedules (list of lists of courses) given
  static List<List<ClassRectangle>> convertSchedulesListToRectangles(List<List<Course>> validatedSchedules) {
    //create a list containing lists of rectangles
    List<List<ClassRectangle>> schedulesAsRectanglesList = [];
    //convert each schedule (List<Course>) in validated schedules (List<List<Course>>) to a
    // schedule (List<Course> -> List<Rectangle>) represented by rectangles, and add it to the list containing
    // lists of rectangles  (List<List<Rectangle>> add List<Rectangle>)
    for (List<Course> schedule in validatedSchedules) {
      List<ClassRectangle> scheduleAsRectangles = convertScheduleToRectangles(schedule);

      schedulesAsRectanglesList.add(scheduleAsRectangles);
    }
    return schedulesAsRectanglesList;
  }

  //generates a list of rectangles representing the schedule (list of courses) given
  static List<ClassRectangle> convertScheduleToRectangles(List<Course> schedule) {
    List<ClassRectangle> scheduleAsRectangles = [];
    for (Course course in schedule) {
      List<ClassRectangle> courseAsRectangles = convertCourseToRectangles(course);
      scheduleAsRectangles.addAll(courseAsRectangles);
    }
    return scheduleAsRectangles;
  }

  //generates a list of rectangles based on the class times and day of week for the course given
  // since each course can have multiple class times on different days (e.g. mobile devices on wed & fri)
  static List<ClassRectangle> convertCourseToRectangles(Course course) {

    //note for potential change: could pass a course.time (ClassTime) object to this instead and return a rectangle...?

    List<ClassRectangle> courseAsRectangles = [];

    //first add all the rectangles for the lecture times
    for (ClassTime lectureTime in course.sections[0].lectureTimes) {  //each course in each schedule should only have one section from all the combination stuff
      courseAsRectangles.add(convertClassToRectangle(course, lectureTime, "lab"));
    }

    //add the rectangle for tut time if tut exists
    if (course.tutorials.isNotEmpty) {  //each course in each schedule should only have one/no tuts
      ClassTime tutorialTime = course.tutorials[0].tutorialTime;
      courseAsRectangles.add(convertClassToRectangle(course, tutorialTime, 'Tut'));
    }

    //add the rectangle for lab time if lab exists
    if (course.labs.isNotEmpty) {  //each course in each schedule should only have one/no labs
      ClassTime labTime = course.labs[0].labTime;
      courseAsRectangles.add(convertClassToRectangle(course, labTime, 'Lab'));
    }

    // for (int i = 0; i < rectangles.length; i++) {
    //   print(rectangles[i].height);
    // }

    return courseAsRectangles;
  }

  static ClassRectangle convertClassToRectangle(Course course, ClassTime classTime, String classType) {
    double height = classTime.lengthOfClass().toDouble();
    height = height / 5;
    double yPosition = classTime.startTime!.convertToInt().toDouble();
    yPosition = (yPosition - 800) / 5;
    double xPosition = classTime.getDayOfWeekAsInt().toDouble();
    xPosition = xPosition * 45;
    ClassRectangle classRectnagle = ClassRectangle(
      x: xPosition,
      y: yPosition,
      width: 45,
      height: height,
      color: course.color!,
      rectangleName: '${course.courseName} ${classType}',
    );
    return classRectnagle;
  }
}


class RectanglePainter extends CustomPainter {
  final List<ClassRectangle> scheduleAsRectangles;

  RectanglePainter(this.scheduleAsRectangles);

  @override
  void paint(Canvas canvas, Size size) {

    //move day of week and times here and draw so it's aligned properly


    //draw the gridlines
    final gridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    const double horizontalGridSize = 45.0;
    const double verticalGridSize = 20.0;
    for (double i = 0; i <= size.width; i += horizontalGridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i <= size.height; i += verticalGridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    //draw the rectangles
    for (var classAsRectangle in scheduleAsRectangles) {
      final paint = Paint()..color = classAsRectangle.color;
      canvas.drawRect(
        Rect.fromPoints(
          Offset(classAsRectangle.x, classAsRectangle.y),
          Offset(classAsRectangle.x + classAsRectangle.width,
              classAsRectangle.y + classAsRectangle.height),
        ),
        paint,
      );

      //draw text inside the rectangle
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: classAsRectangle.rectangleName,
          style: TextStyle(color: Colors.black, fontSize: 12.0),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: 0, maxWidth: classAsRectangle.width);
      textPainter.paint(canvas, Offset(classAsRectangle.x, classAsRectangle.y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
