import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  User? user;
  HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Home Screen"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  try {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.toString()),
                    ));
                  }
                },
                child: Text("Log Out"))
          ],
        ),
        body: Center(
            child: Text(FirebaseAuth.instance!.currentUser!.email.toString())));
  }
}
