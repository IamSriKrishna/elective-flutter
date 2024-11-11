import 'package:dio/dio.dart';
import 'package:elective/src/app/app_data.dart';
import 'package:elective/src/app/app_url.dart';
import 'package:elective/src/models/student.dart';
import 'package:elective/src/widgets/components.dart';

class AuthController {
  final Dio _dio = Dio();
  Future<bool> createStudent(
      {required int registerNo,
      required String name,
      required String email,
      required String department}) async {
    try {
      Response res = await _dio.post(AppUrl.createStudent,
          options: Options(
            contentType: Headers.jsonContentType,
          ),
          data: {
            "register_no": registerNo,
            "name": name,
            "email": email,
            "department": department
          });
      if (res.statusCode == 201) {
     //   Components.logMessage("Successfully created");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Components.logErrorMessage("Unable to create Students", e);
      return false;
    }
  }

  Future<bool> login({required int registerNo}) async {
    try {
      Response res = await _dio.post(AppUrl.login, options: Options(), data: {
        "register_no": registerNo,
      });
      if (res.data['status'].toString() == "true") {
        AppData.getStorage.write("token", res.data['token'].toString());
       // Components.logMessage("Successfully created");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Components.logErrorMessage("Unable to Login Students", e);
      return false;
    }
  }

  Future<Student> getStudentByToken(final String token) async {
    try {
      Response res = await _dio.get(
        AppUrl.getStudentData,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

        AppData.getStorage.write("id", res.data['data']['id'].toString());
      if (res.statusCode == 200) {
        // Components.logMessage(res.data.toString());
        // Components.logMessage(res.data['data']['id'].toString());
        return Student.fromJson(res.data);
      } else {
        throw Exception('Failed to load student data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
