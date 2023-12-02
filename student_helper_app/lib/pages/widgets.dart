// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header(this.heading, {super.key});
  final String heading;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      heading,
      style: const TextStyle(fontSize: 24),
    ),
  );
}

class Paragraph extends StatelessWidget {
  const Paragraph(this.content, {super.key});
  final String content;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Text(
      content,
      style: const TextStyle(fontSize: 18),
    ),
  );
}

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail, {super.key});
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          detail,
          style: const TextStyle(fontSize: 18),
        )
      ],
    ),
  );
}

class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed, super.key});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.orange)),
    onPressed: onPressed,
    child: child,
  );
}

class ProfileTabs extends StatelessWidget{

  final String text;
  final String title;
  final Function()?onPressed;

  const ProfileTabs({
    super.key,
    required this.title,
    required this.text,
    required this.onPressed

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
        BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.circular(10),
        ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$title: ", style:
                TextStyle(
                  fontSize: 20,

                ),),

            IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit)
            )
            ],
              
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Text(text,
              style:
              TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
          )
        ],

      ),



    );
  }
}

