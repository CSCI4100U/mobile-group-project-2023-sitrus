import 'package:flutter/material.dart';

class IntroPage3  extends StatelessWidget {

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
            Text("Check your accomodations!",
              style: TextStyle(fontSize: 30, color: Colors.white)),
              //image
              Image(image: AssetImage('assets/accomodations.jpg'),
              height: 500,)
          ],
        )
    );
  }
}


