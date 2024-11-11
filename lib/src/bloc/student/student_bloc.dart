import 'package:elective/src/app/app_data.dart';
import 'package:elective/src/bloc/student/student_event.dart';
import 'package:elective/src/bloc/student/student_state.dart';
import 'package:elective/src/controller/auth_controller.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final AuthController _authController;

  StudentBloc(AuthController authController)
      : _authController = authController,
        super(StudentInitial()) {
    Components.logMessage("Student Bloc");
    on<GetStudentData>((event, emit) async {
      try {
        String token = AppData.getStorage.read("token");

        final student = await _authController.getStudentByToken(token);
        if (student.status == true) {
          emit(GetStudent(student: student));
        }
      } catch (e) {
        String errorMessage =
            e.toString(); // Convert to string for a clearer message
        Components.logErrorMessage("Failed Student Bloc", errorMessage);
        emit(StudentError(error: errorMessage));
      }
    });
  }
}
