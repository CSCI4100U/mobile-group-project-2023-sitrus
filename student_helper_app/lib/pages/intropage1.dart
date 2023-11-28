import 'package:flutter/material.dart';

class IntroPage1  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[400],
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to Sitrus, Your Student Aid App!", style: TextStyle(fontSize: 20),),
          ],
        )

    );
  }
}


