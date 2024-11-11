
import 'package:equatable/equatable.dart';

class EnrollState extends Equatable {
  const EnrollState();
  @override
  List<Object?> get props => [];
}

class EnrollInitial extends EnrollState {}

class EnrollLoading extends EnrollState {}

class EnrollSuccess extends EnrollState {
  final String message;
  const EnrollSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

class EnrollError extends EnrollState {
  final Object error;
  const EnrollError({required this.error});
  @override
  List<Object?> get props => [error];
}
