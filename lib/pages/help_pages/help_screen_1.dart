import 'package:flutter/material.dart';

String txt1 = '''
You may do this by using the browser on your phone and once obtaining 
the key go back to the instruction page and paste the key into the textbox 
and save the key. You may also use a browser that is not on you phone to obtain 
and copying the key  
but you must then have a way of copying the key and pasting it on the phone.
The last page of the instructions will list a few ways of doing this.
'''
    .replaceAll('\n', ' ');

class HelpScreen1 extends StatelessWidget {
  const HelpScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 10,
        children: [
          const Text(
              'In order to use this application you need to obtain a VisualCrossing key.'),
          const Text(
              'This FREE key may be obtained by going to https://visualcrossing.com/sign-up#.'),
          Text(
            txt1,
            softWrap: true,
            textAlign: TextAlign.left,
          ),
          const Text(
              'Now click on the "NEXT" button below for instructions on how to get a key.')
        ],
      ),
    );
  }
}
