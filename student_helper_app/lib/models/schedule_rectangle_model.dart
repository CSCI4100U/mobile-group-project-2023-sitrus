import 'package:flutter/material.dart';
import 'schedule_course_model.dart';
import 'schedule_schedule_model.dart';

class CourseRectangle {
  final double x;
  final double y;
  final double width;
  final double height;
  final Color color;
  final String courseName;

  CourseRectangle(
      {required this.x,
        required this.y,
        required this.width,
        required this.height,
        required this.color,
        required this.courseName});

  //generates a list of lists of rectangles representing the the list of schedules (list of lists of courses) given
  static List<List<CourseRectangle>> convertSchedulesListToRectangles(
      List<Schedule> validatedSchedules) {
    //create a list containing lists of rectangles
    List<List<CourseRectangle>> schedulesAsRectanglesList = [];
    //convert each schedule (List<Course>) in validated schedules (List<List<Course>>) to a
    // schedule (List<Course> -> List<Rectangle>) represented by rectangles, and add it to the list containing
    // lists of rectangles  (List<List<Rectangle>> add List<Rectangle>)
    for (Schedule schedule in validatedSchedules) {
      List<CourseRectangle> scheduleAsRectangles =
      convertScheduleToRectangles(schedule);

      schedulesAsRectanglesList.add(scheduleAsRectangles);
    }
    return schedulesAsRectanglesList;
  }

  //generates a list of rectangles representing the schedule (list of courses) given
  static List<CourseRectangle> convertScheduleToRectangles(Schedule schedule) {
    List<CourseRectangle> scheduleAsRectangles = [];
    for (Course course in schedule.courses!) {
      List<CourseRectangle> courseAsRectangles =
      convertCourseToRectangles(course);
      scheduleAsRectangles.addAll(courseAsRectangles);
    }
    return scheduleAsRectangles;
  }

  //generates a list of rectangles based on the class times and day of week for the course given
  // since each course can have multiple class times on different days (e.g. mobile devices on wed & fri)
  static List<CourseRectangle> convertCourseToRectangles(Course course) {
    //note for potential change: could pass a course.time (ClassTime) object to this instead and return a rectangle...?
    List<CourseRectangle> courseAsRectangles = [];
    for (ClassTime classTime in course.times!) {
      double height = classTime.lengthOfClass().toDouble();
      height = height / 5;
      double yPosition = classTime.startTime!.convertToInt().toDouble();
      yPosition = (yPosition - 800) / 5;
      double xPosition = classTime.getDayOfWeekAsInt().toDouble();
      xPosition = xPosition * 45;
      courseAsRectangles.add(CourseRectangle(
          x: xPosition,
          y: yPosition,
          width: 45,
          height: height,
          color: course.color!,
          courseName: course.courseName!
      ));
    }

    // for (int i = 0; i < rectangles.length; i++) {
    //   print(rectangles[i].height);
    // }

    return courseAsRectangles;
  }
}

class RectanglePainter extends CustomPainter {
  final List<CourseRectangle> scheduleAsRectangles;

  RectanglePainter(this.scheduleAsRectangles);

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    //draw the gridlines
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
          text: classAsRectangle.courseName,
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
