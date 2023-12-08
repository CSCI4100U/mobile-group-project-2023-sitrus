import 'package:flutter/material.dart';

class Course {
  String courseName;

  List<Section> sections;
  List<Tutorial> tutorials;
  List<Laboratory> labs;

  Color color;

  Course(
      {required this.courseName, required this.sections, required this.tutorials, required this.labs, required this.color});

//maybe have a setColor function?
}

class Section {
  List<ClassTime> lectureTimes;
  Section({required this.lectureTimes});
}

class Tutorial {
  ClassTime tutorialTime;
  Tutorial({required this.tutorialTime});
}

class Laboratory {
  ClassTime labTime;
  Laboratory({required this.labTime});
}

class ClassTime {
  HourMinute startTime;
  HourMinute endTime;
  String dayOfWeek;

  ClassTime({required this.startTime, required this.endTime, required this.dayOfWeek});

  int lengthOfClass() {
    return this.endTime!.convertToInt() - this.startTime!.convertToInt();
  }

  int getDayOfWeekAsInt() {
    //maybe use switch statements? idk if it's necessarily faster/better

    //no Sunday/Saturday because normal courses don't occur on weekends
    if (dayOfWeek == "Monday") {
      return 0;
    } else if (dayOfWeek == "Tuesday") {
      return 1;
    } else if (dayOfWeek == "Wednesday") {
      return 2;
    } else if (dayOfWeek == "Thursday") {
      return 3;
    } else { //Friday
      return 4;
    }
  }
}

class HourMinute {
  int hour;
  int minute;

  HourMinute({required this.hour, required this.minute});

  int convertToInt() {
    return (this.hour! * 100) + (this.minute!);
  }
}