//display campus map with features like seeing current location, friends location, clicking buildings for info
//this should probably be a lower priority feature

import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Campus Map"),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //temp placement for map if we want to have map
              Container(
                width: 380,
                height: 600,
                color: Colors.red,
              ),
            ]));
  }
}
