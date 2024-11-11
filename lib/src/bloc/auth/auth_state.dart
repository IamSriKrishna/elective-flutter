import 'package:elective/src/models/student.dart';
import 'package:equatable/equatable.dart';

enum AuthStateStatus { empty, initial, loading, changed, success, failure }

class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final AuthStateStatus status;
  const AuthSuccess({required this.message,required this.status});
  @override
  List<Object?> get props => [message];
}

class AuthGetStudent extends AuthState {
  final Student student;
  const AuthGetStudent({required this.student});

  @override
  List<Object?> get props => [student];
}

class AuthError extends AuthState {
  final Object error;
  const AuthError({required this.error});
  @override
  List<Object?> get props => [error];
}
