import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'hive_service.dart';
import 'user_provider.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController quoteController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential?> registerWithFirebase() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
      );

      await FirebaseFirestore.instance.collection('user_data_personal').doc(userCredential.user?.uid).set({
        'username': usernameController.text,
        'quote': quoteController.text,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _setUserDataToHive(String userId, String username, String quote) async {
    HiveService.setUsername(username);
    HiveService.setQuote(quote);
    HiveService.setUserId(userId);
    HiveService.setLikedPosts([]);
  }

  Future<void> _showGoogleRegisterDialog(BuildContext context, UserCredential userCredential) async {
    TextEditingController usernameController = TextEditingController();
    TextEditingController quoteController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please provide additional information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: quoteController,
                  maxLength: 200,
                  decoration: InputDecoration(
                    labelText: 'Quote (max 200 characters)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                if (usernameController.text.isNotEmpty && quoteController.text.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('user_data_personal').doc(userCredential.user?.uid).set({
                    'username': usernameController.text,
                    'quote': quoteController.text,
                  });

                  await _setUserDataToHive(userCredential.user!.uid, usernameController.text, quoteController.text);

                  Navigator.of(context).pop();
                  GoRouter.of(context).go('/user');
                }
              },
            ),
          ],
        );
      },
    );
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
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
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: quoteController,
                maxLength: 200,
                decoration: InputDecoration(
                  labelText: 'Quote (max 200 characters)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            Container(
              width: 150,
              child: ElevatedButton(
                onPressed: () async {
                  if(passwordController.text == confirmPassController.text) {
                    UserCredential? user = await registerWithFirebase();
                    if(user != null){
                      await _setUserDataToHive(user.user!.uid, usernameController.text, quoteController.text);
                      GoRouter.of(context).go('/user');
                    }
                  } else {
                    print("The passwords do not match.");
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
                label: Text('Register with Google',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  ),
                onPressed: () async {
                  UserCredential? user = await signInWithGoogle();
                  if(user != null){
                    _showGoogleRegisterDialog(context, user);
                  }
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
                GoRouter.of(context).push('/login');
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
