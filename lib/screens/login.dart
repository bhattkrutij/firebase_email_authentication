import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/screens/home.dart';
import 'package:firebase_authentication/screens/sign_up.dart';
import 'package:firebase_authentication/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/Validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Login"),
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: _emailController,
                          focusNode: _focusEmail,
                          validator: (value) =>
                              Validator.validateEmail(email: value),
                          decoration: InputDecoration(
                            hintText: "Email",
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: false,
                          focusNode: _focusPassword,
                          validator: (value) => Validator.validatePassword(
                            password: value,
                          ),
                          decoration: InputDecoration(
                              hintText: "Password",
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            _focusEmail.unfocus();
                            _focusPassword.unfocus();
                            if (_formKey.currentState!.validate()) {
                              final msg = await AuthService().login(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                              if (msg!.contains("success")) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ));
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(msg.toString())));
                            }
                          },
                          child: const Text("Login")),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ));
                          },
                          child: const Text("Create Account"))
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
