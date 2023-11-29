
import 'package:flutter/material.dart';
import 'package:student_helper_project/models/sas_model/Accommodation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  FAQPageState createState() => FAQPageState();
}

class FAQPageState extends State<FAQPage> {
  final List<FAQItem> faqList = [
    FAQItem(
      question: 'What are accommodations?',
      answer: 'Accommodations are services provided to students with disabilities/handicaps that prevent them'
          'from working at the same level as their peers.',
    ),
    FAQItem(
      question: 'Do I have accommodations?',
      answer: 'If you are registered with your universitys student accessibility services'
          'it is very likely that you have accommodations.',
    ),
    FAQItem(
      question: 'What is this for?',
      answer: 'This part of the app is meant to make the process of managing your accommodations easier.'
          'Navigating Student Accessibility can be complicated, especially for those unfamiliar with it.'
          'Here, you can see how your accommodations affect the way you take assignments.'
          'You can also schedule your upcoming assignments, to see what your accommodations provide you with.',

    ),
    FAQItem(
      question: 'How can I register for Student Accessibility?',
      answer: '',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ Page'),
      ),
      body: ListView.builder(
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqList[index].question),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(faqList[index].answer),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
