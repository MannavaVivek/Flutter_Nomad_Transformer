// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'hive_service.dart';
import 'user_provider.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController quoteController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  
  final _formKey = GlobalKey<FormState>();

  Future<UserCredential?> registerWithFirebase(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text
      );

      await FirebaseFirestore.instance.collection('user_data_personal').doc(userCredential.user?.uid).set({
        'username': usernameController.text.trim(),
        'quote': quoteController.text,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The account already exists for that email.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The password provided is too weak.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<void> _setUserDataToHive(BuildContext context,  String username, String quote) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    print("Current user: ${currentUser?.uid}");
    Provider.of<UserProvider>(context, listen: false).setUser("${currentUser?.uid}");
    HiveService.setUsername(username);
    HiveService.setQuote(quote);
    HiveService.setLikedPosts([]);
  }

  Future<List<String>> fetchAvatarsFromFirebase() async {
  List<String> avatarUrls = [];
  final ListResult result = await FirebaseStorage.instance.ref('avatars').listAll();
  for (var itemRef in result.items) {
    final String url = await itemRef.getDownloadURL();
    avatarUrls.add(url);
  }
  return avatarUrls;
}


  Future<void> showAvatarSelectionDialog(BuildContext context, UserCredential user) async {
    print("showAvatarSelectionDialog-----------------------------------------------------");
    List<String> avatarUrls = await fetchAvatarsFromFirebase();
    await showDialog(
      context: context,
      builder: (context) {
        String? selectedAvatarUrl;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Choose your avatar'),
              content: Container(
                width: double.maxFinite,
                child: GridView.count(
                  crossAxisCount: 3, // adjust to your need
                  children: avatarUrls.map((url) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvatarUrl = url;
                        });
                      },
                      child: GridTile(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: url == selectedAvatarUrl ? Colors.green : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Image.network(url),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () async {
                    if (selectedAvatarUrl != null) {
                      await _setUserAvatar(context, user, selectedAvatarUrl!);
                      GoRouter.of(context).pushReplacement('/user');
                    }
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }



  Future<void> _setUserAvatar(BuildContext context, UserCredential user, String avatarUrl) async {
    // Update Firestore
    print("setUserAvatar-----------------------------------------------------");
    await FirebaseFirestore.instance.collection('user_data_personal').doc(user.user?.uid).update({
      'avatar': avatarUrl,
    });

    // Update Provider
    Provider.of<UserProvider>(context, listen: false).setAvatar(avatarUrl);

    // Update Hive
    HiveService.setAvatar(avatarUrl);
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: screenWidth > 700
          ? ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: registerCard(context),
            )
          : registerCard(context),
      ),
    );
  }

  Widget registerCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8.0,
      shadowColor: Colors.black38,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Image.asset(
                'assets/images/undraw_adventure.png',
                height: 400,
                width: 400,
                fit: BoxFit.contain,
              ),
              Text(
                'Register',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password should be at least 6 characters';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: confirmPassController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: quoteController,
                  decoration: InputDecoration(
                    labelText: 'Favorite Quote',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your favorite quote';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      UserCredential? user = await registerWithFirebase(context);
                      if(user != null){
                        await _setUserDataToHive(context, usernameController.text, quoteController.text);
                        await showAvatarSelectionDialog(context, user);
                        // GoRouter.of(context).pushReplacement('/user');
                      }
                    }
                  },
                  child: Text('Register'),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
            Row(
              children: <Widget>[
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("or"),
                ),
                Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            Container(
              width: 150,
              child: ElevatedButton.icon(
                icon: SvgPicture.asset('assets/images/google_icon.svg', height: 24.0, width: 24.0),
                label: Text('Sign in with Google',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Notice'),
                      content: Text('Google sign in is not available until the app is published. Please use the email option.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Dismiss the dialog
                            // Perform additional actions if needed
                          },
                        ),
                      ],
                    ),
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                GoRouter.of(context).pushReplacement('/signin');
              },
              child: Text('Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    )
  );
  }
}
