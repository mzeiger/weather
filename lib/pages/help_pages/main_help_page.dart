import 'package:flutter/material.dart';
import 'package:weather/pages/help_pages/help_screen_1.dart';
import 'package:weather/pages/help_pages/help_screen_2.dart';
import 'package:weather/pages/help_pages/help_screen_3.dart';

class HelpSession extends StatefulWidget {
  const HelpSession({super.key});

  @override
  State<HelpSession> createState() => _HelpSessionState();
}

class _HelpSessionState extends State<HelpSession> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help Session")),
      body: PageView(
        controller: _pageController,
        children: const [
          HelpScreen1(),
          HelpScreen2(),
          HelpScreen3(),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: const Icon(Icons.arrow_back),
          ),
          FloatingActionButton(
            onPressed: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

// class HelpScreen1 extends StatelessWidget {
//   const HelpScreen1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child:
//             Hero(tag: 'hero-1', child: Text("This is the first help screen.")),
//       ),
//     );
//   }
// }

// class HelpScreen2 extends StatelessWidget {
//   const HelpScreen2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text("This is the second help screen."),
//       ),
//     );
//   }
// }

// class HelpScreen3 extends StatelessWidget {
//   const HelpScreen3({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("This is the last help screen."),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               },
//               child: const Text("Done"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
