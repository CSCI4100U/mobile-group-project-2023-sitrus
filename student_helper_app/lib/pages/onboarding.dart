import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:student_helper_project/pages/home_page.dart';
import 'package:student_helper_project/pages/intropage1.dart';
import 'package:student_helper_project/pages/intropage2.dart';
import 'package:student_helper_project/pages/intropage3.dart';
import 'package:student_helper_project/pages/new_home_page.dart';

import 'intropage4.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  PageController _controller = PageController();
  bool onLastPage = false;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [PageView(
          controller: _controller,
          onPageChanged: (index){
            setState(() {
              onLastPage = (index == 3);
            });
          },
          children: [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
            IntroPage4()
          ],
        ),
          Container(
            alignment: Alignment(0, 0.92),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      _controller.jumpToPage(3);
                    },
                    child: const Text("skip",
                        style: TextStyle(fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  SmoothPageIndicator(controller: _controller, count: 4),

                  onLastPage ?
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) {
                            return NewHomePage();
                          }));
                    },
                    child: const Text(
                      "done",
                      style: TextStyle(fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  ) : GestureDetector(
                    onTap: (){
                      _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear);
                    },
                    child: const Text("next",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                    ),
                  )
                ],
              )
          ),
        ]
      )

      );

  }
}
