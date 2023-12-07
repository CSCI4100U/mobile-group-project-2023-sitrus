
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
        answerSections:[ 'Accommodations are services provided to students with disabilities/handicaps that prevent them'
            'from working at the same level as their peers.',]
    ),
    FAQItem(
        question: 'Do I have accommodations?',
        answerSections: ['If you are registered with your university\'s student accessibility services, '
            'it is very likely that you have accommodations.',]
    ),
    FAQItem(
        question: 'What is this for?',
        answerSections: ['This part of the app is meant to make the process of managing your accommodations easier.'
            'Navigating Student Accessibility can be complicated, especially for those unfamiliar with it.'
            'Here, you can see how your accommodations affect the way you take assignments.'
            'You can also schedule your upcoming assignments, to see what your accommodations provide you with.',
        ]
    ),
    FAQItem(
      question: 'How can I register for Student Accessibility?',
      answerSections: [
        'This is a process that requires a few steps and is encouraged to be done as soon as possible.',
        'Step 1: You need to have recent documentation from a certified health care practitioner in the field to which the disability applies, '
            'and these must include the functional or cognitive limitations and impact on the student’s academic performance.',
        'You may need to arrange an appointment to be reassessed to have more recent documentation.',
        'Step 2: Complete an intake form.',
        'This can be difficult to locate on UOIT\'s student portal. For this reason, the intake form has been included in Renew Accommodations.',
        'Step 3: You will need to complete a disability documentation form. This has been provided in Renew Accommodations.',
        'Step 4: Submit the intake and disability documents by emailing studentaccessibility@ontariotechu.ca.',
        'Step 5: Wait for an email response from studentaccessibility@ontariotechu.ca. They will help you arrange an appointment with an accessibility advisor.',
      ],
    ),
    FAQItem(
      question: 'Do my accommodations matter?',
      answerSections: [
        'Yes, they are.\nYour university has an obligation to ensure that your needs are met.'
            ' Otherwise, this could result in potential legal trouble. Your university also legally cannot deny '
            'a student their required services, or discriminate against them for having a disabilty.'
      ],
    ),
    FAQItem(
      question: 'Why is there a two week warning in Upcoming Assessments?',
      answerSections: [
        'That is because you have a limited time window to book an upcoming test or quiz with the Test Center, should you '
            'need it. If you wish to book an assessment with the test center, you must do so A MINIMUM of '
            'seven days before the assessment takes place.',
      ],
    ),
    FAQItem(
      question: 'Do I need to renew my accommodations regularly?',
      answerSections: [
        'You should renew your accommodations before the start of every semester.',
        'To do this, a short cut has been provided in this app.\nSimply go back from '
            'this page and select Renew Accommodations. The first link will take you to where you need to go.'
      ],
    ),
    FAQItem(
      question: 'Should my professors be aware that I have accommodations?',
      answerSections: [
        'Yes.\nIn order to provide you with what you require, your professors must be aware of your accommodations.\nYou do not have to tell them yourself, '
            'as when you renew your accommodations, it automatically sends your professors a letter ',
        'detailing what you need.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ Page'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: ListView.builder(
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqList[index].question),
            children: [
              Container(
                // Set a specific height or use constraints based on your design
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: faqList[index].answerSections.length,
                  itemBuilder: (context, sectionIndex) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        faqList[index].answerSections[sectionIndex],
                        softWrap: true,
                      ),
                    );
                  },
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
  //final String answer;
  Widget getFormattedAnswer() {
    return ListView.builder(
      itemCount: answerSections.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                // Check if the section starts with 'Step 1:' and make it bold
                answerSections[index].startsWith('Step')
                    ? TextSpan(
                  text: answerSections[index],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
                    : TextSpan(text: answerSections[index]),
              ],
            ),
          ),
        );
      },
    );
  }

  final List<String> answerSections;

  FAQItem({
    required this.question,
    required this.answerSections,
  });
}
