import 'package:flutter/material.dart';

class HelpScreen2 extends StatelessWidget {
  const HelpScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 6,
        children: [
          const Text(
            'Go to https://visualcrossing.com in your browser.',
            style: TextStyle(fontSize: 18),
          ),
          const Text(
            'Sign up for an account and then sign in.',
            style: TextStyle(fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:
                Image.asset('assets/images/hs21.png', width: 600, height: 500),
          ),
        ],
      ),
    );
  }
}
