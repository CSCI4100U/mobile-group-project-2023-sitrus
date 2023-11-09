import 'package:flutter/material.dart';
import '../models/schedule_formsWidget.dart';

class CreateNewSchedulePage extends StatefulWidget {
  const CreateNewSchedulePage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateNewSchedulePageState();
}

class _CreateNewSchedulePageState extends State<CreateNewSchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Make New Schedules"),
          //TEMPORARY BUTTON TO RELOAD PAGE VIA SETSTATE, WILL NEED TO CREATE A FUNCTION OR SOMETHING TO RELOAD SPECIFIC WIDGETS
          actions: [
            IconButton(
                onPressed: () {setState(() {

                });},
                icon: Icon(Icons.change_circle))
          ],
        ),
        body: ListView.separated(
            padding: EdgeInsets.all(10.0),
            itemCount: 5, // temp
            separatorBuilder: (context, index) => Divider(height: 2),
            itemBuilder: (context, index) {
              return ScheduleFormsWidget(index, 1, 1).build(context);
            })
    );
  }
}
