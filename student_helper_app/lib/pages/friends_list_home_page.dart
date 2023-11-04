//main home page for friends list. displays all friends in a (list view?) - (list tile?) with profile picture,
// name, and status (more or less). can click the list tile (friend) to open their profile
//*have small map initially on 1/3 of the screen or so - displays campus map and location of friends with location
// sharing on. *save this for later/not high priority
//small button (in appbar?) to add friends - editing and deleting should be done in friend's profile

import 'package:flutter/material.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<StatefulWidget> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {

  //get list of friends from cloud storage?
  // var friends_list = ...
  final tempFriendList = ["friend 1", "friend 2", "friend 3", "friend 4"];  //temp example 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Friends List"),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            //temp placement for map if we want to have the map idea
            Container(
              padding: EdgeInsets.all(10.0),
              width: 360,
              height: 250,
              color: Colors.red,
            ),
            SizedBox(height: 10,),
            Expanded(
                child: ListView.separated(
                  //update this with the actual friends list from database
                    padding: EdgeInsets.all(10),
                    itemCount: tempFriendList.length,
                    separatorBuilder: (context, index) => Divider(height: 2),
                    itemBuilder: (context, index) {
                      final friend = tempFriendList[index];
                      return ListTile(
                        title: Text(friend),
                        tileColor: index % 2 == 0 ? Colors.indigoAccent : Colors.blue,
                      );
                    }
                    )
            )
          ],
        ));
  }
}
