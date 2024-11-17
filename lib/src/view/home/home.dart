import 'package:elective/src/bloc/auth/auth_bloc.dart';
import 'package:elective/src/bloc/auth/auth_state.dart';
import 'package:elective/src/bloc/student/student_bloc.dart';
import 'package:elective/src/bloc/student/student_event.dart';
import 'package:elective/src/bloc/student/student_state.dart';
import 'package:elective/src/bloc/subjects/subjects_bloc.dart';
import 'package:elective/src/bloc/subjects/subjects_event.dart';
import 'package:elective/src/bloc/subjects/subjects_state.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:elective/src/widgets/home_welcome_user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elective/src/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedValue;

  @override
  void initState() {
    context.read<SubjectBloc>().add(GetSubjectEvent());
    context.read<StudentBloc>().add(GetStudentData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              if (state.status == AuthStateStatus.logout) {
                context.goNamed("login");
              }
            }
          },
          child: BlocBuilder<SubjectBloc, SubjectState>(
            builder: (context, subjectState) {
              return BlocBuilder<StudentBloc, StudentState>(
                builder: (context, state) {
                  return Scaffold(
                    body: CustomScrollView(
                      slivers: [
                        HomeWidgets.appBar(constraints, context),
                        HomeWelcomeUser(constraints: constraints),
                        HomeWidgets.grid(constraints, subjectState, state),
                        HomeWidgets.showElective(state, constraints),
                        SliverToBoxAdapter(
                          child: Container(
                            color: Colors
                                .grey[200], // Background color for the footer
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await launchUrl(Uri.parse(
                                        "https://www.instagram.com/_iamsrikrishna_/"));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Components.openSansText(
                                        text: 'Developed by Sri Krishna',
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center,
                                      ),
                                      Components.openSansText(
                                          text: "(Final Year)  ",
                                          fontStyle: FontStyle.italic),
                                      Components.openSansText(
                                        text: 'CSE',
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'With gratitude to the field of Computer Science and Development',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '© ${DateTime.now().year} All Rights Reserved.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
