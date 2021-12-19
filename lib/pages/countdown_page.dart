import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:countdown/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

import 'time_page.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);
  static const routeName = '/countdown-page';

  static int _days = 0;
  static int _hours = 0;
  static int _minutes = 0;
  static int _seconds = 0;

  static int _currentDays = 0;
  static int _currentHours = 0;
  static int _currentMinutes = 0;
  static int _currentSeconds = 0;

  static int get currentDays {
    return _currentDays;
  }

  static int get currentHours {
    return _currentHours;
  }

  static int get currentMinutes {
    return _currentMinutes;
  }

  static int get currentSeconds {
    return _currentSeconds;
  }

  static void setCountdownTime(int enteredDays, int enteredHours,
      int enteredMinutes, int enteredSeconds) {
    _days = enteredDays;
    _hours = enteredHours;
    _minutes = enteredMinutes;
    _seconds = enteredSeconds;
  }

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  StreamSubscription<CountdownTimer> streamSub = CountdownTimer(
    Duration(
      days: CountdownPage._days,
      hours: CountdownPage._hours,
      minutes: CountdownPage._minutes,
      seconds: CountdownPage._seconds + 1,
    ),
    const Duration(milliseconds: 1),
  ).listen(null);

  late ConfettiController _confettiController;

  @override
  void initState() {
    if (mounted) {
      startCountdown();
    }

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
    if (mounted) {
      streamSub.pause();
    }
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
    );
  }

  void startCountdown() {
    streamSub.onData((duration) {
      setState(() {
        CountdownPage._currentDays = duration.remaining.inDays % 30;
        CountdownPage._currentHours = duration.remaining.inHours % 24;
        CountdownPage._currentMinutes = duration.remaining.inMinutes % 60;
        CountdownPage._currentSeconds = duration.remaining.inSeconds % 60;
      });
    });

    streamSub.onDone(() {
      playSoundAndConfetti();
      streamSub.cancel();
    });
  }

  Flexible buildCountdownTimerBar(double percentage, LinearGradient gradient) {
    return Flexible(
      child: FractionallySizedBox(
        widthFactor: percentage,
        child: Container(
          height: 10,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  double timerBarSize(int currentTime, int factor) {
    return currentTime / factor;
  }

  void playSoundAndConfetti() async {
    _confettiController.play();
    AudioPlayer audioPlayer = AudioPlayer();
    int res = await audioPlayer.play(
      "https://cdn.pixabay.com/download/audio/2021/08/04/audio_0625c1539c.mp3?filename=success-1-6297.mp3",
    );
  }

  Scaffold buildCountdownPage(bool bottom) {
    final screen = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: bottom,
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
                  const Text('D', style: TextStyle(fontSize: 36)),
                ],
              ),
              buildCountdownTimerBar(
                timerBarSize(CountdownPage._currentDays, 30),
                gradient,
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
              buildCountdownTimerBar(
                timerBarSize(CountdownPage._currentHours, 24),
                gradient,
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
              buildCountdownTimerBar(
                timerBarSize(CountdownPage._currentMinutes, 60),
                gradient,
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
                  const Spacer(),
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : darkBackgroundColor,
                    onPressed: () {
                      TimePage.getDataFromCountdown();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              buildCountdownTimerBar(
                timerBarSize(CountdownPage._currentSeconds, 60),
                gradient,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? buildCountdownPage(false)
        : buildCountdownPage(true);
  }
}
