import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/controller/cloud/profile_controller.dart';
import 'package:habit_tracker/controller/cloud/signin_controller.dart';
import 'package:habit_tracker/controller/cloud/signup_controller.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      child: Scaffold(
          appBar: AppBar(title:
              Consumer3<SignInAuth, SignUpAuth, ProfileController>(
                  builder: (context, signin, signup, profile, child) {
            return Text(
              'Greetings ${auth.currentUser?.displayName ?? 'Guest'}!',
              style: const TextStyle(fontWeight: FontWeight.w600),
            );
          })),
          body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Consumer3<SignInAuth, SignUpAuth, ProfileController>(
                builder: (context, signin, signup, profile, child) {
                  return auth.currentUser == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                          'Sign in to display profile data, and store your data to cloud'),
                                      const SizedBox(height: 16),
                                      ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: scheme.primary,
                                              foregroundColor:
                                                  scheme.onPrimary),
                                          onPressed: () =>
                                              Get.toNamed('/signin'),
                                          icon: const Icon(Icons.login),
                                          label:
                                              const Text('Sign In to continue'))
                                    ]),
                              ),
                            ),
                            const Card(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                    'Your data is being stored in your device., if you uninstall app your data will be deleted permanently'),
                              ),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: ListTile(
                                  trailing: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        auth.currentUser!.photoURL!),
                                  ),
                                  title: Text(
                                    auth.currentUser!.displayName!,
                                    style: TextStyle(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(auth.currentUser!.email!),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  onPressed: () => Get.toNamed('/profile'),
                                  label: const Text('Edit Profile'),
                                  icon: const Icon(Icons.edit),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  onPressed: () => showBottomSheet(
                                      context: context,
                                      builder: (conetext) {
                                        Color? themeColor;
                                        return BottomSheet(
                                            onClosing: () {
                                              print(themeColor);
                                            },
                                            builder: ((context) => Column(
                                                  children: [
                                                    ListTile(
                                                      onTap: () {
                                                        themeColor = Colors
                                                            .lightGreenAccent;
                                                      },
                                                      leading:
                                                          const CircleAvatar(
                                                              child:
                                                                  CircleAvatar(
                                                        backgroundColor: Colors
                                                            .lightGreenAccent,
                                                      )),
                                                      title: const Text(
                                                          'Light Green'),
                                                    ),
                                                    ListTile(
                                                      onTap: () {
                                                        themeColor = Colors
                                                            .lightGreenAccent;
                                                      },
                                                      leading:
                                                          const CircleAvatar(
                                                              child:
                                                                  CircleAvatar(
                                                        backgroundColor: Colors
                                                            .lightGreenAccent,
                                                      )),
                                                      title: const Text(
                                                          'Light Green'),
                                                    ),
                                                    ListTile(
                                                      onTap: () {
                                                        themeColor = Colors
                                                            .lightGreenAccent;
                                                      },
                                                      leading:
                                                          const CircleAvatar(
                                                              child:
                                                                  CircleAvatar(
                                                        backgroundColor: Colors
                                                            .lightGreenAccent,
                                                      )),
                                                      title: const Text(
                                                          'Light Green'),
                                                    ),
                                                    ListTile(
                                                      onTap: () {
                                                        themeColor = Colors
                                                            .lightGreenAccent;
                                                      },
                                                      leading:
                                                          const CircleAvatar(
                                                              child:
                                                                  CircleAvatar(
                                                        backgroundColor: Colors
                                                            .lightGreenAccent,
                                                      )),
                                                      title: const Text(
                                                          'Light Green'),
                                                    ),
                                                    ListTile(
                                                      onTap: () {
                                                        themeColor = Colors
                                                            .lightGreenAccent;
                                                      },
                                                      leading:
                                                          const CircleAvatar(
                                                              child:
                                                                  CircleAvatar(
                                                        backgroundColor: Colors
                                                            .lightGreenAccent,
                                                      )),
                                                      title: const Text(
                                                          'Light Green'),
                                                    ),
                                                    ListTile(
                                                      onTap: () {
                                                        themeColor = Colors
                                                            .lightGreenAccent;
                                                      },
                                                      leading:
                                                          const CircleAvatar(
                                                              child:
                                                                  CircleAvatar(
                                                        backgroundColor: Colors
                                                            .lightGreenAccent,
                                                      )),
                                                      title: const Text(
                                                          'Light Green'),
                                                    ),
                                                  ],
                                                )));
                                      }),
                                  label: const Text('Theme'),
                                  icon: const Icon(Icons.color_lens),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  onPressed: () {},
                                  label: const Text('Sync'),
                                  icon: const Icon(Icons.sync),
                                ),
                              ],
                            )
                          ],
                        );
                },
              ))),
    );
  }
}
