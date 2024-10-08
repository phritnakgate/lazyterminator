import 'dart:async';

import 'package:flutter/material.dart';

class FocusModeWidget extends StatefulWidget {
  const FocusModeWidget({super.key});

  @override
  State<FocusModeWidget> createState() => _FocusModeWidgetState();
}

class _FocusModeWidgetState extends State<FocusModeWidget> {
  int timerval = 30;

  bool isTimerRunning = false;
  String pomodoroStatus = "No Status";
  Map<String, Color> pomodoroStatusColor = {
    "No Status": const Color.fromRGBO(230, 248, 246, 1),
    "Break": const Color.fromRGBO(255, 204, 204, 1),
    "Focus": const Color.fromRGBO(241, 247, 181, 1),
  };

  //Timer Function
  Timer? timer;
  Duration? d;
  late int breaktime;
  late int endbreaktime;
  void startTimer(int cnt) {
    d = Duration(minutes: cnt);
    timer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() {
      timer!.cancel();
      isTimerRunning = false;
      pomodoroStatus = "No Status";
      breaktime = timerval * 60 - 1500;
      endbreaktime = timerval * 60 - 1800;
    });
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    breaktime = 30;
    endbreaktime = timerval * 60 - 1800;
    setState(() {
      final seconds = d!.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        stopTimer();
      } else if (seconds == breaktime) {
        pomodoroStatus = "Break";
        breaktime -= 1800;
        d = Duration(seconds: seconds);
      } else if (seconds == endbreaktime) {
        pomodoroStatus = "Focus";
        endbreaktime -= 1800;
        d = Duration(seconds: seconds);
      } else {
        d = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final secondDisplay = strDigits(d?.inSeconds.remainder(60) ?? 0);
    final minutesDisplay = strDigits(d?.inMinutes.remainder(120) ?? 0);

    return Container(
      color: pomodoroStatusColor[pomodoroStatus],
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Pomodoro Focus Mode",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          const SizedBox(height: 10),
          Text(pomodoroStatus,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          const SizedBox(height: 10),
          isTimerRunning
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(minutesDisplay,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    const Text(" : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    Text(secondDisplay,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(timerval.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    const Text(" : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    const Text("00",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                  ],
                ),
          const SizedBox(height: 10),
          !isTimerRunning
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Select Timer Duration :",
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //FOR DEBUG ONLY

                        const Text("1", style: TextStyle(fontSize: 16)),
                        Radio<int>(
                            value: 1,
                            groupValue: timerval,
                            onChanged: (value) {
                              setState(() {
                                timerval = value!;
                              });
                            }),

                        //USE THIS
                        const Text("30", style: TextStyle(fontSize: 16)),
                        Radio<int>(
                            value: 30,
                            groupValue: timerval,
                            onChanged: (value) {
                              setState(() {
                                timerval = value!;
                              });
                            }),
                        const Text("60", style: TextStyle(fontSize: 16)),
                        Radio<int>(
                            value: 60,
                            groupValue: timerval,
                            onChanged: (value) {
                              setState(() {
                                timerval = value!;
                              });
                            }),
                        const Text("90", style: TextStyle(fontSize: 16)),
                        Radio<int>(
                            value: 90,
                            groupValue: timerval,
                            onChanged: (value) {
                              setState(() {
                                timerval = value!;
                              });
                            }),
                        const Text("120", style: TextStyle(fontSize: 16)),
                        Radio<int>(
                            value: 120,
                            groupValue: timerval,
                            onChanged: (value) {
                              setState(() {
                                timerval = value!;
                              });
                            }),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isTimerRunning = true;
                            pomodoroStatus = "Focus";
                            startTimer(timerval);
                          });
                        },
                        child: const Text("Start")),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      stopTimer();
                      pomodoroStatus = "No Status";
                    });
                  },
                  child: const Text("Stop")),
        ]),
      ),
    );
  }
}
