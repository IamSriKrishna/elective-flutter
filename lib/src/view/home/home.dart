import 'package:elective/src/bloc/student/student_bloc.dart';
import 'package:elective/src/bloc/student/student_event.dart';
import 'package:elective/src/bloc/student/student_state.dart';
import 'package:elective/src/bloc/subjects/subjects_bloc.dart';
import 'package:elective/src/bloc/subjects/subjects_event.dart';
import 'package:elective/src/bloc/subjects/subjects_state.dart';
import 'package:elective/src/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        return BlocBuilder<SubjectBloc, SubjectState>(
          builder: (context, subjectState) {
            return BlocBuilder<StudentBloc, StudentState>(
              builder: (context, state) {
                return Scaffold(
                  body: CustomScrollView(
                    slivers: [
                      HomeWidgets.appBar(constraints, state),
                      HomeWidgets.welcomeUser(constraints, state),
                      HomeWidgets.grid(constraints, subjectState, state),
                      HomeWidgets.showElective(state, constraints)
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
