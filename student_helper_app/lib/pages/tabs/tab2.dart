import 'package:flutter/material.dart';


class FriendsTab extends StatelessWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Friends Page", style: TextStyle(
              fontSize: 24
            ),),
          ),

          Text("Add Friends Using The Plus Button", style: TextStyle(
          fontSize: 18
    ),),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(image: AssetImage('assets/add_friends.jpg')),
          ),
          Text("Search and Filter your Friends with these buttons", style: TextStyle(
              fontSize: 18
          ),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(image: AssetImage('assets/buttons.jpg')),
          )



        ],
      ),
    );
  }
}
