import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Radio Buttons Example'),
        ),
        body: ContainerList(),
      ),
    );
  }
}

class ContainerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Change the number of containers as needed
      itemBuilder: (context, index) {
        return RadioContainerListItem();
      },
    );
  }
}

class RadioContainerListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: ElevatedButton(
        onPressed: () {
          _showRadioPopup(context);
        },
        child: Text('Show Radio Buttons'),
      ),
    );
  }

  // Function to show the pop-up with radio buttons
  void _showRadioPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Start Time:'),
                  RadioContainer(groupValue: 0),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('End Time:'),
                  RadioContainer(groupValue: 1),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class RadioContainer extends StatefulWidget {
  final int groupValue;

  const RadioContainer({required this.groupValue});

  @override
  _RadioContainerState createState() => _RadioContainerState();
}

class _RadioContainerState extends State<RadioContainer> {
  late int radioValue;

  @override
  void initState() {
    super.initState();
    // Initialize radioValue based on the groupValue
    radioValue = widget.groupValue * 8;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(8, (index) {
        return Row(
          children: [
            Radio(
              value: radioValue + index,
              groupValue: radioValue,
              onChanged: (int? value) {
                setState(() {
                  radioValue = value!;
                });
              },
            ),
            Text('Option $index'),
          ],
        );
      }),
    );
  }
}
