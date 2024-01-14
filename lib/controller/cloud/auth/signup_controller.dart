import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/assets/asset_widgets.dart';
import 'package:habit_tracker/controller/db_controller.dart';
import 'profile_controller.dart';

class SignUpAuth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfileController profile = ProfileController();
  MyWidgets widgets = MyWidgets();
  DbController db = DbController();

  TextEditingController phone = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  String shadowedPhone = 'XXXXXXXXXX';
  final String countryCode = '+91';
  String phoneOTP = '';
  String verifyID = '';

  Future<void> createAccount() async {
    await _signUpWithEmail(emailAddress.text.trim(), password.text.trim(),
        confirmPassword.text.trim());
    await profile.updateProfile();
    db.getFirestoreList();
    notifyListeners();
    widgets.mySnackbar('Account created sucessfully');
    Get.until(ModalRoute.withName('/'));

    emailAddress.clear();
    password.clear();
    username.clear();
    confirmPassword.clear();
  }

  refresh() => notifyListeners();

  Future<void> mobileSignIn() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: countryCode + phone.text,
        verificationCompleted: (PhoneAuthCredential authCredential) {
          phone.clear();
          username.clear();
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            widgets.mySnackbar('The provided phone number is not valid');
          } else if (e.code == 'invalid-verification-code') {
            widgets.mySnackbar('Invalid code');
          } else if (e.code == 'too-many-requests') {
            widgets.mySnackbar('Too many requests, try after sometime');
          }
        },
        codeSent: (String verificationID, int? resendCode) {
          Get.toNamed('/otppage');
          verifyID = verificationID;
          String numberOBS = phone.text.substring(6);
          shadowedPhone = 'XXXXXX$numberOBS';
          widgets.mySnackbar(
              'OTP has been sent to your mobile number $shadowedPhone');
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<void> verifyMobile() async {
    try {
      PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verifyID, smsCode: phoneOTP);
      await _auth.signInWithCredential(authCredential);
      widgets.mySnackbar('OTP verified');
      notifyListeners();

      _auth.currentUser!.displayName == null
          ? Get.toNamed('/profile')
          : Get.until(ModalRoute.withName('/'));
      db.getFirestoreList();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        widgets.mySnackbar('Invalid code');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _signUpWithEmail(
      String emailAddress, String password, String cPassword) async {
    try {
      cPassword == password
          ? await _auth.createUserWithEmailAndPassword(
              email: emailAddress, password: cPassword)
          : widgets.mySnackbar("Password doesn't match");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        widgets.mySnackbar('The password provided is too weak.');
      } else if (e.code == 'invalid-email') {
        widgets.mySnackbar('Enter valid email address.');
      } else if (e.code == 'email-already-in-use') {
        widgets.mySnackbar('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
