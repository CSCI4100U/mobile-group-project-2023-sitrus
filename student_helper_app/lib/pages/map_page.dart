

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
          backgroundColor: Colors.indigo,
          title: const Text("Campus Map", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //temp placement for map if we want to have map
              Container(
                width: 380,
                height: 600,
                color: Colors.red[400],
              ),
            ]
        )
    );
  }
}
