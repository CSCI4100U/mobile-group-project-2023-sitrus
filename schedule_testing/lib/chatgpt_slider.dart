import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Picker App'),
      ),
      body: ContainerList(),
    );
  }
}

class ContainerList extends StatefulWidget {
  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
  List<TimeRange> timeRanges = List.generate(
    5,
        (index) => TimeRange(
      name: 'Container ${index + 1}',
      startTime: 8.167, // 8:10 am
      endTime: 21.5,   // 9:30 pm
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: timeRanges.length,
      itemBuilder: (context, index) {
        return ContainerItem(timeRange: timeRanges[index]);
      },
    );
  }
}

class TimeRange {
  final String name;
  double startTime;
  double endTime;

  TimeRange({required this.name, required this.startTime, required this.endTime});
}

class ContainerItem extends StatefulWidget {
  final TimeRange timeRange;

  ContainerItem({required this.timeRange});

  @override
  _ContainerItemState createState() => _ContainerItemState();
}

class _ContainerItemState extends State<ContainerItem> {
  String _formatTime(double time) {
    int hours = time.toInt();
    int minutes = ((time - hours) * 60).toInt();

    String ampm = hours < 12 ? 'AM' : 'PM';
    hours = hours % 12;
    hours = hours == 0 ? 12 : hours; // Convert 0 to 12 for 12-hour format

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes $ampm';
  }

  double _snapToInterval(double value, List<double> intervals) {
    double interval = (intervals[1] - intervals[0]) / 2;
    double snappedValue = ((value - intervals[0] + interval) ~/ interval) * interval + intervals[0];
    return snappedValue.clamp(intervals[0], intervals[1]);
  }

  @override
  Widget build(BuildContext context) {
    List<double> leftIntervals = [8.167, 9.667, 11.167, 12.667, 14.167, 15.667, 17.167, 18.667, 20.167];
    List<double> rightIntervals = [9.5, 11.0, 12.5, 14.0, 15.5, 17.0, 18.5, 20.0, 21.5];

    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.timeRange.name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.0),
          RangeSlider(
            values: RangeValues(widget.timeRange.startTime, widget.timeRange.endTime),
            onChanged: (RangeValues values) {
              setState(() {
                widget.timeRange.startTime = _snapToInterval(values.start, leftIntervals);
                widget.timeRange.endTime = _snapToInterval(values.end, rightIntervals);
              });
            },
            min: 8.167, // 8:10 am
            max: 21.5,  // 9:30 pm
            divisions: 18,  // Adjust divisions based on your needs
            labels: RangeLabels(
              _formatTime(widget.timeRange.startTime),
              _formatTime(widget.timeRange.endTime),
            ),
          ),
        ],
      ),
    );
  }
}
