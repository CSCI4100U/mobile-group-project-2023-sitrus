
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
      answer: 'If you are registered with your universitys student accessibility services '
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
      answer: 'This is a process that requires a few steps, and is encouraged to be done as soon as possible.\n\nStep 1: You need to have recent documentation from a certified health care practitioner in the field to which the disability applies, '
          '\tand these must include the functional or cognitive limitations and impact on the student’s academic performance.\nYou may need'
          'to arrange an appointment to be reassessed to have more recent documentation.\n\n Step 2: Complete an intake form. This can be difficult to locate on UOITs student portal.'
          '\tFor this reason, the intake form has been included in Renew Accommodations.\n\n Step 3:'
          'You will need to complete a disability documentation form. This has been provided in Renew Accommodations.\n\nStep 4:'
          'Submit the intake and disability documents by emailing studentaccessibility@ontariotechu.ca. \n\nStep 5:'
          'Wait for an email response from  studentaccessibility@ontariotechu.ca.\n They will help you arrange'
          'an appointment with an accessibility advisor.'
      ,
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
                child: Text(
                  faqList[index].answer,
                  softWrap: true,
                ),
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
