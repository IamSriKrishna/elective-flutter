import 'package:dio/dio.dart';
import 'package:elective/src/app/app_url.dart';
import 'package:elective/src/models/subjects.dart';
import 'package:elective/src/widgets/components.dart';

class SubjectController {
  final Dio _dio = Dio();

  Future<Subjects> getSubjects({required String token}) async {
    try {
      Response res = await _dio.get(AppUrl.getSubjectData,
          options: Options(
            contentType: Headers.jsonContentType,
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      if (res.statusCode == 200) {
        //Components.logMessage(res.data.toString());
        return Subjects.fromJson(res.data);
      } else {
        throw Exception('Failed to load student data');
      }
    } catch (e) {
      Components.logErrorMessage("Failed to get Subjects", e);
      throw Exception(e);
    }
  }

  Future<bool> enrollSubject(
      {required int studentId,
      required String token,
      required int subjectId}) async {
    try {
      Response res = await _dio.post(AppUrl.enrollSubject,
          options: Options(
            contentType: Headers.jsonContentType,
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
          data: {
            "student_id": studentId,
            "subject_id": subjectId,
          });
      //  Components.logMessage(res.data.toString());
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Components.logErrorMessage("Failed To Enroll Subject", e);
      return false;
    }
  }
}
