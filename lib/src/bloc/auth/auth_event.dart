import 'package:equatable/equatable.dart';

class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCreate extends AuthEvent {
  final int registerNo;
  final String name;
  final String email;
  final String department;

  const AuthCreate(
      {required this.registerNo, required this.name, required this.department,required this.email});
  @override
  List<Object?> get props => [registerNo, name, department,email];
}

class AuthLogin extends AuthEvent {
  final int registerNo;
  final String otp;
  const AuthLogin({required this.registerNo,required this.otp});
  @override
  List<Object?> get props => [registerNo,otp];
}

class AuthGetStudentData extends AuthEvent {}

class AuthLogOut extends AuthEvent{}