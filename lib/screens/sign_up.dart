import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/screens/home.dart';
import 'package:firebase_authentication/services/auth_service.dart';
import 'package:firebase_authentication/utils/Validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SignUp"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  validator: (value) =>
                      Validator.validateEmail(email: _emailController.text),
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  validator: (value) => Validator.validatePassword(
                      password: _passwordController.text),
                  controller: _passwordController,
                  obscureText: false,
                  decoration: const InputDecoration(hintText: "Password"),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final msg = await AuthService().registration(
                          email: _emailController.text,
                          password: _passwordController.text);
                      if (msg!.contains("success")) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("something went wrong"),
                        ),
                      );
                    }
                  },
                  child: const Text("Sign Up")),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
