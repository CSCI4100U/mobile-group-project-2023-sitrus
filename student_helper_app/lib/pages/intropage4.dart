import 'package:flutter/material.dart';

class IntroPage4 extends StatelessWidget {
  const IntroPage4({super.key});


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
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Chat with Friends!", style: TextStyle(fontSize: 30, color: Colors.white)),
            //Image
            Image(image: AssetImage('assets/chat.jpg'),
              height: 500,)
          ],
        )

    );
  }
}


