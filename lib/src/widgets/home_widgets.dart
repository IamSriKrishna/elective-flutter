import 'package:elective/src/app/app_family.dart';
import 'package:elective/src/bloc/auth/auth_bloc.dart';
import 'package:elective/src/bloc/auth/auth_event.dart';
import 'package:elective/src/bloc/student/student_state.dart';
import 'package:elective/src/bloc/subjects/subjects_state.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:go_router/go_router.dart';

class HomeWidgets {
  static SliverAppBar appBar(BoxConstraints constraints, BuildContext context) {
    double width = constraints.maxWidth;
    double fontSize = width > 600 ? 24 : 16;
    double iconPadding = width > 600 ? 24 : 16;
    return SliverAppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      leadingWidth: width * 0.3,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: iconPadding),
        child: Row(
          children: [
            // Container(decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(""))),),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Components.openSansText(
                  text: "KCG COLLEGE OF TECHNOLOGY",
                  fontSize: fontSize,
                  fontFamily: AppFamily.bold,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      title: searchField(constraints),
      actions: [logout(fontSize, context)],
    );
  }

  static Widget searchField(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth * 0.3,
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.black)),
          hintStyle: const TextStyle(
              color: Colors.black, fontFamily: AppFamily.regular),
          hintText: 'Search...',
        ),
        style: const TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1), letterSpacing: 0.5),
      ),
    );
  }

  static Widget logout(double fontSize, BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AuthBloc>().add(AuthLogOut());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Components.openSansText(
                text: "Log Out",
                fontWeight: FontWeight.bold,
                fontSize: fontSize - 5)
          ],
        ),
      ),
    );
  }

  static Widget grid(BoxConstraints constraints, SubjectState state,
      StudentState studentState) {
    double width = constraints.maxWidth;
    double fontSize = width > 600 ? 24 : 16;
    if (studentState is GetStudent) {
      if (state is GetSubject) {
        final List<LinearGradient> gradients = [
          const LinearGradient(colors: [Colors.red, Colors.orange]),
          const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
          const LinearGradient(colors: [Colors.green, Colors.lightGreen]),
          const LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
        ];
        final subject = state.subjects.result
            .where((e) =>
                e.department.contains(studentState.student.data.department))
            .toList();
        return SliverPadding(
          padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.1,
              vertical: constraints.maxHeight * 0.01),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
            ),
            itemCount: subject.length,
            itemBuilder: (context, index) {
              final currentSubject = subject[index];
              return InkWell(
                onTap: () {
                  context.goNamed(
                    "selection",
                    extra: currentSubject.title,
                    pathParameters: {
                      "subject_id": currentSubject.id.toString(),
                      "title": currentSubject.title,
                      "total_seat": currentSubject.totalSeat.toString(),
                      "available_seat": currentSubject.availableSeat.toString(),
                      "subject": studentState.student.data.subject.isEmpty
                          ? "none" // Provide a default or placeholder if empty
                          : studentState.student.data.subject
                    },
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: gradients[index % gradients.length],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Components.openSansText(
                            color: Colors.white,
                            fontFamily: AppFamily.bold,
                            text: currentSubject.title,
                            fontSize: fontSize),
                      ),
                    ),
                    if (currentSubject.availableSeat <= 10)
                      Align(
                        alignment: const Alignment(0, 1),
                        child: GlassContainer(
                          width: double.infinity,
                          child: Components.openSansText(
                              fontSize: fontSize,
                              fontFamily: AppFamily.light,
                              text: "Few Seat Left",
                              color: Colors.white),
                        ),
                      )
                  ],
                ),
              );
            },
          ),
        );
      }
    }
    return const SliverToBoxAdapter();
  }

  static Widget showElective(
    StudentState state,
    BoxConstraints constraints,
  ) {
    double width = constraints.maxWidth;
    double fontSize = width > 600 ? 24 : 16;
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.1,
            vertical: constraints.maxHeight * 0.2),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (state is GetStudent)
                  state.student.data.subject.isNotEmpty
                      ? Column(
                          children: [
                            Components.openSansText(
                                fontSize: fontSize,
                                text: "You have successfully selected"),
                            Components.openSansText(
                                fontFamily: AppFamily.bold,
                                fontSize: fontSize,
                                text: state.student.data.subject),
                            Components.openSansText(
                                fontSize: fontSize, text: "as your elective"),
                            const SizedBox(
                              height: 35,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Components.openSansText(
                                    fontSize: fontSize,
                                    text: "Check Your Email "),
                                Components.openSansText(
                                    fontWeight: FontWeight.bold,
                                    text: state.student.data.email,
                                    fontSize: fontSize,
                                    fontFamily: AppFamily.bold),
                                Components.openSansText(
                                    fontSize: fontSize,
                                    text: " For confirmation"),
                              ],
                            )
                          ],
                        )
                      : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
