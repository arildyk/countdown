import 'package:countdown/config/theme.dart';
import 'package:countdown/pages/countdown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(const Countdown());
}

class Countdown extends StatelessWidget {
  const Countdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown',
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      home: const CountdownPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
