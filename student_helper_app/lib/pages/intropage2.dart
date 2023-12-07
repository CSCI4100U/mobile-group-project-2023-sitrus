import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {

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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add your classes!", style: TextStyle(fontSize: 30, color: Colors.white)),
            //Image

          ],
        )
    );
  }
}