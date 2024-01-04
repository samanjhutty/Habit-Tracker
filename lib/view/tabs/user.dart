import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/controller/cloud/profile_controller.dart';
import 'package:habit_tracker/controller/cloud/signin_controller.dart';
import 'package:habit_tracker/controller/cloud/signup_controller.dart';
import 'package:habit_tracker/controller/local/db_constants.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  Color? appThemeColor;
  bool? selected = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    Size device = MediaQuery.of(context).size;
    return Material(
      child: Scaffold(
          appBar: AppBar(title:
              Consumer3<SignInAuth, SignUpAuth, ProfileController>(
                  builder: (context, signin, signup, profile, child) {
            return Row(
              children: [
                Text(
                  'Greetings ${auth.currentUser?.displayName ?? 'Guest'} ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Icon(
                  Icons.waving_hand,
                  color: Colors.amber,
                )
              ],
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: device.height * 0.01,
                                ),
                                ListTile(
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
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 32),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        onPressed: () =>
                                            Get.toNamed('/profile'),
                                        label: const Text('Edit'),
                                        icon: const Icon(Icons.edit),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 32),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        onPressed: () => showBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return BottomSheet(
                                                  backgroundColor:
                                                      scheme.secondary,
                                                  showDragHandle: true,
                                                  animationController:
                                                      AnimationController(
                                                          vsync: this),
                                                  onClosing: () {
                                                    appThemeColor ??=
                                                        const Color(0xFFFB5B76);
                                                    print(appThemeColor);
                                                    box.put(
                                                        BoxConstants
                                                            .appThemeColor,
                                                        appThemeColor!.value);
                                                    Get.rawSnackbar(
                                                        message:
                                                            'Please restart app to see changes.');
                                                  },
                                                  builder: ((context) => Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          RadioListTile(
                                                            value: selected!,
                                                            groupValue:
                                                                selected!,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selected =
                                                                    value;
                                                              });

                                                              appThemeColor =
                                                                  const Color(
                                                                      0xFFFB5B76);
                                                            },
                                                            title: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                    'Default'),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      color: scheme
                                                                          .secondary,
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  child:
                                                                      const CircleAvatar(
                                                                    radius: 16,
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xFFFB5B76),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          RadioListTile(
                                                            value: selected!,
                                                            groupValue:
                                                                !selected!,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selected =
                                                                    value;
                                                              });
                                                              appThemeColor = Colors
                                                                  .lightGreenAccent;
                                                            },
                                                            title: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                    'Light Green'),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      color: scheme
                                                                          .secondary,
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  child:
                                                                      const CircleAvatar(
                                                                    radius: 16,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .lightGreenAccent,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          RadioListTile(
                                                            value: selected!,
                                                            groupValue:
                                                                !selected!,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selected =
                                                                    value;
                                                              });
                                                              appThemeColor = Colors
                                                                  .lightBlueAccent;
                                                            },
                                                            title: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                    'Light Blue'),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      color: scheme
                                                                          .secondary,
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  child:
                                                                      const CircleAvatar(
                                                                    radius: 16,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .lightBlueAccent,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )));
                                            }),
                                        label: const Text('Theme'),
                                        icon: const Icon(Icons.color_lens),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 32),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        onPressed: () {
                                          for (var values in box.values) {
                                            print(values);
                                          }
                                        },
                                        label: const Text('Sync'),
                                        icon: const Icon(Icons.sync),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                      'Please sync your data if your previous data is not showing or loading in home tab.'),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: IconButton.outlined(
                                style: IconButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: scheme.error),
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (builder) => AlertDialog(
                                          actionsPadding: const EdgeInsets.only(
                                              right: 16, bottom: 16),
                                          title: const Text('Logout'),
                                          content: const Text(
                                              'Do you really wish to logout?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    navigator!.pop(),
                                                child: const Text('Cancel')),
                                            TextButton(
                                                onPressed: () {
                                                  signin.logout();
                                                  navigator!.pop();
                                                },
                                                child: const Text('Logout'))
                                          ],
                                        )),
                                icon: ListTile(
                                  leading: Icon(
                                    Icons.logout,
                                    color: scheme.error,
                                  ),
                                  title: Text('Logout',
                                      style: TextStyle(color: scheme.error)),
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ))),
    );
  }
}
