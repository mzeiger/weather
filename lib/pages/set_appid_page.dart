import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/helpers/appid_singleton.dart';
import 'package:weather/pages/help_pages/main_help_page.dart';
import 'package:weather/pages/home_page.dart';

class SetAppIdPage extends StatefulWidget {
  const SetAppIdPage({super.key});

  @override
  State<SetAppIdPage> createState() => _SetAppIdPageState();
}

class _SetAppIdPageState extends State<SetAppIdPage> {
  final TextEditingController _controller = TextEditingController();

  static const String txt1 =
      'If you have reached this screen you must get an "key" from VisualCrossing';
  static const String txt2 =
      'before you can use this app.\n\nTo get the "key" go to\n              http://visualcrossing.com\n';
  static const String txt3 =
      'create an account, and generate the key.\n\nYou may create a FREE account and then';
  static const String txt4 =
      'generate the key. Copy it and enter it into the textbox below.\n\nThe above only needs to be done once.';
  static const String txt6 =
      'For more detailed instructions on getting a key click on the button below:';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            spacing: 10,
            children: [
              const Text(
                'Instructions',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 25),
              ),
              const Text('$txt1 $txt2 $txt3 $txt4',
                  style: TextStyle(fontSize: 14)),
              const Text(
                txt6,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HelpSession(),
                    )),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 154, 204, 216)),
                child: const Text('Get Detailed Instructions'),
              ),
              TextField(
                controller: _controller,
                autocorrect: false,
                readOnly: true,
                keyboardType: TextInputType.none,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 232, 245, 220),
                  contentPadding: const EdgeInsets.all(4),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => _controller.text = "",
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => pasteText(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 154, 216, 201)),
                child: const Text('Paste Key'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    saveAppId(_controller.text);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 154, 216, 201)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Save Key'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveAppId(appIdText) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appId', appIdText);
    AppIdSingleton.instance.setAppId(appIdText);
  }

  Future<void> pasteText() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    if (data != null && data.text!.isNotEmpty) {
      _controller.text = data.text!;
    }
  }

  TextStyle textStyle() {
    return const TextStyle(fontSize: 14);
  }
}
