import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../assets/assets.dart';
import '../../controller/cloud/signup_controller.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({Key? key}) : super(key: key);

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  final double myWidth = 350;
  Widget? btn;
  late SignUpAuth provider;

  @override
  void initState() {
    btn = context.read<MyWidgets>().defaultSubmitBtn();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = SignUpAuth();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Material(
        child: SafeArea(
          child: Stack(children: [
            AppBar(),
            Center(
                child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: CircleAvatar(
                            radius: 64, child: Icon(Icons.phone, size: 60))),
                    const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Sign Up with Mobile',
                            style: TextStyle(
                                fontFeatures: [FontFeature.swash()],
                                fontSize: 32))),
                    const SizedBox(height: 8),
                    const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Text(
                            'Enter a 10 digit mobile number to continue.')),
                    const SizedBox(height: 24),
                    Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        width: myWidth,
                        child: TextFormField(
                            controller: context.watch<SignUpAuth>().phone,
                            decoration: InputDecoration(
                                labelText: 'Enter Mobile Number',
                                prefixText:
                                    context.watch<SignUpAuth>().countryCode,
                                border: const OutlineInputBorder()),
                            maxLength: 10,
                            keyboardType: TextInputType.phone)),
                    Container(
                        padding: const EdgeInsets.only(top: 16),
                        width: myWidth,
                        child: Consumer<MyWidgets>(
                            builder: (context, provider, child) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16)),
                              onPressed: () async {
                                btn = provider.myAnimation(progress: true);
                                await context.read<SignUpAuth>().mobileSignIn();
                              },
                              child: btn);
                        })),
                    Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an Account?'),
                              TextButton(
                                  onPressed: () => Get.offNamed('/signin'),
                                  child: const Text('Sign In'))
                            ]))
                  ]),
            ))
          ]),
        ),
      );
  @override
  void dispose() {
    provider.phone.clear();
    super.dispose();
  }
}
