import 'package:flutter/material.dart';

class HelpScreen2 extends StatelessWidget {
  const HelpScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 6,
          children: [
            const Text(
              'Go to:',
              style: TextStyle(fontSize: 18),
            ),
            const Text(
              'https://www.visualcrossing.com/sign-up/',
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                  color: Color.fromARGB(255, 4, 59, 155)),
            ),
            const Text(
              'in your browser',
              style: TextStyle(fontSize: 18),
            ),
            const Text(
              'Sign up for a FREE account and then sign in.',
              style: TextStyle(fontSize: 18),
            ),
            const Text(
              'Click on the "Account" button in the upper right corner.',
              style: TextStyle(fontSize: 18),
            ),
            Image.asset('assets/images/account_button.png'),
            const SizedBox(height: 10),
            const Text(
              'You will see the key assigned to you. Click on "Copy" below the key.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Image.asset('assets/images/api_key.png'),
            const SizedBox(height: 15),
            const Text(
              'Go to the next page for hints on pasting the key.',
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
