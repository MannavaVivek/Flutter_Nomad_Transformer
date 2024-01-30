import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'content_classes.dart';

class UserPage extends StatefulWidget {
  final Isar isar;

  const UserPage({Key? key, required this.isar}) : super(key: key);

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String confirmPassword = '';
  String errorMessage = '';

  bool _isLogin = true; // Flag to switch between login and sign-up

  // Helper methods for toggling between login and sign-up
  void _toggleLogin() {
    setState(() {
      _isLogin = true;
    });
  }

  void _toggleSignUp() {
    setState(() {
      _isLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;

    return Scaffold(
      body: user == null
          ? _buildGuestView(context)
          : _buildUserView(context, MediaQuery.of(context).size),
    );
  }

  Widget _buildUserView(BuildContext context, Size constraints) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 100),
          const CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage('assets/programmer.png'),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 8),
          Text(
            "You are logged in as \n${auth.currentUser!.email}",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildActionContainer(context),
          const SizedBox(height: 100),
          const Text('Ver. 0.0.7'),
          _buildSignOutButton(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildActionContainer(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () => _showDialog(context, 'Help',
                    'You click on blog posts to read them. If you like em, click on the heart icon to favorite them. You can view your favorites by clicking on the heart icon on the bottom navigation bar. You can alo search for blog posts by clicking on the search icon on the bottom navigation bar.'),
                child: const Text('Help')),
            _customDivider(),
            TextButton(
                onPressed: () => _showDialog(context, 'Report',
                    'If you have this app, you probably know me, so just let me know.'),
                child: const Text('Report')),
            _customDivider(),
            TextButton(
                onPressed: () => _showDialog(context, 'About',
                    'For now, this is a project for fun, and for me to learn Flutter. I hope you enjoy it!'),
                child: const Text('About')),
          ],
        ),
      ),
    );
  }

  Widget _customDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color.fromARGB(163, 221, 220, 220),
            Colors.transparent
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CircleAvatar(
                  radius: 75,
                  backgroundImage: AssetImage('assets/user_image.png'),
                ),
                const SizedBox(height: 16),
                _isLogin ? _buildLoginForm() : _buildSignUpForm(),
                TextButton(
                  onPressed: _isLogin ? _toggleSignUp : _toggleLogin,
                  child: Text(_isLogin
                      ? 'New to the app? Register'
                      : 'Already signed up? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => email = value,
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
          obscureText: true,
          onChanged: (value) => password = value,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => _loginUser(email, password),
          child: const Text('Login'),
        ),
        // TODO: Add forgot password functionality
      ],
    );
  }

  Widget _buildSignOutButton() {
    return ElevatedButton(
      onPressed: _signOut,
      child: const Text('Sign Out'),
    );
  }

  Future<void> _signOut() async {
    try {
      await auth.signOut();
      email = '';
      password = '';
      confirmPassword = '';
      errorMessage = '';
      setState(() {}); // Refresh UI after sign out
    } catch (e) {
      _handleSignOutError(e);
    }
  }

  void _handleSignOutError(dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to sign out: ${error.toString()}')),
    );
  }

  Future<void> _loginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      setState(() {}); // Update UI for logged in user view

      // Fetch user favorites and update local database if login is successful
      await _updateUserFavorites();
    } catch (e) {
      _handleLoginError(e);
    }
  }

  Future<void> _updateUserFavorites() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('UserFavorites')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          List<String> favBlogPosts =
              List<String>.from(snapshot['favBlogPosts'] ?? []);
          UserFavorites userFavorites =
              UserFavorites(userId: user.uid, favBlogPosts: favBlogPosts);

          // Write to Isar database
          await widget.isar.writeTxn(() async {
            await widget.isar.userFavorites.put(userFavorites);
          });
        }
      }
    } catch (e) {
      // Handle any errors here
    }
  }

  void _handleLoginError(dynamic error) {
    String errorMessage;

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'invalid-email':
          errorMessage = 'Invalid email. Please try again.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'user-disabled':
          errorMessage = 'User is disabled. Please contact support.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials. Please try again.';
          break;
        case 'too-many-requests':
          errorMessage =
              'Too many requests. Please wait a while before trying again.';
          break;
        default:
          errorMessage = 'An error occurred during login. Please try again.';
      }
    } else {
      errorMessage = 'An unknown error occurred.';
    }

    // Display the error message using the current BuildContext
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: <Widget>[
        if (errorMessage.isNotEmpty)
          Text(errorMessage, style: const TextStyle(color: Colors.red)),
        TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            email = value;
          },
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          obscureText: true,
          onChanged: (value) {
            password = value;
          },
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          obscureText: true,
          onChanged: (value) {
            confirmPassword = value;
          },
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _signUpUser,
          child: const Text('Sign Up'),
        ),
      ],
    );
  }

  Future<void> _signUpUser() async {
    // Clear previous error message
    setState(() {
      errorMessage = '';
    });

    // Validation
    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      setState(() => errorMessage = 'Invalid email format');
      return;
    }
    if (password.isEmpty || password.length < 8) {
      setState(() => errorMessage = 'Password must be at least 8 characters');
      return;
    }
    if (confirmPassword.isEmpty || password != confirmPassword) {
      setState(() => errorMessage = 'Passwords do not match');
      return;
    }

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // Handle successful sign up, such as navigating to another page
      setState(() {}); // Update UI for logged in user view
    } catch (e) {
      if (e is FirebaseAuthException) {
        setState(() {
          errorMessage = e.code == 'email-already-in-use'
              ? 'User email already exists'
              : 'Failed to create user: ${e.message}';
        });
      } else {
        setState(() {
          errorMessage = 'An unknown error occurred';
        });
      }
    }
  }
}
