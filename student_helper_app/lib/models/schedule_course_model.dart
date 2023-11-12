import 'package:flutter/material.dart';

class Course {
  String? className;
  List<ClassTime>? times;
  Color? color;

  Course(this.className, this.times, this.color);

  //maybe have a setColor function?
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

    if (dayOfWeek == "Sunday") {
      return 0;
    } else if (dayOfWeek == "Monday") {
      return 1;
    } else if (dayOfWeek == "Tuesday") {
      return 2;
    } else if (dayOfWeek == "Wednesday") {
      return 3;
    } else if (dayOfWeek == "Thursday") {
      return 4;
    } else if (dayOfWeek == "Friday") {
      return 5;
    } else {  //Saturday
      return 6;
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