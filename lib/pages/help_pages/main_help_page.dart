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

  int _currentPage = 0;

  void _gotoPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _gotoNextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Help Session"),
          backgroundColor: Colors.lightBlue,
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: const [
                  HelpScreen1(),
                  HelpScreen2(),
                  HelpScreen3(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                      visible: _currentPage > 0,
                      child: InkWell(
                        onTap: () => _gotoPreviousPage(),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_back),
                            Text(
                              'Previous Page',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _currentPage < 2,
                    child: InkWell(
                      onTap: () => _gotoNextPage(),
                      child: const Row(
                        children: [
                          Text(
                            'Next Page',
                            style: TextStyle(fontSize: 10),
                          ),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
