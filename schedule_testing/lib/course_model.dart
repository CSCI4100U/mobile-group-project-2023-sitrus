import 'package:flutter/material.dart';

class Course {
  String? courseName;

  List<Section> sections;
  List<Tutorial> tutorials;
  List<Laboratory> labs;

  Color? color;

  Course(this.courseName, this.sections, this.tutorials, this.labs, this.color);

  //maybe have a setColor function?
}

class Section {
  List<ClassTime>? lectureTimes;
  Section(this.lectureTimes);
}

class Tutorial {
  List<ClassTime>? tutorialTimes;
  Tutorial(this.tutorialTimes);
}

class Laboratory {
  List<ClassTime>? labTimes;
  Laboratory(this.labTimes);
}

class ClassTime {
  HourMinute? startTime;
  HourMinute? endTime;
  String? dayOfWeek;

  ClassTime(this.startTime, this.endTime, this.dayOfWeek);

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
  int? hour;
  int? minute;

  HourMinute(this.hour, this.minute);

  int convertToInt() {
    return (this.hour! * 100) + (this.minute!);
  }
}