class Course {
  String? className;
  List<ClassTime>? times;
  //to get each class time, you can loop through this list and get the start/end time for each class
  //e.g. for (i = 0 to length) {starttime = times[i].startTime endtime = times[i].endTime}
  //or something like: for classTime in times {startTime = classTime.startTime endTime = classTime.endTime}

}

class ClassTime {
  double? startTime;
  double? endTime;

}
