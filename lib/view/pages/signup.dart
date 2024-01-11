import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/cloud/auth/signup_controller.dart';
import '../../controller/cloud/auth/profile_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final double myWidth = 350;
  final double boxHeight = 20;
  late SignUpAuth provider;
  @override
  void didChangeDependencies() {
    provider = context.read<SignUpAuth>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      child: SafeArea(
        child: Stack(children: [
          Center(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              Stack(alignment: Alignment.bottomRight, children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Consumer<ProfileController>(
                    builder: (context, value, child) => CircleAvatar(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      radius: 60,
                      child: value.image == null && value.webImage == null
                          ? const Icon(Icons.login_rounded, size: 56)
                          : kIsWeb
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.memory(value.webImage!,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(value.image!,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover),
                                ),
                    ),
                  ),
                ),
                IconButton(
                  icon: CircleAvatar(
                      backgroundColor: scheme.surface,
                      child: const Icon(Icons.camera_alt, size: 20)),
                  onPressed: () =>
                      context.read<ProfileController>().pickImage(),
                )
              ]),
              const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('Create Account',
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold))),
              Container(
                  padding: const EdgeInsets.only(top: 16),
                  width: 350,
                  child: TextFormField(
                    controller: context.watch<SignUpAuth>().username,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        labelText: 'Enter Name', border: OutlineInputBorder()),
                  )),
              SizedBox(height: boxHeight),
              SizedBox(
                  width: 350,
                  child: TextFormField(
                    controller: context.watch<SignUpAuth>().emailAddress,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: 'Enter Email Address',
                        border: OutlineInputBorder()),
                  )),
              SizedBox(height: boxHeight),
              SizedBox(
                  width: myWidth,
                  child: TextFormField(
                    controller: context.watch<SignUpAuth>().password,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                        labelText: 'Enter Password',
                        border: OutlineInputBorder()),
                  )),
              SizedBox(height: boxHeight),
              Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  width: myWidth,
                  child: TextFormField(
                    controller: context.watch<SignUpAuth>().confirmPassword,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder()),
                  )),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: myWidth,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      onPressed: () async =>
                          await context.read<SignUpAuth>().createAccount(),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Create Account'))),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Already have an Account?"),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Sign In'))
              ])
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
    provider.username.clear();
    provider.emailAddress.clear();
    provider.password.clear();
    provider.confirmPassword.clear();
    super.dispose();
  }
}
