import 'dart:io';

import 'package:countdown/config/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'countdown_page.dart';

class TimePage extends StatefulWidget {
  const TimePage({Key? key}) : super(key: key);

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  final _daysController = TextEditingController();
  final _hoursController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();

  void _submitData() {
    if (_daysController.text.isEmpty) {
      _daysController.text = "0";
    }

    if (_hoursController.text.isEmpty) {
      _hoursController.text = "0";
    }

    if (_minutesController.text.isEmpty) {
      _minutesController.text = "0";
    }

    if (_secondsController.text.isEmpty) {
      _secondsController.text = "0";
    }

    final enteredDays = int.tryParse(_daysController.text);
    final enteredHours = int.tryParse(_hoursController.text);
    final enteredMinutes = int.tryParse(_minutesController.text);
    final enteredSeconds = int.tryParse(_secondsController.text);

    CountdownPage.setCountdownTime(
      enteredDays!,
      enteredHours!,
      enteredMinutes!,
      enteredSeconds!,
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
              TextField(
                style: const TextStyle(fontSize: 30),
                decoration: const InputDecoration(
                  label: Text('Days'),
                ),
                controller: _daysController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                style: const TextStyle(fontSize: 30),
                decoration: const InputDecoration(
                  label: Text('Hours'),
                ),
                controller: _hoursController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                style: const TextStyle(fontSize: 30),
                decoration: const InputDecoration(
                  label: Text('Minutes'),
                ),
                controller: _minutesController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                style: const TextStyle(fontSize: 30),
                decoration: const InputDecoration(
                  label: Text('Seconds'),
                ),
                controller: _secondsController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                onSubmitted: (_) => _submitData(),
              ),
              Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: IconButton(
                  icon: const Icon(Icons.check_circle),
                  color: turquoise,
                  onPressed: () {
                    _submitData();
                    CountdownPage.countdownStarted = true;
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
            child: buildTimePage(context, true));
  }
}
