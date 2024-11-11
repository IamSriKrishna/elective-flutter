import 'package:elective/routes.dart';
import 'package:elective/src/app/app_family.dart';
import 'package:elective/src/bloc/auth/auth_bloc.dart';
import 'package:elective/src/bloc/enroll/enroll_bloc.dart';
import 'package:elective/src/bloc/student/student_bloc.dart';
import 'package:elective/src/bloc/subjects/subjects_bloc.dart';
import 'package:elective/src/controller/auth_controller.dart';
import 'package:elective/src/controller/subject_controller.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthController()),
        ),
        BlocProvider(
          create: (context) => StudentBloc(AuthController()),
        ),
        BlocProvider(
          create: (context) => SubjectBloc(SubjectController()),
        ),
        BlocProvider(
          create: (context) => EnrollBloc(SubjectController()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          // If screen width is less than 600 (mobile resolution), show restricted page
          if (screenWidth < 600) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Kcg College Of Technology',
              home: const MobileResolutionError(),
              theme: ThemeData(
                textTheme: const TextTheme(
                    titleMedium: TextStyle(fontFamily: AppFamily.regular)),
                useMaterial3: false,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
            );
          } else {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Kcg College Of Technology',
              routerConfig: router,
              theme: ThemeData(
                textTheme: const TextTheme(
                    titleMedium: TextStyle(fontFamily: AppFamily.regular)),
                useMaterial3: false,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
            );
          }
        },
      ),
    );
  }
}

class MobileResolutionError extends StatelessWidget {
  const MobileResolutionError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 50),
            const SizedBox(height: 20),
            Components.openSansText(
                text:
                    'Sorry, this app is not available for mobile resolution.\n'
                    'Please use a laptop or PC for a better experience.\n\n',
                   // 'Developed by Sri Krishna M, CSE Dept.',
                textAlign: TextAlign.center,
                fontSize: 18),
          ],
        ),
      ),
    );
  }
}
