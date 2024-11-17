import 'dart:async';

import 'package:elective/src/bloc/session/timer_event.dart';
import 'package:elective/src/bloc/session/timer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _timer;
  late DateTime _targetEnd;
  late DateTime _targetStart;
  bool canLogin = false;
  TimerBloc() : super(TimerInitialState()) {
    on<TimerStartEvent>((event, emit) async {
      _targetStart = event.targetStart;
      _targetEnd = event.targetEnd;

      if (DateTime.now().isBefore(_targetStart)) {
        emit(TimerBeforeStartState());
      } else if (DateTime.now().isAfter(_targetEnd)) {
        emit(TimerExpiredState());
      } else {
        canLogin = true;
        emit(
          TimerRunningState(
              timeRemaining: _targetEnd.difference(DateTime.now()),
              canLogin: canLogin),
        );
        _startTimer();
      }
    });

    on<TimerTickEvent>((event, emit) async {
      final now = DateTime.now();
      if (now.isAfter(_targetEnd)) {
        add(TimerExpiredEvent());
      } else {
        emit(TimerRunningState(timeRemaining: _targetEnd.difference(now),canLogin: true));
      }
    });

    on<TimerExpiredEvent>((event, emit) async {
      _timer?.cancel();
      emit(TimerExpiredState());
    });
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TimerTickEvent());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
