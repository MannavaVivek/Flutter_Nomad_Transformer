import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';

class UserPage extends StatefulWidget {
  final Isar isar;

  const UserPage({Key? key, required this.isar}) : super(key: key);

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';

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
          _buildSignOutButton(context),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircleAvatar(
            radius: 75,
            backgroundImage: AssetImage('assets/user_image.png'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Currently using as Guest',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildLoginButton(context),
          _buildSignUpLink(context),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showLoginDialog(context),
      child: const Text('Login'),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _signOut(context),
      child: const Text('Sign Out'),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return TextButton(
      onPressed: () async {
        bool signUpSuccessful = await _showSignUpDialog(context);
        if (signUpSuccessful) {
          setState(() {});
        }
      },
      child: const Text('Sign Up'),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await auth.signOut();
      setState(() {}); // Refresh UI after sign out
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out: $e')),
      );
    }
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Set to true if you want the dialog to be dismissible
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    _password = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Login'),
              onPressed: () {
                _loginUser(_email, _password, context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loginUser(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pop(); // Close the dialog
      setState(() {}); // Update UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login: $e')),
      );
    }
  }

  Future<bool> _showSignUpDialog(BuildContext context) async {
    String email = '';
    String password = '';
    String confirmPassword = '';
    String errorMessage = '';

    bool signUpSuccessful = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Sign Up'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  errorMessage.isNotEmpty
                      ? Text(errorMessage,
                          style: const TextStyle(color: Colors.red))
                      : Container(),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: email.isNotEmpty &&
                              !RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(email)
                          ? 'Invalid email format'
                          : null,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: password.isNotEmpty && password.length < 8
                          ? 'Password must be at least 8 characters'
                          : null,
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      errorText: confirmPassword.isNotEmpty &&
                              password != confirmPassword
                          ? 'Passwords do not match'
                          : null,
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Sign Up'),
                onPressed: () async {
                  if (email.isEmpty ||
                      password.isEmpty ||
                      confirmPassword.isEmpty ||
                      password.length < 8 ||
                      password != confirmPassword ||
                      !RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(email)) {
                    errorMessage = 'Please fill in all fields correctly';
                  } else {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);

                      Navigator.of(context).pop(true);
                    } catch (e) {
                      if (e is FirebaseAuthException) {
                        if (e.code == 'email-already-in-use') {
                          errorMessage = 'User email already exists';
                        } else {
                          errorMessage = 'Failed to create user: ${e.message}';
                        }
                      } else {
                        errorMessage = 'An unknown error occurred';
                      }
                      setState(() {}); // Update UI
                    }
                  }
                },
              ),
            ],
          );
        });
      },
    );
    return signUpSuccessful;
  }
}
