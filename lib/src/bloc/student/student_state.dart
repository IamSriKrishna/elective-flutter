import 'package:elective/src/models/student.dart';
import 'package:equatable/equatable.dart';

class StudentState extends Equatable {
  const StudentState();
  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentSuccess extends StudentState {
  final String message;
  const StudentSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

class GetStudent extends StudentState {
  final Student student;
  const GetStudent({required this.student});

  @override
  List<Object?> get props => [student];
}

class StudentError extends StudentState {
  final Object error;
  const StudentError({required this.error});
  @override
  List<Object?> get props => [error];
}
