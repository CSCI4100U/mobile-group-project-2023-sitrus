import 'package:flutter/material.dart';

import 'schedule_display_generated_page.dart';

import '../models/schedule_course_info_widget.dart';

import '../models/schedule_course_model.dart';


class CreateNewSchedulePage extends StatefulWidget {

  List<CourseInfoContainer> courseInfoContainerList = [];

  @override
  _CreateNewSchedulePageState createState() => _CreateNewSchedulePageState();
}

class _CreateNewSchedulePageState extends State<CreateNewSchedulePage> {

  // List<CourseInfoContainer> courseInfoContainerList = [CourseInfoContainer(name: 'Course 1')];

  void initState() {
    super.initState();
    addCourseContainer();
  }

  List<Course> getAllCourses() {
    List<Course> courses = [];
    for (CourseInfoContainer courseInfoContainer in widget.courseInfoContainerList) {
      courses.add(courseInfoContainer.getCourse());
    }
    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Maker (testing)', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF243f6e),
        actions: [
          ElevatedButton(
            onPressed: () {
              List<Course> courses = [];
              courses = getAllCourses();
              if (courses.length < 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please have at least 5 courses'),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DisplayGeneratedSchedulesPage(
                              coursesFromInput: courses)),
                );
              }
            },
            child: Text('Done', style: TextStyle(fontSize: 18.0, color: Color(0xFF243f6e),)
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.courseInfoContainerList.length,
            itemBuilder: (context, index) {
              return widget.courseInfoContainerList[index];
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add, size: 36.0,),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                textStyle: const TextStyle(fontSize: 36.0,),
              ),
              onPressed: () {
                setState(() {
                  addCourseContainer();
                });
              },
              label: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(right: 40.0, top: 30.0, bottom: 30.0),
                    child: Text(
                      "Add Course",
                      style: TextStyle(
                        fontSize: 32.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addCourseContainer() {
    widget.courseInfoContainerList.add(CourseInfoContainer(
        name: 'Course',
        id: widget.courseInfoContainerList.length,
        onDelete: (int id) {
          setState(() {
            widget.courseInfoContainerList.removeAt(id);
            updateID();
          });
        })
    );
    // courseInfoContainerList[0]
  }

  void updateID() {
    for (int i = 0; i < widget.courseInfoContainerList.length; i++) {
      widget.courseInfoContainerList[i].id = i;
    }
  }

}
