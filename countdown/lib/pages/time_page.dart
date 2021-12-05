import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: screen.size.height - screen.padding.top,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _daysController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _hoursController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _minutesController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _secondsController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                onSubmitted: (_) => _submitData(),
              ),
              ElevatedButton(
                onPressed: () {
                  CountdownPage.countdownStarted = true;
                  _submitData;
                  Navigator.pushNamed(context, CountdownPage.routeName);
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
