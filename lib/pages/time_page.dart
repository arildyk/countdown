import 'dart:io';

import 'package:countdown/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'countdown_page.dart';

class TimePage extends StatefulWidget {
  const TimePage({Key? key}) : super(key: key);

  static final _daysController = TextEditingController();
  static final _hoursController = TextEditingController();
  static final _minutesController = TextEditingController();
  static final _secondsController = TextEditingController();

  static void getDataFromCountdown() {
    _daysController.text = CountdownPage.currentDays.toString();
    _hoursController.text = CountdownPage.currentHours.toString();
    _minutesController.text = CountdownPage.currentMinutes.toString();
    _secondsController.text = CountdownPage.currentSeconds.toString();
  }

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  void _submitData() {
    if (TimePage._daysController.text.isEmpty) {
      TimePage._daysController.text = "0";
    }

    if (TimePage._hoursController.text.isEmpty) {
      TimePage._hoursController.text = "0";
    }

    if (TimePage._minutesController.text.isEmpty) {
      TimePage._minutesController.text = "0";
    }

    if (TimePage._secondsController.text.isEmpty) {
      TimePage._secondsController.text = "0";
    }

    final enteredDays = int.tryParse(TimePage._daysController.text);
    final enteredHours = int.tryParse(TimePage._hoursController.text);
    final enteredMinutes = int.tryParse(TimePage._minutesController.text);
    final enteredSeconds = int.tryParse(TimePage._secondsController.text);

    CountdownPage.setCountdownTime(
      enteredDays!,
      enteredHours!,
      enteredMinutes!,
      enteredSeconds!,
    );
  }

  TextField buildTextField(String timeName, TextEditingController controller) {
    return TextField(
      style: const TextStyle(fontSize: 30),
      decoration: InputDecoration(
        label: Text(timeName),
      ),
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onSubmitted: (_) => _submitData(),
    );
  }

  Scaffold buildTimePage(BuildContext context, bool bottom) {
    final screen = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: bottom,
        child: Container(
          height: screen.size.height - screen.padding.top,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Countdown',
                style: TextStyle(fontSize: 30),
              ),
              buildTextField('Days', TimePage._daysController),
              buildTextField('Hours', TimePage._hoursController),
              buildTextField('Minutes', TimePage._minutesController),
              buildTextField('Seconds', TimePage._secondsController),
              Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: IconButton(
                  icon: const Icon(Icons.check_circle),
                  color: turquoise,
                  onPressed: () {
                    _submitData();
                    //CountdownPage.countdownStarted = true;
                    Navigator.pushNamed(context, CountdownPage.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle _statusBarLight = SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Theme.of(context).primaryColor,
      systemNavigationBarColor: Theme.of(context).primaryColor,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Theme.of(context).primaryColor,
    );

    SystemUiOverlayStyle _statusBarDark = SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Theme.of(context).primaryColor,
      systemNavigationBarColor: Theme.of(context).primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Theme.of(context).primaryColor,
    );

    return Platform.isIOS
        ? buildTimePage(context, false)
        : AnnotatedRegion<SystemUiOverlayStyle>(
            value: Theme.of(context).brightness == Brightness.light
                ? _statusBarLight
                : _statusBarDark,
            child: buildTimePage(context, true),
          );
  }
}
