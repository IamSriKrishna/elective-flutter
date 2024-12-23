import 'dart:ui';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:elective/src/app/app_family.dart';
import 'package:elective/src/bloc/enroll/enroll_bloc.dart';
import 'package:elective/src/bloc/enroll/enroll_event.dart';
import 'package:elective/src/bloc/enroll/enroll_state.dart';
import 'package:elective/src/bloc/session/timer_bloc.dart';
import 'package:elective/src/bloc/session/timer_state.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:elective/src/widgets/seat_layout_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class SeatLayout extends StatefulWidget {
  final String title;
  final int totalSeat;
  final int availableSeat;
  final int subjectId;
  final String subjects;
  const SeatLayout(
      {super.key,
      required this.subjectId,
      required this.title,
      required this.totalSeat,
      required this.availableSeat,
      required this.subjects});

  @override
  // ignore: library_private_types_in_public_api
  _SeatLayoutState createState() => _SeatLayoutState();
}

class _SeatLayoutState extends State<SeatLayout> {
  late List<int> seatStatus;

  DateTime now = DateTime.now();
  late List<int> availableIndices;
  bool _isload = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Components.instuctor(
          context,
          widget.title == widget.subjects
              ? "You have successfully selected this elective."
              : widget.subjects == "none"
                  ? "click any seat to confirm your elective Course"
                  : "You have already selected another elective.");
    });

    int reservedSeats = widget.totalSeat - widget.availableSeat;

    seatStatus = List.generate(widget.totalSeat, (index) => 0);

    if (reservedSeats > 0) {
      final random = Random();
      availableIndices = List.generate(widget.totalSeat, (index) => index);
      availableIndices.shuffle(random);

      // Assign reserved seats (2) randomly
      for (int i = 0; i < reservedSeats; i++) {
        seatStatus[availableIndices[i]] = 2;
      }
    }
  }

  void _onSeatTap(int index) {
    if (widget.subjects == "none") {
      setState(() {
        // Count the number of selected seats
        int selectedSeats = seatStatus.where((status) => status == 1).length;

        // Limit the selection to 3 seats
        if (selectedSeats < 1) {
          if (seatStatus[index] == 0) {
            seatStatus[index] = 1; // Select the seat
          } else if (seatStatus[index] == 1) {
            seatStatus[index] = 0; // Deselect the seat
          }
        } else {
          Components.oneSeat(context);

          //Components.limitSeats(context); // Show message when max seats are reached
        }
      });
    } else {
      Components.noMoreSeat(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    int columns = 14;
    int rows = (widget.totalSeat / 12).ceil();
    int centerGapStart = columns ~/ 2 - 1;
    int centerGapEnd = centerGapStart + 2;

    return BlocListener<EnrollBloc, EnrollState>(
      listener: (context, state) {
        if (state is EnrollSuccess) {
          context.goNamed("home");
        }
        if (state is EnrollLoading) {
          setState(() {
            _isload = true;
          });
        }
        if (state is EnrollError) {
          setState(() {
            _isload = false;
          });
        }
        if (state is EnrollSuccess) {
          setState(() {
            _isload = false;
          });
        }
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return BlocBuilder<TimerBloc, TimerState>(
            builder: (context, timerState) {
              bool canLogin = false;
              bool expery = false;

              int hours = 0, minutes = 0, seconds = 0;
              if (timerState is TimerExpiredState) {
                expery = true;
              }
              if (timerState is TimerRunningState) {
                canLogin = timerState.canLogin;
                Duration remainingTime = timerState.timeRemaining;
                hours = remainingTime.inHours;
                minutes = remainingTime.inMinutes % 60;
                seconds = remainingTime.inSeconds % 60;
              }
              return Stack(
                children: [
                  Scaffold(
                    body: CustomScrollView(
                      slivers: [
                        SeatLayoutWidget.appBar(
                            widget.title, constraints, context,
                            onPressed: widget.subjects != "none"
                                ? null
                                : () {
                                    if (canLogin && !expery) {
                                      Components.confirmBook(context,
                                          onPressed: () {
                                        context.read<EnrollBloc>().add(
                                            SelectSubjectEvent(
                                                subjectId: widget.subjectId));

                                        Navigator.pop(context);
                                      });
                                    } else if (expery) {
                                      Components.sessionExpired(context);
                                    } else {
                                      Components.waitTillNov(context);
                                    }
                                  }),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                if (timerState is TimerBeforeStartState)
                                  if (now.day == 20 && now.month == 11)
                                    Components.openSansText(
                                      text:
                                          'Please wait till, 7:00 PM to log in.',
                                      textAlign: TextAlign.center,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    )
                                  else
                                    Components.openSansText(
                                      text:
                                          "Please wait until 20th November 2024, 7:00 PM to select your elective.",
                                      textAlign: TextAlign.center,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                if (timerState is TimerRunningState)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Components.openSansText(
                                        text: "Time remaining:",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      AnimatedFlipCounter(
                                        value: hours.toDouble(),
                                        duration:
                                            const Duration(milliseconds: 500),
                                        textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: AppFamily.bold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        wholeDigits: 2,
                                        fractionDigits: 0,
                                      ),
                                      const Text(
                                        ":",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: AppFamily.bold,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      AnimatedFlipCounter(
                                        value: minutes.toDouble(),
                                        duration:
                                            const Duration(milliseconds: 500),
                                        textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: AppFamily.bold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        wholeDigits: 2,
                                        fractionDigits: 0,
                                      ),
                                      const Text(
                                        ":",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: AppFamily.bold,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      AnimatedFlipCounter(
                                        value: seconds.toDouble(),
                                        duration:
                                            const Duration(milliseconds: 500),
                                        textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: AppFamily.bold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        wholeDigits: 2,
                                        fractionDigits: 0,
                                      ),
                                    ],
                                  ),
                                if (timerState is TimerExpiredState)
                                  Components.openSansText(
                                    text: 'Session has expired.',
                                    textAlign: TextAlign.center,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SeatLayoutWidget.seatAvailable(),
                        SeatLayoutWidget.screen(),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, row) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Container(
                                          width: 30,
                                          alignment: Alignment.centerLeft,
                                          child: Components.openSansText(
                                            text: String.fromCharCode(65 + row),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: columns,
                                            mainAxisSpacing: 16,
                                            crossAxisSpacing: 16,
                                          ),
                                          itemCount: columns,
                                          itemBuilder: (context, column) {
                                            if (column >= centerGapStart &&
                                                column < centerGapEnd) {
                                              return const SizedBox
                                                  .shrink(); // Gap between center seats
                                            }

                                            int seatIndex = row * 12 +
                                                (column >= centerGapEnd
                                                    ? column - 2
                                                    : column);

                                            if (seatIndex >=
                                                seatStatus.length) {
                                              return const SizedBox.shrink();
                                            }

                                            return Tooltip(
                                              message: seatStatus[seatIndex] ==
                                                      0
                                                  ? "Available Seat"
                                                  : seatStatus[seatIndex] == 2
                                                      ? "Reserved By Someone you might know"
                                                      : "Seat Reserved by you",
                                              child: InkWell(
                                                onTap: seatStatus[seatIndex] !=
                                                        2
                                                    ? () =>
                                                        _onSeatTap(seatIndex)
                                                    : null,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: seatStatus[
                                                                seatIndex] ==
                                                            0
                                                        ? Colors.grey
                                                            .withOpacity(0.2)
                                                        : seatStatus[
                                                                    seatIndex] ==
                                                                1
                                                            ? Colors.green
                                                            : Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount: rows,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth * 0.4,
                                vertical: constraints.maxHeight * 0.01),
                            child: ElevatedButton(
                              onPressed: widget.subjects != "none"
                                  ? null
                                  : () {
                                      if (canLogin && !expery) {
                                        Components.confirmBook(context,
                                            onPressed: () {
                                          context.read<EnrollBloc>().add(
                                              SelectSubjectEvent(
                                                  subjectId: widget.subjectId));

                                          Navigator.pop(context);
                                        });
                                      } else if (expery) {
                                        Components.sessionExpired(context);
                                      } else {
                                        Components.waitTillNov(context);
                                      }
                                    },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Confirm "),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Blurring background when loading
                  if (_isload)
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 5.0, sigmaY: 5.0), // Adjust blur level
                        child: Container(
                          color: Colors.black
                              .withOpacity(0), // Transparent overlay
                        ),
                      ),
                    ),

                  // Display the loading spinner
                  if (_isload)
                    const Center(
                        child: SpinKitFadingCircle(
                            color: Colors.black, size: 50.0)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
