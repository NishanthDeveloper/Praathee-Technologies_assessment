import 'package:flutter/material.dart';
import 'dart:async'; // For Timer

class CountdownTimer extends StatefulWidget {
  final DateTime targetDate; // Add targetDate as an input parameter

  CountdownTimer({required this.targetDate});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final target = widget.targetDate;
    final difference = target.difference(now);

    setState(() {
      _remainingTime = difference.isNegative ? Duration.zero : difference;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    return Row(
      children: [
        TimerBox(label: days.toString().padLeft(2, '0'), subtitle: 'Days'),
        TimerBox(label: hours.toString().padLeft(2, '0'), subtitle: 'Hours'),
        TimerBox(label: minutes.toString().padLeft(2, '0'), subtitle: 'Minutes'),
        TimerBox(label: seconds.toString().padLeft(2, '0'), subtitle: 'Seconds'),
      ],
    );
  }
}

class TimerBox extends StatelessWidget {
  final String label;
  final String subtitle;

  TimerBox({required this.label, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
