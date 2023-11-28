import 'package:flutter/material.dart';

class IntroPage3  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200],

        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Check your accomodations!", style: TextStyle(fontSize: 20),),
          ],
        )
    );
  }
}


