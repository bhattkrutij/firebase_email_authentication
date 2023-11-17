import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  Future<String?> registration(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "success";
    } catch (e) {
      print("error while registration ::$e");
      return e.toString();
    }
  }

  Future<String?> login(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } catch (e) {
      print("error while login$e");

      return e.toString();
    }
  }
}
