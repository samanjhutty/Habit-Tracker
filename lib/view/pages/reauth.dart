import 'dart:ui';
import '../../../assets/asset_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controller/cloud/auth/signin_controller.dart';

class ReAuthenticate extends StatefulWidget {
  const ReAuthenticate({super.key});

  @override
  State<ReAuthenticate> createState() => _ReAuthenticateState();
}

class _ReAuthenticateState extends State<ReAuthenticate> {
  final double myWidth = 350;
  final formKey = GlobalKey<FormState>();
  Widget? wgtNext;

  @override
  void initState() {
    wgtNext = context
        .read<MyWidgets>()
        .defaultSubmitBtn(title: 'Delete Account', icon: Icons.delete_rounded);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Form(
          key: formKey,
          child: Stack(children: [
            AppBar(),
            Center(
                child: SingleChildScrollView(
              child: Column(children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: CircleAvatar(
                        radius: 64,
                        child: Icon(Icons.verified_rounded, size: 60))),
                const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('User Verification',
                        style: TextStyle(
                            fontFeatures: [FontFeature.swash()],
                            fontSize: 32))),
                const SizedBox(height: 8),
                const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                        'Reauthenticate with Credentials to Deleted Account')),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    width: myWidth,
                    child: TextFormField(
                        validator: (value) {
                          if (context
                              .read<SignInAuth>()
                              .password
                              .text
                              .isEmpty) {
                            return 'Password/OTP cannot be empty';
                          } else {
                            return null;
                          }
                        },
                        textCapitalization: TextCapitalization.words,
                        controller: context.read<SignInAuth>().password,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Enter Password/OTP',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.name)),
                Consumer2<SignInAuth, MyWidgets>(
                    builder: (context, singin, mywidgets, child) {
                  return Container(
                      padding: const EdgeInsets.only(top: 16),
                      width: myWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16)),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            wgtNext = mywidgets.myAnimation(
                                title: 'Delete Account',
                                progress: true,
                                icon: Icons.delete_rounded);
                            await singin.reauth();
                            wgtNext = mywidgets.myAnimation(
                                title: 'Delete Account',
                                icon: Icons.delete_rounded);
                            Get.until(ModalRoute.withName('/'));
                          }
                        },
                        child: wgtNext,
                      ));
                }),
              ]),
            ))
          ]),
        ),
      ),
    );
  }
}
