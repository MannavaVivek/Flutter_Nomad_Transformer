import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'hive_service.dart';
import 'user_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String _username = '';
  String _quote = "Do I wake up every morning and ask you for Coffee Coffee Cream Cream?";
  
  Future<UserCredential?> signInWithFirebase() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
      );
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
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


  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null; 

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

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
              child: loginCard(context),
            )
          : loginCard(context),
      ),
    );
  }


  Widget loginCard(BuildContext context) {
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
              'assets/images/undraw_explore.png',
              height: 400,
              width: 400,
              fit: BoxFit.contain, // Makes the image fit within the box
            ),
            Text(
              'Login',
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
            Container(
              width: 150,
              child: ElevatedButton(
                onPressed: () async {
                  UserCredential? user = await signInWithFirebase();
                  if(user != null){
                    await _getCurrentUser(context);
                    GoRouter.of(context).go('/user');
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
                  UserCredential? user = await signInWithGoogle();
                  if(user != null){
                    await _getCurrentUser(context);
                    GoRouter.of(context).go('/user');
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
                GoRouter.of(context).push('/register');
              },
              child: Text('New to the app? Register'),
            ),
          ],
        ),
      ),
    );
  }
}