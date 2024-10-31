import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kgs_mobile_v2/pages/home.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../main.dart';
import '../theme/colors.dart';

enum ConnectionMode {
  online,
  offline,
}

enum ServerMode {
  test,
  live,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ConnectionMode _connectionMode = ConnectionMode.online;
  ServerMode _serverMode = ServerMode.test;


  final _formKey = GlobalKey<FormBuilderState>();
  final Connectivity _connectivity = Connectivity();
  bool _obscureText = true;

  // controllers for text fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // checks whether user is online
    _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        // Display an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivoryWhite,
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 6,
                      ),
                      Image.asset(
                        "assets/images/kgs_logo.png",
                        width: 150,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Enter your credentials to Login",
                        style:
                        customTextStyle(color: funGreen),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FormBuilderTextField(
                        key: const Key('email_key'),
                        controller: emailController,
                        name: 'email',
                        cursorColor: funGreen,
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: customTextStyle(color: funGreen),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: funGreen),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.email,
                            color: funGreen,
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: 'Email Address is required'),
                          FormBuilderValidators.email(),
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        key: const Key('password_key'),
                        name: 'password',
                        controller: passwordController,
                        obscureText: _obscureText,
                        cursorColor: funGreen,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: customTextStyle(color: funGreen),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: funGreen),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.key,
                            color: funGreen,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: 'Password is required'),
                          FormBuilderValidators.minLength(6, errorText: 'Password must be at least 6 characters'),
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField<ConnectionMode>(
                        value: null,
                        onChanged: (newValue) {
                          setState(() {
                            _connectionMode = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Connection Mode",
                          hintStyle: customTextStyle(color: funGreen),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: funGreen),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: ConnectionMode.online,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.wifi,
                                  color: funGreen,
                                ),
                                const SizedBox(width: 10),
                                Text('Online', style: customTextStyle(color: funGreen)),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: ConnectionMode.offline,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.signal_wifi_off,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 10),
                                Text('Offline', style: customTextStyle(color: funGreen)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField<ServerMode>(
                        value: null,
                        onChanged: (newValue) {
                          setState(() {
                            _serverMode = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Choose Server",
                          hintStyle: customTextStyle(color: funGreen),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: funGreen),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: ServerMode.test,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.settings,
                                  color: Colors.yellowAccent,
                                ),
                                const SizedBox(width: 10),
                                Text('Test', style: customTextStyle(color: funGreen)),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: ServerMode.live,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 10),
                                Text('Live', style: customTextStyle(color: funGreen)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        key: const Key('login_button_key'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: funGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                          minimumSize: const Size(double.infinity, 0),
                        ),
                        child: Text(
                          "Sign In",
                          style: customTextStyle(color: ivoryWhite),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


