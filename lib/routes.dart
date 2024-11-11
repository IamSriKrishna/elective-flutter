import 'package:elective/src/bloc/auth/auth_bloc.dart';
import 'package:elective/src/bloc/auth/auth_state.dart';
import 'package:elective/src/view/auth/login.dart';
import 'package:elective/src/view/auth/signup.dart';
import 'package:elective/src/view/home/home.dart';
import 'package:elective/src/view/seat/seat_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: "/signup", // Redirect to login initially
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (BuildContext context, GoRouterState state) {
        return const Login();
      },
    ),
    GoRoute(
      path: '/signup',
      name: "signup",
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpScreen();
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          child: const HomeScreen(),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            const begin = Offset(1.0, 0.0); // Slide from the right
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      },
      redirect: (BuildContext context, GoRouterState state) {
        final bool signedIn = context.read<AuthBloc>().state is AuthSuccess;
        if (signedIn == false) {
          return '/login';
        }

        return null; // Allow access to the home page if token is not empty
      },
    ),
    GoRoute(
      path:
          '/selection/:subject_id/:title/:total_seat/:available_seat/:subject',
      name: 'selection',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final title = state.pathParameters['title'].toString();
        final id = state.pathParameters['subject_id'].toString();
        final subject = state.pathParameters['subject'] ?? "";
        final seat = state.pathParameters["total_seat"].toString();
        final available = state.pathParameters["available_seat"].toString();
        final totalSeat = int.parse(seat);
        final availableSeat = int.parse(available);
        final subjectId = int.parse(id);
        return CustomTransitionPage(
          child: SeatLayout(
            title: title,
            subjectId: subjectId,
            totalSeat: totalSeat,
            subjects: subject,
            availableSeat: availableSeat,
          ),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            const begin = Offset(1.0, 0.0); // Slide from the right
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      },
      redirect: (BuildContext context, GoRouterState state) {
        final bool signedIn = context.read<AuthBloc>().state is AuthSuccess;

        // Redirect to login if token is empty
        if (signedIn != true) {
          return '/login';
        }

        return null; // Allow access to the selection page if token is not empty
      },
    ),
  ],
  debugLogDiagnostics: true,
);
