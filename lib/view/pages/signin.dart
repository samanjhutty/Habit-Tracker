import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controller/cloud/signin_controller.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final auth = FirebaseAuth.instance;
  final double myWidth = 350;
  late SignInAuth provider;

  @override
  void didChangeDependencies() {
    provider = context.read<SignInAuth>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(children: [
          Center(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CircleAvatar(
                      radius: 60, child: Icon(Icons.login_rounded, size: 56))),
              const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('Sign In',
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold))),
              Container(
                  padding: const EdgeInsets.only(top: 16),
                  width: 350,
                  child: TextFormField(
                    controller: context.watch<SignInAuth>().emailAddress,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: 'Enter Email Address',
                        border: OutlineInputBorder()),
                  )),
              const SizedBox(height: 24),
              Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  width: myWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                          controller: context.watch<SignInAuth>().password,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            labelText: 'Enter Password',
                            border: OutlineInputBorder(),
                          )),
                      TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.grey),
                          onPressed: () async {
                            if (context
                                .read<SignInAuth>()
                                .emailAddress
                                .text
                                .isEmpty) {
                              Get.rawSnackbar(
                                  message: 'Enter email address first');
                            } else {
                              try {
                                await auth.sendPasswordResetEmail(
                                    email: context
                                        .read<SignInAuth>()
                                        .emailAddress
                                        .text);
                                Get.rawSnackbar(
                                    message:
                                        'An email has been sent to your registered email with password reset link');
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'invalid-email') {
                                  Get.rawSnackbar(
                                      message: 'Enter a valid email address');
                                } else if (e.code == 'user-not-found') {
                                  Get.rawSnackbar(message: 'user not found');
                                }
                              } catch (e) {
                                Get.rawSnackbar(
                                    message: 'something went wrong, try again');
                              }
                            }
                          },
                          child: const Text('forgot password?')),
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: myWidth,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      onPressed: () async =>
                          await context.read<SignInAuth>().emailLogin(),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Login'))),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 50, child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('OR',
                            style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ),
                      SizedBox(width: 50, child: Divider(thickness: 1))
                    ],
                  )),
              const Text('Continue with',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          child: IconButton(
                              tooltip: 'Phone',
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/mobile'),
                              icon: const Icon(Icons.phone)),
                        ),
                        const SizedBox(width: 35),
                        CircleAvatar(
                            child: IconButton(
                                tooltip: 'Google',
                                onPressed: () async => await context
                                    .read<SignInAuth>()
                                    .googleLogin(),
                                icon: Image.asset(
                                    'lib/assets/images/google.png')))
                      ])),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Don't have an Account yet?"),
                  TextButton(
                      onPressed: () => Get.toNamed('/signup'),
                      child: const Text('Sign Up'))
                ]),
              )
            ],
          ))),
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded))
        ]),
      ),
    );
  }

  @override
  void dispose() {
    provider.password.clear();
    provider.emailAddress.clear();
    super.dispose();
  }
}
