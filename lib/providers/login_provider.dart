import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? userLogged;
  User? user;

  bool isLogin = false;
  bool isRegister = false;
  bool isLoading = false;
  List<bool> selectedEvent = [false, false];

  bool accesGranted = false;
  String errorMessage = '';

  LoginProvider();

 Future<void> loginOrRegister(String email, String password) async {
  isLoading = true;
  notifyListeners();

  try {
    if (isRegister) {
      userLogged = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } else {
      userLogged = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    }

    user = userLogged?.user;
    accesGranted = user != null;
  } on FirebaseAuthException catch (e) {
    print("FirebaseAuthException: ${e.code}, ${e.message}"); // Imprimir el código y mensaje del error
    errorMessage = getMessageFromErrorCode(e.code);
  } catch (e) {
    print("Error desconocido: $e"); // Imprimir cualquier otro error
    errorMessage = "Error desconocido. Inténtalo de nuevo.";
  }

  isLoading = false;
  notifyListeners();
}



 void logOut() async {
  await _auth.signOut(); // Cierra sesión en Firebase
  userLogged = null;
  user = null;
  accesGranted = false;
  isLogin = false;
  isRegister = false;
  errorMessage = '';
  selectedEvent = [false, false];
  notifyListeners();
}

  void opcioMenu(int index) {
    for (int i = 0; i < selectedEvent.length; i++) {
      selectedEvent[i] = i == index;
    }
    if (index == 0) {
      isLogin = true;
      isRegister = false;
    } else {
      isLogin = false;
      isRegister = true;
    }
    notifyListeners();
  }

  bool get isLoginOrRegister {
    return isLogin || isRegister;
  }


String getMessageFromErrorCode(String errorCode) {
  switch (errorCode) {
    case "email-already-in-use":
      return "Email already used. Go to login page.";
    case "wrong-password":
      return "Wrong email/password combination.";
    case "user-not-found":
      return "No user found with this email.";
    case "user-disabled":
      return "User disabled.";
    case "too-many-requests":
      return "Too many requests to log into this account.";
    case "operation-not-allowed":
      return "Server error, please try again later.";
    case "invalid-email":
      return "Email address is invalid.";
    case "invalid-login-credentials":
      return "Invalid credentials.";
    default:
      return "Login failed. Please try again.";
  }
}
}