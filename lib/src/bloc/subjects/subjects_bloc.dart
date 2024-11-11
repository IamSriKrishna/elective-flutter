import 'package:elective/src/app/app_data.dart';
import 'package:elective/src/bloc/subjects/subjects_event.dart';
import 'package:elective/src/bloc/subjects/subjects_state.dart';
import 'package:elective/src/controller/subject_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectController _subjectController;
  SubjectBloc(SubjectController subjectController)
      : _subjectController = subjectController,
        super(SubjectInitial()) {
    on<GetSubjectEvent>((event, emit) async {
      try {
        String token = AppData.getStorage.read("token");
        //Components.logMessage(token);
        final subject = await _subjectController.getSubjects(token: token);
        if (subject.status == true) {
          emit(GetSubject(subjects: subject));
        }
      } catch (e) {
        emit(SubjectError(error: e));
      }
    });
  }
}
