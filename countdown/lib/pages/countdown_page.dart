import 'dart:async';

import 'package:countdown/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  static const int _days = 2;
  static const int _hours = 2;
  static const int _minutes = 2;
  static const int _seconds = 3;
  int _currentDays = 0;
  int _currentHours = 0;
  int _currentMinutes = 0;
  int _currentSeconds = 0;
  final _givenDuration = const Duration(
    days: _days,
    hours: _hours,
    minutes: _minutes,
    seconds: _seconds + 1,
  );

  void startCountdown() {
    CountdownTimer countdownTimer = CountdownTimer(
      _givenDuration,
      const Duration(milliseconds: 1),
    );

    StreamSubscription<CountdownTimer> streamSub = countdownTimer.listen(null);

    streamSub.onData((duration) {
      setState(() {
        _currentDays = duration.remaining.inDays;
        _currentHours = duration.remaining.inHours % 24;
        _currentMinutes = duration.remaining.inMinutes % 60;
        _currentSeconds = duration.remaining.inSeconds % 60;
      });
    });

    streamSub.onDone(() {
      print("done");
      streamSub.cancel();
    });
  }

  FractionallySizedBox buildCountdownTimerBar(
      double percentage, LinearGradient gradient) {
    return FractionallySizedBox(
      widthFactor: percentage,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: (screen.size.height - screen.padding.top),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$_currentDays',
                    style: const TextStyle(fontSize: 56),
                    textAlign: TextAlign.end,
                  ),
                  const Text('D'),
                ],
              ),
              Flexible(
                child: buildCountdownTimerBar(
                  _currentDays / _days,
                  gradient,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$_currentHours',
                    style: const TextStyle(fontSize: 56),
                  ),
                  const Text('H'),
                ],
              ),
              Flexible(
                child: buildCountdownTimerBar(
                  _currentHours / 24,
                  gradient,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$_currentMinutes',
                    style: const TextStyle(fontSize: 56),
                  ),
                  const Text('M'),
                ],
              ),
              Flexible(
                child: buildCountdownTimerBar(
                  _currentMinutes / 60,
                  gradient,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$_currentSeconds',
                    style: const TextStyle(fontSize: 56),
                  ),
                  const Text('S'),
                ],
              ),
              Flexible(
                child: buildCountdownTimerBar(
                  _currentSeconds / 60,
                  gradient,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_forward_ios),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: startCountdown,
                    label: const Text(''),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
