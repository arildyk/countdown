import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:countdown/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);
  static const routeName = '/countdown-page';

  static int days = 0;
  static int hours = 0;
  static int minutes = 0;
  static int seconds = 0;

  static bool countdownStarted = false;

  static int _currentDays = 0;
  static int _currentHours = 0;
  static int _currentMinutes = 0;
  static int _currentSeconds = 0;

  static void setCountdownTime(int enteredDays, int enteredHours,
      int enteredMinutes, int enteredSeconds) {
    days = enteredDays;
    hours = enteredHours;
    minutes = enteredMinutes;
    seconds = enteredSeconds;
  }

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  StreamSubscription<CountdownTimer> streamSub = CountdownTimer(
    Duration(
      days: CountdownPage.days,
      hours: CountdownPage.hours,
      minutes: CountdownPage.minutes,
      seconds: CountdownPage.seconds + 1,
    ),
    const Duration(milliseconds: 1),
  ).listen(null);

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    setState(() {
      initController();
    });
  }

  void initController() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  ConfettiWidget buildConfetti(ConfettiController controller) {
    return ConfettiWidget(
      confettiController: controller,
      blastDirectionality: BlastDirectionality.explosive,
      particleDrag: 0.05,
      emissionFrequency: 0.1,
      numberOfParticles: 25,
      gravity: 0.05,
      shouldLoop: false,
      // manually specify the colors to be used
    );
  }

  void startCountdown() {
    streamSub.onData((duration) {
      setState(() {
        CountdownPage._currentDays = duration.remaining.inDays;
        CountdownPage._currentHours = duration.remaining.inHours % 24;
        CountdownPage._currentMinutes = duration.remaining.inMinutes % 60;
        CountdownPage._currentSeconds = duration.remaining.inSeconds % 60;
      });
    });

    streamSub.onDone(() {
      print("done");
      _confettiController.play();
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
    if (CountdownPage.countdownStarted) {
      startCountdown();
      CountdownPage.countdownStarted = false;
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: (screen.size.height - screen.padding.top),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildConfetti(_confettiController),
              Row(
                children: [
                  Text(
                    CountdownPage._currentDays < 10
                        ? '0${CountdownPage._currentDays}'
                        : '${CountdownPage._currentDays}',
                    style: const TextStyle(fontSize: 108),
                  ),
                  const Text(
                    'D',
                    style: TextStyle(fontSize: 36),
                  ),
                ],
              ),
              Flexible(
                child: buildCountdownTimerBar(
                  CountdownPage._currentDays / 30,
                  gradient,
                ),
              ),
              Row(
                children: [
                  Text(
                    CountdownPage._currentHours < 10
                        ? '0${CountdownPage._currentHours}'
                        : '${CountdownPage._currentHours}',
                    style: const TextStyle(fontSize: 108),
                  ),
                  const Text('H', style: TextStyle(fontSize: 36)),
                ],
              ),
              Flexible(
                child: buildCountdownTimerBar(
                  CountdownPage._currentHours / 24,
                  gradient,
                ),
              ),
              Row(
                children: [
                  Text(
                    CountdownPage._currentMinutes < 10
                        ? '0${CountdownPage._currentMinutes}'
                        : '${CountdownPage._currentMinutes}',
                    style: const TextStyle(fontSize: 108),
                  ),
                  const Text('M', style: TextStyle(fontSize: 36)),
                ],
              ),
              Flexible(
                child: buildCountdownTimerBar(
                  CountdownPage._currentMinutes / 60,
                  gradient,
                ),
              ),
              Row(
                children: [
                  Text(
                    CountdownPage._currentSeconds < 10
                        ? '0${CountdownPage._currentSeconds}'
                        : '${CountdownPage._currentSeconds}',
                    style: const TextStyle(fontSize: 108),
                  ),
                  const Text('S', style: TextStyle(fontSize: 36)),
                ],
              ),
              Flexible(
                child: buildCountdownTimerBar(
                  CountdownPage._currentSeconds / 60,
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
