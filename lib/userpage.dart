import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';

class UserPage extends StatefulWidget {
  final Isar isar;

  UserPage({Key? key, required this.isar}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("User Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image in the center within a circle
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/user_image.png'), // Replace with your asset image
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 16),
            // Text indicating user status
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  user == null
                      ? 'Currently using as Guest'
                      : 'Currently logged in as',
                  textAlign: TextAlign.center,
                ),
                if (user != null)
                  Text(
                    user.email ?? '', // Safely handle null email
                    textAlign: TextAlign.center,
                  ),
              ],
            ),

            const SizedBox(height: 16),
            // Login or Sign out button
            user == null
                ? _buildLoginButton(context)
                : _buildSignOutButton(context),

            user == null ? _buildSignUpLink(context) : Container(),
          ],
        ),
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
    String _email = '';
    String _password = '';
    String _confirmPassword = '';
    String _errorMessage = '';

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
                  _errorMessage.isNotEmpty
                      ? Text(_errorMessage,
                          style: const TextStyle(color: Colors.red))
                      : Container(),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: _email.isNotEmpty &&
                              !RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(_email)
                          ? 'Invalid email format'
                          : null,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: _password.isNotEmpty && _password.length < 8
                          ? 'Password must be at least 8 characters'
                          : null,
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      errorText: _confirmPassword.isNotEmpty &&
                              _password != _confirmPassword
                          ? 'Passwords do not match'
                          : null,
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      _confirmPassword = value;
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
                  if (_email.isEmpty ||
                      _password.isEmpty ||
                      _confirmPassword.isEmpty ||
                      _password.length < 8 ||
                      _password != _confirmPassword ||
                      !RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(_email)) {
                    _errorMessage = 'Please fill in all fields correctly';
                  } else {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _email, password: _password);

                      Navigator.of(context).pop(true);
                    } catch (e) {
                      if (e is FirebaseAuthException) {
                        if (e.code == 'email-already-in-use') {
                          _errorMessage = 'User email already exists';
                        } else {
                          _errorMessage = 'Failed to create user: ${e.message}';
                        }
                      } else {
                        _errorMessage = 'An unknown error occurred';
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

  Future<void> _createUser(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pop(); // Close the dialog
      setState(() {}); // Update UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create user: $e')),
      );
    }
  }
}
