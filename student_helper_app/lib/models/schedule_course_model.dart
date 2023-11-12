//course.dart
class Course {
  String? className;
  String? dayOfWeek;
  List<ClassTime>? times;

  Course(this.className, this.times);
  //to get each class time, you can loop through this list and get the start/end time for each class
  //e.g. for (i = 0 to length) {starttime = times[i].startTime endtime = times[i].endTime}
  //or something like: for classTime in times {startTime = classTime.startTime endTime = classTime.endTime}

}

class ClassTime {
  HourMinute? startTime;
  HourMinute? endTime;

  ClassTime(this.startTime, this.endTime);

}

class HourMinute {
  int? hour;
  int? minute;

  HourMinute(this.hour, this.minute);

  int convertToInt() {
    return (this.hour! * 1000) + (this.minute!);
  }
}