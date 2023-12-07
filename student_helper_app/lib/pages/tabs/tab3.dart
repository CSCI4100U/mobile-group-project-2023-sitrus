import 'package:flutter/material.dart';


class AccomodationsTab extends StatelessWidget {
  const AccomodationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: ListView(
        children:
          const [Center(
            child: Text("Accomodations", style: TextStyle(
                fontSize: 24),),
          ),
      //image
            Center(
              child: Text(
                "Add, view, edit accomodations",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Image(image: AssetImage('assets/view_accomodations.jpg')),
            Center(
              child: Text(
                "Schedule and view upcoming accomodations",
                style: TextStyle(
                  fontSize: 18
              ),),
            ),
            Image(image: AssetImage('assets/upcoming_assessments.jpg')),
            Center(
              child: Text(
                "Helpful links to renew accomodations",
                style: TextStyle(
                  fontSize: 18
              ),),
            ),
            Image(image: AssetImage('assets/renew_accomodations.jpg')),
          ]




          ,

      ),
    );
  }
}
