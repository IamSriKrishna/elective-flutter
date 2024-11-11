import 'package:equatable/equatable.dart';

class EnrollEvent extends Equatable {
  const EnrollEvent();

  @override
  List<Object?> get props => [];
}

class SelectSubjectEvent extends EnrollEvent {
  final int subjectId;
  const SelectSubjectEvent({required this.subjectId});

  @override
  List<Object?> get props => [subjectId];
}
