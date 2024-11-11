import 'dart:ui';
import 'package:elective/src/bloc/auth/auth_bloc.dart';
import 'package:elective/src/bloc/auth/auth_event.dart';
import 'package:elective/src/bloc/auth/auth_state.dart';
import 'package:elective/src/widgets/auth_widgets.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final name = TextEditingController();
  final registerno = TextEditingController();
  String? selectedItem;
  bool _load = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          setState(() {
            _load = false;
          });
          // context.read<StudentBloc>().add(GetStudentData());
          context.goNamed("home");
        } else if (state is AuthLoading) {
          setState(() {
            _load = true;
          });
        } else if (state is AuthError) {
          setState(() {
            _load = false;
          });
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                body: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double padding = constraints.maxWidth < 600 ? 20.0 : 40.0;

                      return Container(
                        width: constraints.maxWidth < 600
                            ? constraints.maxWidth
                            : 400,
                        padding: EdgeInsets.all(padding),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthWidget.welcomeBack(),
                            const SizedBox(height: 10),
                            AuthWidget.loginToAccount(),
                            const SizedBox(height: 20),
                            AuthWidget.registerNo(registerno),
                            const SizedBox(height: 20),
                            AuthWidget.signIn(() {
                              final register = int.parse(registerno.text);
                              context
                                  .read<AuthBloc>()
                                  .add(AuthLogin(registerNo: register));
                            }, text: "Login"),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                context.goNamed("signup");
                              },
                              child: Components.openSansText(
                                  text: "Don't have an account? Sign up here."),
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.center,
                              child: Components.openSansText(
                                text: "Developed by Sri Krishna",
                                fontSize: 12.0,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                backgroundColor: Colors.blueGrey[50],
              ),

              // Blurring background when loading
              if (_load)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 5.0, sigmaY: 5.0), // Adjust blur level
                    child: Container(
                      color: Colors.black.withOpacity(0), // Transparent overlay
                    ),
                  ),
                ),

              // Display the loading spinner
              if (_load)
                const Center(
                    child:
                        SpinKitSpinningLines(color: Colors.black, size: 50.0)),
            ],
          );
        },
      ),
    );
  }
}
