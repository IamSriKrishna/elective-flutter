import 'dart:ui';

import 'package:elective/src/app/app_data.dart';
import 'package:elective/src/bloc/auth/auth_bloc.dart';
import 'package:elective/src/bloc/auth/auth_event.dart';
import 'package:elective/src/bloc/auth/auth_state.dart';
import 'package:elective/src/widgets/auth_widgets.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Add this import

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final name = TextEditingController();
  final registerno = TextEditingController();
  final email = TextEditingController();
  String? selectedItem;
  bool _load = false;

  // Create a GlobalKey for Form state
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          setState(() {
            _load = false;
          });
          context.goNamed("login");
        } else if (state is AuthLoading) {
          setState(() {
            _load = true;
          });
        } else if (state is AuthError) {
          setState(() {
            _load = false;
          });
          Components.error(context, state.error.toString());
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
                        child: Form(
                          key: _formKey, // Assign the GlobalKey to the Form
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthWidget.createAccount(),
                              const SizedBox(height: 10),
                              AuthWidget.signUpToAccount(),
                              const SizedBox(height: 20),
                              AuthWidget.registerNo(registerno),
                              const SizedBox(height: 20),
                              AuthWidget.email(email),
                              const SizedBox(height: 20),
                              AuthWidget.name(name),
                              const SizedBox(height: 20),
                              AuthWidget.department(
                                value: selectedItem,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedItem = value;
                                  });
                                },
                                items: AppData.department,
                              ),
                              const SizedBox(height: 20),
                              AuthWidget.signIn(() {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  // Proceed only if form is valid
                                  final register = int.parse(registerno.text);
                                  context.read<AuthBloc>().add(AuthCreate(
                                        department: selectedItem!,
                                        name: name.text,
                                        email: email.text,
                                        registerNo: register,
                                      ));
                                }
                              }),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  context.goNamed("login");
                                },
                                child: Components.openSansText(
                                    text: "Already Have an Account?"),
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
                        ),
                      );
                    },
                  ),
                ),
                backgroundColor: Colors.blueGrey[50],
              ),
              if (_load)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  ),
                ),
              if (_load)
                const Center(
                    child: SpinKitWaveSpinner(color: Colors.black, size: 50.0)),
            ],
          );
        },
      ),
    );
  }
}
