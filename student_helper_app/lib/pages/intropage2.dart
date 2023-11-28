import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[300],
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add your classes!", style: TextStyle(fontSize: 20),),
          ],
        )
    );
  }
}