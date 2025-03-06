import 'package:flutter/material.dart';

class HelpScreen3 extends StatelessWidget {
  const HelpScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const Text(
              'Click on the "Create Account Button and follow instructions.',
              style: TextStyle(fontSize: 18),
            ),
            const Text(
              'Then come back to the menu and click on "Sign In".',
              style: TextStyle(fontSize: 18),
            ),
            Image.asset(
              'assets/images/hs3.png',
              height: 500,
              width: 700,
            )
          ],
        ),
      ),
    );
  }
}
