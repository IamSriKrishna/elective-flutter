import 'dart:async';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:elective/src/app/app_family.dart';
import 'package:elective/src/bloc/student/student_bloc.dart';
import 'package:elective/src/bloc/student/student_state.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeWelcomeUser extends StatefulWidget {
  final BoxConstraints constraints;
  const HomeWelcomeUser({super.key, required this.constraints});

  @override
  State<HomeWelcomeUser> createState() => _HomeWelcomeUserState();
}

class _HomeWelcomeUserState extends State<HomeWelcomeUser> {
  late int hours;
  late int minutes;
  late int seconds;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _initializeTime();
    _startTimer();
  }

  void _initializeTime() {
    final now = DateTime.now();
    hours = now.hour;
    minutes = now.minute;
    seconds = now.second;
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        final now = DateTime.now();
        hours = now.hour;
        minutes = now.minute;
        seconds = now.second;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Clean up the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.constraints.maxWidth;

    double fontSize = width > 600 ? 24 : 16;
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        return SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.constraints.maxWidth * 0.1,
            vertical: widget.constraints.maxHeight * 0.01,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state is GetStudent)
                      Components.openSansText(
                        text: "Hello ${state.student.data.name} 😊,",
                        fontFamily: AppFamily.bold,
                        fontSize: fontSize,
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedFlipCounter(
                      value: hours.toDouble(),
                      duration: const Duration(milliseconds: 500),
                      textStyle: TextStyle(
                        fontSize: fontSize,
                        fontFamily: AppFamily.bold,
                        fontWeight: FontWeight.bold,
                      ),
                      wholeDigits: 2,
                      fractionDigits: 0,
                    ),
                    Text(
                      ":",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: AppFamily.bold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedFlipCounter(
                      value: minutes.toDouble(),
                      duration: const Duration(milliseconds: 500),
                      textStyle: TextStyle(
                        fontSize: fontSize,
                        fontFamily: AppFamily.bold,
                        fontWeight: FontWeight.bold,
                      ),
                      wholeDigits: 2,
                      fractionDigits: 0,
                    ),
                    Text(
                      ":",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: AppFamily.bold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedFlipCounter(
                      value: seconds.toDouble(),
                      duration: const Duration(milliseconds: 500),
                      textStyle: TextStyle(
                        fontSize: fontSize,
                        fontFamily: AppFamily.bold,
                        fontWeight: FontWeight.bold,
                      ),
                      wholeDigits: 2,
                      fractionDigits: 0,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (hours >= 12)
                      Components.openSansText(
                          text: "PM",
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFamily.bold)
                    else
                      Components.openSansText(
                          text: "AM",
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFamily.bold)
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
