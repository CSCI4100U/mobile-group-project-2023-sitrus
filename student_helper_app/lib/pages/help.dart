import 'package:flutter/material.dart';
import 'package:student_helper_project/pages/tabs/tab1.dart';
import 'package:student_helper_project/pages/tabs/tab2.dart';
import 'package:student_helper_project/pages/tabs/tab3.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(appBar: AppBar(
          title: const Text("H E L P"),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          body: Column(
            children: [
              TabBar(
                dividerColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: [
                Tab(
                  icon: Icon(Icons.calendar_month,
                  color: Theme.of(context).colorScheme.background,),
                  ),
                Tab(
                  icon: Icon(Icons.chat_bubble,
                  color: Theme.of(context).colorScheme.background,),
                  ),
                Tab(
                  icon: Icon(Icons.person,
                  color: Theme.of(context).colorScheme.background,),
                  )

                ],
              ),
              Expanded(
                child: TabBarView(
                    children: [
                      ScheduleTab(),
                      FriendsTab(),
                      AccomodationsTab()

                    ]),
              )
            ],

          ),


      ),


    );
  }
}
