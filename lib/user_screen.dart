import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:google_fonts/google_fonts.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String _username = ''; // Define the username variable
  String email = ''; // Define the email variable
  String password = ''; // Define the password variable

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _getCurrentUser();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> _getCurrentUser() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        _user = currentUser;
      });

      // Fetch the username from the Firestore collection
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('user_data_personal')
          .doc(currentUser.uid)
          .get();
      if (userData.exists) {
        setState(() {
          _username = userData['username'];
        });
      }
    }
  }

void _signIn() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      bool isNewUser = false;
      String email = '';
      String password = '';
      String username = '';
      String quote = ''; // Add the quote variable
      String confirmPassword = '';
      String errorMessage = '';

      // Create TextEditingController instances for the text fields
      TextEditingController usernameController = TextEditingController();
      TextEditingController emailController = TextEditingController();
      TextEditingController passwordController = TextEditingController();
      TextEditingController confirmPasswordController = TextEditingController();
      TextEditingController quoteController = TextEditingController();

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Widget dialogContent;

          if (isNewUser) {
            dialogContent = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  onChanged: (value) {
                    setState(() {
                      username = value.trim(); // Trim the username
                    });
                  },
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      email = value.trim(); // Trim the email
                    });
                  },
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  onChanged: (value) {
                    setState(() {
                      password = value; // No need to trim the password
                    });
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: confirmPasswordController,
                  onChanged: (value) {
                    setState(() {
                      confirmPassword = value; // No need to trim the confirm password
                    });
                  },
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: quoteController,
                  onChanged: (value) {
                    setState(() {
                      quote = value.trim(); // Trim the quote
                    });
                  },
                  maxLength: 150, // Limit the quote field to 200 characters
                  decoration: InputDecoration(
                    labelText: 'If you had one last thing to say to the world, what would it be?',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isNewUser = false;
                      errorMessage = '';
                      usernameController.clear(); // Clear the username field
                      passwordController.clear(); // Clear the password field
                      confirmPasswordController.clear(); // Clear the confirm password field
                      quoteController.clear(); // Clear the quote field
                    });
                  },
                  child: Text('Already registered? Log in'),
                ),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            );
          } else {
            dialogContent = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      email = value; // No need to trim the email
                    });
                  },
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  onChanged: (value) {
                    setState(() {
                      password = value; // No need to trim the password
                    });
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isNewUser = true;
                      errorMessage = '';
                      usernameController.clear(); // Clear the username field
                      passwordController.clear(); // Clear the password field
                      confirmPasswordController.clear(); // Clear the confirm password field
                      quoteController.clear(); // Clear the quote field
                    });
                  },
                  child: Text('New to the app?'),
                ),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            );
          }

          return AlertDialog(
            title: Text('Sign In'),
            content: SingleChildScrollView(child: dialogContent),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (isNewUser) {
                    // Perform sign up logic using username, email, password, and quote
                    if (password != confirmPassword) {
                      setState(() {
                        errorMessage = 'Passwords do not match';
                      });
                      return;
                    }

                    if (password.isEmpty) {
                      setState(() {
                        errorMessage = 'Please enter a password';
                      });
                      return;
                    }
                    try {
                      UserCredential userCredential =
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email.trim(),
                        password: password,
                      );
                      User? user = userCredential.user;
                      if (user != null) {
                        // User signed up successfully, perform necessary actions
                        setState(() {
                          errorMessage = '';
                        });
                        // Save the additional quote field to the user's profile
                        FirebaseFirestore.instance
                            .collection('user_data_personal')
                            .doc(user.uid)
                            .set({
                          'username': username.trim(),
                          'quote': quote,
                        });
                        print('User signed up successfully');
                        Navigator.of(context).pop();
                        _getCurrentUser();
                      } else {
                        // Unable to sign up user, show error message
                        setState(() {
                          errorMessage = 'Unable to sign up user';
                        });
                        print('Unable to sign up user');
                        //TODO: deal with this error
                      }
                    } catch (e) {
                      // Handle sign-up errors
                      setState(() {
                        errorMessage = e.toString();
                      });
                      print('Sign-up error: $e');
                      //TODO: deal with this error
                    }
                  } else {
                    // Perform sign in logic using email and password
                    try {
                      UserCredential userCredential =
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email.trim(),
                        password: password,
                      );
                      User? user = userCredential.user;
                      if (user != null) {
                        // User signed in successfully, perform necessary actions
                        setState(() {
                          errorMessage = '';
                        });
                        print('User signed in successfully');
                        Navigator.of(context).pop();
                        _getCurrentUser(); // Refresh the user state
                      } else {
                        // Unable to sign in user, show error message
                        setState(() {
                          errorMessage = 'Unable to sign in user';
                        });
                        print('Unable to sign in user');
                        //TODO: deal with this error
                      }
                    } catch (e) {
                      // Handle sign-in errors
                      setState(() {
                        errorMessage = e.toString();
                      });
                      print('Sign-in error: $e');
                      // TODO: deal with this error
                    }
                  }
                },
                child: Text('Sign In'),
              ),
            ],
          );
        },
      );
    },
  );
}



  void _signOut() async {
    try {
      await _auth.signOut();
      setState(() {
        _user = null;
      });
    } catch (e) {
      print('Failed to sign out: $e');
    }
  }

  Widget buildButton(String label, void Function()? onPressed) {
    return Container(
      width: double.infinity,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _user != null ? Colors.red : Colors.green,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/wakanda_unsplash.jpg'),
                //TODO: add functionallity so that the user can change their profile picture
              ),
              SizedBox(height: 20),
              if (_user != null)
                Text(
                  'Hello $_username', // Display the username
                  style: TextStyle(fontSize: 24),
                ),
              SizedBox(height: 20),
              Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "“",
                        style: GoogleFonts.satisfy(fontSize: 36),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: _user != null
                          ? StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('user_data_personal')
                                  .doc(_user!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(fontSize: 18),
                                  );
                                }

                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                String quote = snapshot.data?.get('quote') ?? '';
                                return Text(
                                  quote.isNotEmpty ? quote : 'Default Quote',
                                  style: GoogleFonts.satisfy(fontSize: 18),
                                );
                              },
                            )
                          : Text(
                              "Do I wake up every morning and ask you for Coffee Coffee Cream Cream?",
                              style: GoogleFonts.satisfy(fontSize: 18),
                            ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "”",
                        style: GoogleFonts.satisfy(fontSize: 36),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_user != null)
                      Text(_user!.displayName ?? ''),
                    if (_user == null)
                      buildButton('Sign In', _signIn),
                    if (_user != null)
                      buildButton('Sign Out', _signOut),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  context.go('/');
                });
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "HOME",
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push('/search');
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "SEARCH",
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context.go('/favorites');
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "LIKE/STAR",
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  // Do something for the user page
                });
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 34,
                    width: 34,
                    child: RiveAnimation.asset(
                      'assets/RiveAssets/icons.riv',
                      artboard: "USER",
                    ),
                  ),
                  Container(
                    height: 2,
                    width: 34,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
