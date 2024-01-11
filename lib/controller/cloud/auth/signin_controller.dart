import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInAuth with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String verifyID = '';

  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> emailLogin() async =>
      await _signInWithEmail(emailAddress.text.trim(), password.text.trim())
          .whenComplete(() {
        emailAddress.clear();
        password.clear();
      });

  Future<void> logout() async {
    await auth.signOut();
    notifyListeners();
    Get.rawSnackbar(message: 'Logged out Sucessfully');
  }

  Future<void> deleteUser() async {
    await auth.currentUser!.delete();
    notifyListeners();
    Get.rawSnackbar(message: 'Account deleted Sucessfully');
  }

  void refresh() => notifyListeners();

  Future<void> _signInWithEmail(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      Get.rawSnackbar(message: 'Logged in Sucessfully');
      notifyListeners();
      Get.until(ModalRoute.withName('/'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.rawSnackbar(message: 'No user found for that email.');
      } else if (e.code == 'invalid-email') {
        Get.rawSnackbar(message: 'Wrong email provided for that user.');
      } else if (e.code == 'wrong-password') {
        Get.rawSnackbar(message: 'Wrong password provided for that user.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> googleLogin() async {
    try {
      final GoogleSignIn googleSignInID = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignInID.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth!.accessToken, idToken: googleAuth.idToken);

      await auth.signInWithCredential(credential);
      notifyListeners();
      Get.until(ModalRoute.withName('/'));
      Get.rawSnackbar(message: 'Logged in via Google');
    } on FirebaseAuthException {
      Get.until(ModalRoute.withName('/'));
      Get.rawSnackbar(message: 'Something went Wrong, try again!');
    }
  }

  Future<void> sendOTP() async {
    await auth.verifyPhoneNumber(
        phoneNumber: auth.currentUser!.phoneNumber,
        verificationCompleted: (PhoneAuthCredential authCredential) {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'too-many-requests') {
            Get.rawSnackbar(message: 'Too many requests, try after sometime');
          }
        },
        codeSent: (String verificationID, int? resendCode) {
          Get.toNamed('/reauth');
          verifyID = verificationID;
          Get.rawSnackbar(
              message:
                  'OTP has been sent to your mobile number ${auth.currentUser!.phoneNumber}');
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<void> reauth() async {
    try {
      final authrovider = auth.currentUser!.providerData[0].providerId;
      storage.FirebaseStorage fbStorage = storage.FirebaseStorage.instance;
      late AuthCredential credential;

      switch (authrovider) {
        case 'google.com':
          {
            final GoogleSignIn googleSignInID = GoogleSignIn(
                clientId:
                    '972040701571-4h6tsm7rjrci9272sa3cnt9ur94j1plq.apps.googleusercontent.com');

            final GoogleSignInAccount? googleUser =
                await googleSignInID.signIn();
            final GoogleSignInAuthentication? googleAuth =
                await googleUser?.authentication;

            credential = GoogleAuthProvider.credential(
                accessToken: googleAuth!.accessToken,
                idToken: googleAuth.idToken);
            await auth.currentUser!.reauthenticateWithCredential(credential);
          }

          break;
        case 'password':
          try {
            credential = EmailAuthProvider.credential(
                email: auth.currentUser!.email!, password: password.text);
            await auth.currentUser!.reauthenticateWithCredential(credential);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'wrong-password') {
              Get.rawSnackbar(message: 'Wrong password entered, try again');
            }
          }
          break;
        case 'phone':
          try {
            PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
                verificationId: verifyID, smsCode: password.text);
            await auth.signInWithCredential(authCredential);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'invalid-verification-code') {
              Get.rawSnackbar(message: 'Invalid code');
            } else if (e.code == 'too-many-requests') {
              Get.rawSnackbar(message: 'Too many requests, try after sometime');
            }
          }
          break;
        default:
          Get.rawSnackbar(message: 'Provider is Unknown');
      }
      storage.Reference refRoot = fbStorage.ref().child('USER-profileImage');
      storage.Reference ref =
          refRoot.child('profileImage${auth.currentUser!.uid}.jpg');

      await ref.delete();
      await auth.currentUser!.delete();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        Get.rawSnackbar(message: 'Invalid code, try again');
      } else if (e.code == 'wrong-password') {
        Get.rawSnackbar(message: 'Wrong Password, try again');
      } else if (e.code == 'invalid-credential') {
        Get.rawSnackbar(message: 'Wrong Credentials, try again');
      } else if (e.code == 'too-many-requests') {
        Get.rawSnackbar(message: 'Too many requests, try after sometime');
      }
    }
    Get.until(ModalRoute.withName('/'));
  }
}
