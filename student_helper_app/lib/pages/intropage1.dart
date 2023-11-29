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
                Colors.blue[700]!,
                Colors.blue[200]!,
              ],
            )
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to Sitrus, Your Student Aid App!", style: TextStyle(fontSize: 20, color: Colors.white), ),
          ],
        )

    );
  }
}


