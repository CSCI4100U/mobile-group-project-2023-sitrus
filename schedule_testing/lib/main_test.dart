import 'package:flutter/material.dart';
// import 'pages//schedule_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('check');
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: ScheduleMakerHomePage(),
    );
  }
}

class ScheduleMakerHomePage extends StatelessWidget{
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('hello'),
    );
  }
}