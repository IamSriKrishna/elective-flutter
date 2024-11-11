import 'package:elective/src/app/app_data.dart';
import 'package:elective/src/bloc/enroll/enroll_event.dart';
import 'package:elective/src/bloc/enroll/enroll_state.dart';
import 'package:elective/src/controller/subject_controller.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnrollBloc extends Bloc<EnrollEvent, EnrollState> {
  final SubjectController _subjectController;
  EnrollBloc(SubjectController subjectController)
      : _subjectController = subjectController,
        super(EnrollInitial()) {
    Components.logMessage("Enroll Bloc");

    on<SelectSubjectEvent>((event, emit) async {
      Components.logMessage("Select Subject Bloc");

      try {
        String token = AppData.getStorage.read("token");
        String id = AppData.getStorage.read("id");
        final studentId = int.parse(id);
        if (token.isEmpty || id.isEmpty) {
          emit(const EnrollError(error: "Missing token or id"));
          return;
        } 
        emit(EnrollLoading());
        final success = await _subjectController.enrollSubject(
            studentId: studentId, token: token, subjectId: event.subjectId);
        if (success) {
          await Future.delayed(const Duration(seconds: 2));
          emit(const EnrollSuccess(message: "Student created successfully"));
        } else {
          emit(const EnrollError(error: "Failed to create student"));
        }
      } catch (e) {
        Components.logErrorMessage("Failed To Enroll Bloc", e);
        emit(EnrollError(error: e.toString()));
      }
    });
  }
}
