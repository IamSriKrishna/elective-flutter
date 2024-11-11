import 'package:elective/src/models/subjects.dart';
import 'package:equatable/equatable.dart';

class SubjectState extends Equatable {
  const SubjectState();
  @override
  List<Object?> get props => [];
}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectSuccess extends SubjectState {
  final String message;
  const SubjectSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

class GetSubject extends SubjectState {
  final Subjects subjects;
  const GetSubject({required this.subjects});

  @override
  List<Object?> get props => [subjects];
}

class SubjectError extends SubjectState {
  final Object error;
  const SubjectError({required this.error});
  @override
  List<Object?> get props => [error];
}
