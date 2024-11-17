import 'package:equatable/equatable.dart';

class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

class TimerStartEvent extends TimerEvent {
  final DateTime targetStart;
  final DateTime targetEnd;

  const TimerStartEvent({required this.targetStart, required this.targetEnd});

  @override
  List<Object?> get props => [targetStart, targetEnd];
}

class TimerTickEvent extends TimerEvent {}

class TimerExpiredEvent extends TimerEvent {}
