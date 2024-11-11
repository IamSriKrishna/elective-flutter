import 'package:elective/src/app/app_data.dart';
import 'package:elective/src/bloc/auth/auth_event.dart';
import 'package:elective/src/bloc/auth/auth_state.dart';
import 'package:elective/src/controller/auth_controller.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthController _authController;

  AuthBloc(AuthController authController)
      : _authController = authController,
        super(AuthInitial()) {
    Components.logMessage("Auth Bloc");

    on<AuthCreate>((event, emit) async {
      try {
        // Emit loading state
        emit(AuthLoading());
        await Future.delayed(
            const Duration(seconds: 1)); // Simulate loading delay

        if (event.registerNo != 0 && event.name.isNotEmpty) {
          // Try to create student
          final success = await _authController.createStudent(
              email: event.email,
              registerNo: event.registerNo,
              name: event.name,
              department: event.department);

          if (success) {
            await Future.delayed(const Duration(
                seconds: 2)); // Simulate additional success delay
            emit(const AuthSuccess(
                message: "Student created successfully",
                status: AuthStateStatus.success));
          } else {
            emit(const AuthError(error: "Failed to create student"));
          }
        } else {
          Components.logErrorMessage("Failed Auth Bloc", "Field is Empty");
          emit(const AuthError(error: "Field is Empty"));
        }
      } catch (e) {
        String errorMessage =
            e.toString(); // Convert to string for a clearer message
        Components.logErrorMessage("Failed Auth Bloc", errorMessage);
        emit(AuthError(error: errorMessage));
      }
    });
    on<AuthLogin>((event, emit) async {
      try {
        // Emit loading state
        emit(AuthLoading());
        await Future.delayed(
            const Duration(seconds: 1)); // Simulate loading delay

        if (event.registerNo != 0) {
          // Try to create student
          final success =
              await _authController.login(registerNo: event.registerNo);

          if (success) {
            await Future.delayed(const Duration(
                seconds: 2)); // Simulate additional success delay
            emit(const AuthSuccess(
                message: "Student created successfully",
                status: AuthStateStatus.success));
          } else {
            emit(const AuthError(error: "Failed to create student"));
          }
        } else {
          Components.logErrorMessage("Failed Auth Bloc", "Field is Empty");
          emit(const AuthError(error: "Field is Empty"));
        }
      } catch (e) {
        String errorMessage =
            e.toString(); // Convert to string for a clearer message
        Components.logErrorMessage("Failed Auth Bloc", errorMessage);
        emit(AuthError(error: errorMessage));
      }
    });

    on<AuthGetStudentData>((event, emit) async {
      try {
        String token = AppData.getStorage.read("token");

        final student = await _authController.getStudentByToken(token);
        if (student.status == true) {
          emit(AuthGetStudent(student: student));
        }
      } catch (e) {
        String errorMessage =
            e.toString(); // Convert to string for a clearer message
        Components.logErrorMessage("Failed Auth Bloc", errorMessage);
        emit(AuthError(error: errorMessage));
      }
    });
  }
}
