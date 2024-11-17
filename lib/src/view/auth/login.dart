import 'dart:ui';
import 'package:elective/src/app/app_family.dart';
import 'package:elective/src/bloc/auth/auth_bloc.dart';
import 'package:elective/src/bloc/auth/auth_event.dart';
import 'package:elective/src/bloc/auth/auth_state.dart';
import 'package:elective/src/bloc/session/timer_bloc.dart';
import 'package:elective/src/bloc/session/timer_event.dart';
import 'package:elective/src/bloc/session/timer_state.dart';
import 'package:elective/src/widgets/auth_widgets.dart';
import 'package:elective/src/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:pin_code_fields/pin_code_fields.dart'; // Import the pin_code_fields package

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final registerno = TextEditingController();
  bool _load = false;
  DateTime now = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String pinCode = "";
  final TextEditingController _pinController = TextEditingController();
  @override
  void initState() {
    super.initState();

    DateTime targetStart = DateTime(2024, 11, 20, 19, 0, 0);
    DateTime targetEnd = DateTime(2024, 11, 20, 23, 0, 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        context.read<TimerBloc>().add(
            TimerStartEvent(targetStart: targetStart, targetEnd: targetEnd));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          setState(() {
            _load = false;
          });
          context.goNamed("home");
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
          return BlocBuilder<TimerBloc, TimerState>(
            builder: (context, timerState) {
              // bool canLogin = false;
              // bool expery = false;

              int hours = 0, minutes = 0, seconds = 0;
              if (timerState is TimerExpiredState) {
                // expery = true;
              }
              if (timerState is TimerRunningState) {
                // canLogin = timerState.canLogin;
                Duration remainingTime = timerState.timeRemaining;
                hours = remainingTime.inHours;
                minutes = remainingTime.inMinutes % 60;
                seconds = remainingTime.inSeconds % 60;
              }

              return Stack(
                children: [
                  Scaffold(
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Center(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double padding =
                                  constraints.maxWidth < 600 ? 20.0 : 40.0;

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
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      AuthWidget.welcomeBack(),
                                      const SizedBox(height: 10),
                                      AuthWidget.loginToAccount(),
                                      const SizedBox(height: 20),

                                      // Register No Field
                                      AuthWidget.registerNo(registerno,
                                          textInputAction:
                                              TextInputAction.done),

                                      // Pin Code Input Field
                                      const SizedBox(height: 20),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 5.0),
                                          child: Components.openSansText(
                                              text: "Email OTP",
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      PinCodeTextField(
                                        length: 6,
                                        animationType: AnimationType.fade,
                                        controller: _pinController,
                                        pinTheme: PinTheme(
                                          shape: PinCodeFieldShape.underline,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          fieldHeight: 50,
                                          fieldWidth: 40,
                                          activeFillColor: Colors.white,
                                          inactiveFillColor: Colors.white,
                                          selectedFillColor: Colors.white,
                                          activeColor: Colors.blue,
                                          inactiveColor: Colors.grey,
                                          selectedColor: Colors.blue,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            pinCode = value;
                                          });
                                        },
                                        onCompleted: (value) {
                                          Components.logMessage(
                                              "Completed: $value");
                                        },
                                        appContext: context,
                                      ),

                                      const SizedBox(height: 20),
                                      AuthWidget.signIn(() {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          final register =
                                              int.parse(registerno.text);
                                          context.read<AuthBloc>().add(
                                              AuthLogin(
                                                  registerNo: register,
                                                  otp: _pinController.text));
                                        }
                                      }, text: "Login"),
                                      const SizedBox(height: 20),
                                      TextButton(
                                        onPressed: () {
                                          context.goNamed("signup");
                                        },
                                        child: Components.openSansText(
                                            text:
                                                "Don't have an account? Sign up here."),
                                      ),
                                      const SizedBox(height: 20),
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              if (timerState is TimerBeforeStartState)
                                if (now.day == 20 && now.month == 11)
                                  Components.openSansText(
                                    text:
                                        'Please wait till, 7:00 PM to log in.',
                                    textAlign: TextAlign.center,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  )
                                else
                                  Components.openSansText(
                                    text:
                                        "Please wait until 20th November 2024, 7:00 PM to select your elective.",
                                    textAlign: TextAlign.center,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                              if (timerState is TimerRunningState)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Components.openSansText(
                                      text: "Time remaining:",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    AnimatedFlipCounter(
                                      value: hours.toDouble(),
                                      duration:
                                          const Duration(milliseconds: 500),
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: AppFamily.bold,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      wholeDigits: 2,
                                      fractionDigits: 0,
                                    ),
                                    const Text(
                                      ":",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: AppFamily.bold,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    AnimatedFlipCounter(
                                      value: minutes.toDouble(),
                                      duration:
                                          const Duration(milliseconds: 500),
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: AppFamily.bold,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      wholeDigits: 2,
                                      fractionDigits: 0,
                                    ),
                                    const Text(
                                      ":",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: AppFamily.bold,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    AnimatedFlipCounter(
                                      value: seconds.toDouble(),
                                      duration:
                                          const Duration(milliseconds: 500),
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: AppFamily.bold,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      wholeDigits: 2,
                                      fractionDigits: 0,
                                    ),
                                  ],
                                ),
                              if (timerState is TimerExpiredState)
                                Components.openSansText(
                                  text: 'Session has expired.',
                                  textAlign: TextAlign.center,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.blueGrey[50],
                  ),
                  if (_load)
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                        child: Container(
                          color: Colors.black.withOpacity(0),
                        ),
                      ),
                    ),
                  if (_load)
                    const Center(
                        child: SpinKitSpinningLines(
                            color: Colors.black, size: 50.0)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
