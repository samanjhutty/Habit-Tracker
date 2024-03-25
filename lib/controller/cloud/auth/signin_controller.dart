import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/assets/asset_widgets.dart';
import 'package:habit_tracker/controller/db_controller.dart';

class SignInAuth with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String verifyID = '';
  MyWidgets widgets = MyWidgets();
  DbController db = DbController();

  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> emailLogin() async =>
      await _signInWithEmail(emailAddress.text.trim(), password.text.trim())
          .whenComplete(() {
        db.getFirestoreList();
        db.loadHeatMap();
        emailAddress.clear();
        password.clear();
      });

  Future<void> logout() async {
    await auth.signOut();
    notifyListeners();
    widgets.mySnackbar('Logged out Sucessfully');
  }

  Future<void> deleteUser() async {
    await auth.currentUser!.delete();
    notifyListeners();
    widgets.mySnackbar('Account deleted Sucessfully');
  }

  Future<void> _signInWithEmail(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      widgets.mySnackbar('Logged in Sucessfully');
      notifyListeners();
      Get.until(ModalRoute.withName('/'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        widgets.mySnackbar('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        widgets.mySnackbar('Wrong email provided for that user.');
      } else if (e.code == 'wrong-password') {
        widgets.mySnackbar('Wrong password provided for that user.');
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
      db.getFirestoreList();
      db.loadHeatMap();
      widgets.mySnackbar('Logged in via Google');
    } on FirebaseAuthException {
      Get.until(ModalRoute.withName('/'));
      widgets.mySnackbar('Something went Wrong, try again!');
    }
  }

  Future<void> sendOTP() async {
    await auth.verifyPhoneNumber(
        phoneNumber: auth.currentUser!.phoneNumber,
        verificationCompleted: (PhoneAuthCredential authCredential) {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'too-many-requests') {
            widgets.mySnackbar('Too many requests, try after sometime');
          }
        },
        codeSent: (String verificationID, int? resendCode) {
          Get.toNamed('/reauth');
          verifyID = verificationID;
          widgets.mySnackbar(
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
              widgets.mySnackbar('Wrong password entered, try again');
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
              widgets.mySnackbar('Invalid code');
            } else if (e.code == 'too-many-requests') {
              widgets.mySnackbar('Too many requests, try after sometime');
            }
          }
          break;
        default:
          widgets.mySnackbar('Provider is Unknown');
      }
      storage.Reference refRoot = fbStorage.ref().child('USER-profileImage');
      storage.Reference ref =
          refRoot.child('profileImage${auth.currentUser!.uid}.jpg');

      await ref.delete();
      await auth.currentUser!.delete();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        widgets.mySnackbar('Invalid code, try again');
      } else if (e.code == 'wrong-password') {
        widgets.mySnackbar('Wrong Password, try again');
      } else if (e.code == 'invalid-credential') {
        widgets.mySnackbar('Wrong Credentials, try again');
      } else if (e.code == 'too-many-requests') {
        widgets.mySnackbar('Too many requests, try after sometime');
      }
    }
    Get.until(ModalRoute.withName('/'));
  }
}
