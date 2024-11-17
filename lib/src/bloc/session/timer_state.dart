import 'package:equatable/equatable.dart';

class TimerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TimerInitialState extends TimerState {}

// ignore: must_be_immutable
class TimerRunningState extends TimerState {
  final Duration timeRemaining;
  bool canLogin;
  TimerRunningState({required this.timeRemaining,required this.canLogin});

  @override
  bool operator ==(Object other) {
    return other is TimerRunningState &&
        timeRemaining.inSeconds == other.timeRemaining.inSeconds;
  }

  @override
  int get hashCode => timeRemaining.inSeconds.hashCode;
}

class TimerExpiredState extends TimerState {}

class TimerBeforeStartState extends TimerState {}
