import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'hive_service.dart';
import 'user_provider.dart';

class SigninScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String _username = '';
  String _quote = "Do I wake up every morning and ask you for Coffee Coffee Cream Cream?";

  final _formKey = GlobalKey<FormState>();
  
  Future<UserCredential?> signInWithFirebase(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text
      );
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user found for that email.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong password provided for that user.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<void> _getCurrentUser(BuildContext context) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Provider.of<UserProvider>(context, listen: false).setUser("${currentUser.uid}");
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('user_data_personal')
          .doc(currentUser.uid)
          .get();
      if (userData.exists) {
        _username = userData['username'];
        _quote = userData['quote'];
        HiveService.setAvatar(userData['avatar']);
        HiveService.setUsername(_username);
        HiveService.setQuote(_quote);
      }
      final querySnapshot = await FirebaseFirestore.instance
        .collection('user_data_personal')
        .doc(currentUser.uid)
        .collection('posts')
        .get();
      final likedPostIds = querySnapshot.docs.map((doc) => doc.id).toList();
      HiveService.setLikedPosts(likedPostIds);
    }
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
              child: signinCard(context),
            )
          : signinCard(context),
      ),
    );
  }

  Widget signinCard(BuildContext context) {
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
                'assets/images/undraw_explore.png',
                height: 400,
                width: 400,
                fit: BoxFit.contain, // Makes the image fit within the box
              ),
              Text(
                'Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Padding( // Adds space between the TextFormField widgets
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email ID',
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
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  String email = emailController.text.trim();
                  if (email.isNotEmpty && email.contains('@')) {
                    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("A password reset link has been sent to your email")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter a valid email address")),
                    );
                  }
                },
                child: Text('Forgot password?'),
              ),
              Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      UserCredential? user = await signInWithFirebase(context);
                      if(user != null){
                        await _getCurrentUser(context);
                        GoRouter.of(context).pushReplacement('/user');
                      }
                    }
                  },
                  child: Text('Sign In'),
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
                      title: Text('Notice!'),
                      content: Text('Google Sign In is currently unavailable. Please use Email ID to signin.'),
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
                GoRouter.of(context).pushReplacement('/register');
              },
              child: Text('New to the app? Register'),
            ),
          ],
        ),
      ),
    )
  );
  }
}