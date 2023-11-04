import 'package:flutter/material.dart';

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
        ),
        body: ListView.separated(
            padding: EdgeInsets.all(10.0),
            itemCount: 5, // temp
            separatorBuilder: (context, index) => Divider(height: 2),
            itemBuilder: (context, index) {
              return Container(
                  color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Course Name:'),
                      ),
                      Container(
                        color: Colors.blue[400],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Class Meeting Time"),
                            //TEMPORARILY USING TextFormField - WILL SWITCH TO DROPDOWN MENUS OR SOMETHING
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Start time'),
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'End time'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            }));
  }
}
