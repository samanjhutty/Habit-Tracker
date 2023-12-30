import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String user = 'Guest';

  @override
  void initState() {
    user = auth.currentUser?.displayName ?? 'Guest';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      child: Scaffold(
          appBar: AppBar(
              title: Text(
            'Greetings $user!',
            style: const TextStyle(fontWeight: FontWeight.w600),
          )),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: auth.currentUser == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                    'Sign in to display profile data, and store your data to cloud'),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: scheme.primary,
                                        foregroundColor: scheme.onPrimary),
                                    onPressed: () => Get.toNamed('/signin'),
                                    icon: const Icon(Icons.login),
                                    label: const Text('Sign In to continue'))
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
                              backgroundImage:
                                  NetworkImage(auth.currentUser!.photoURL!),
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
                      )
                    ],
                  ),
          )),
    );
  }
}
