import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import '../../assets/assets.dart';
import '../../controller/cloud/signup_controller.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  final String title = 'OTP Page';
  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  List<Widget>? list;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      child: SafeArea(
        child: Stack(children: [
          AppBar(),
          Center(
              child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CircleAvatar(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      radius: 64,
                      child: const Icon(Icons.message_rounded, size: 60))),
              const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('OTP Verification',
                      style: TextStyle(
                          fontFeatures: [FontFeature.swash()], fontSize: 32))),
              const SizedBox(height: 8),
              Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                      'Enter the OTP sent to you mobile number ${context.watch<SignUpAuth>().shadowedPhone}')),
              Consumer<SignUpAuth>(
                builder: (context, provider, child) => OTPTextField(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    fieldStyle: FieldStyle.box,
                    spaceBetween: 8,
                    fieldWidth: 45,
                    width: 350,
                    length: 6,
                    onChanged: (value) {},
                    onCompleted: (value) {
                      provider.phoneOTP = value;
                      provider.verifyMobile();
                    }),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: list = [
                        const Text('OTP not recieved?'),
                        Consumer2<SignUpAuth, MyWidgets>(
                            builder: (context, signup, mywidgets, child) {
                          return TextButton(
                              onPressed: mywidgets.timerEnabled
                                  ? null
                                  : () async {
                                      await signup.mobileSignIn();
                                      mywidgets.timer();
                                    },
                              child: const Text('Resend OTP'));
                        }),
                        Consumer<MyWidgets>(
                            builder: (context, provider, child) {
                          return Text('in ${provider.timerSeconds}',
                              style: const TextStyle(color: Colors.grey));
                        })
                      ]))
            ]),
          ))
        ]),
      ),
    );
  }
}
