import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(

        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue[700]!,
                Colors.lightBlue[200]!,
              ],
            )
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("Welcome To Sitrus,",
                style: TextStyle(fontSize: 35, color: Colors.white),
              textAlign: TextAlign.center,),
            ),
            Center(
              child: Text("Your Student Aid App!",
                style: TextStyle(fontSize: 35, color: Colors.white),
                textAlign: TextAlign.center,),
            )
          ],
        )

    );
  }
}


