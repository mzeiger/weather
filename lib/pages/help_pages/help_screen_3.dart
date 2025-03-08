import 'package:flutter/material.dart';

String txt1 = '''
There are a number of ways to import (paste) the key into the text box in the "Instructions"
page:
'''
    .replaceAll('\n', ' ');

String txt2 = '''
1. If you have used the browser on this phone to obtain the VisualCrossing key then just go back to the
"Instructions" page (by clicking the "back arrow" key at the top of this page) and 
clicking on the "Paste Key" button. Then click on the "Save Key" Button.
'''
    .replaceAll('\n', ' ');

String txt3 = '''
2. If you have used a browser on another device then you will need a way to paste
the key into this phone. If you have Phone Link (on an Adroid phone) then it is possible
to copy and paste from your computer to the phone.
'''
    .replaceAll('\n', ' ');

String txt4 = '''
3. You can also copy the key into an email message on your computer and the send the message
to yourself and open the message on you phone and copy/paste.
'''
    .replaceAll('\n', ' ');

String txt5 = '''
Just remember that once you have copied the key then you must go back to the "Instructions"
page by clicking on the "back arrow" at the top of this page), click on the "Paste Key"
button and the on the "Save Key" button.
'''
    .replaceAll('\n', ' ');

class HelpScreen3 extends StatelessWidget {
  const HelpScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          spacing: 10,
          children: [
            Text(
              txt1,
              style: const TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                txt2,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                txt3,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                txt4,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Text(
              txt5,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
