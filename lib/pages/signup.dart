// import 'package:emerge_homely/pages/bottomnav.dart';
// import 'package:emerge_homely/pages/login.dart';
// import 'package:emerge_homely/widget/widget_support.dart';

// import 'package:flutter/material.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   String email = "", password = "", name = "";

//   TextEditingController namecontroller = new TextEditingController();

//   TextEditingController passwordcontroller = new TextEditingController();

//   TextEditingController mailcontroller = new TextEditingController();

//   final _formkey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Stack(
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height / 2.5,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFFff5c30), Color(0xFFe74b1a)],
//                 ),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(
//                 top: MediaQuery.of(context).size.height / 3,
//               ),
//               height: MediaQuery.of(context).size.height / 2,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                 ),
//               ),
//               child: Text(""),
//             ),
//             Container(
//               margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
//               child: Column(
//                 children: [
//                   Center(
//                     child: Image.asset(
//                       "assets/images/logo.png",
//                       width: MediaQuery.of(context).size.width / 1.5,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   SizedBox(height: 50.0),
//                   Material(
//                     elevation: 5.0,
//                     borderRadius: BorderRadius.circular(20),
//                     child: Container(
//                       padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height / 1.8,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Form(
//                         key: _formkey,
//                         child: Column(
//                           children: [
//                             SizedBox(height: 30.0),
//                             Text(
//                               "Sign up",
//                               style: AppWidget.HeadlineTextFeildStyle(),
//                             ),
//                             SizedBox(height: 30.0),
//                             TextFormField(
//                               controller: namecontroller,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please Enter Name';
//                                 }
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                 hintText: 'Name',
//                                 hintStyle: AppWidget.semiBoldTextFeildStyle(),
//                                 prefixIcon: Icon(Icons.person_outlined),
//                               ),
//                             ),
//                             SizedBox(height: 30.0),
//                             TextFormField(
//                               controller: mailcontroller,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please Enter E-mail';
//                                 }
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                 hintText: 'Email',
//                                 hintStyle: AppWidget.semiBoldTextFeildStyle(),
//                                 prefixIcon: Icon(Icons.email_outlined),
//                               ),
//                             ),
//                             SizedBox(height: 30.0),
//                             TextFormField(
//                               controller: passwordcontroller,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please Enter Password';
//                                 }
//                                 return null;
//                               },
//                               obscureText: true,
//                               decoration: InputDecoration(
//                                 hintText: 'Password',
//                                 hintStyle: AppWidget.semiBoldTextFeildStyle(),
//                                 prefixIcon: Icon(Icons.password_outlined),
//                               ),
//                             ),
//                             SizedBox(height: 20.0),
//                             GestureDetector(
//                               onTap: () async {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => BottomNav(),
//                                   ),
//                                 );
//                               },
//                               child: Material(
//                                 elevation: 5.0,
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(vertical: 8.0),
//                                   width: 200,
//                                   decoration: BoxDecoration(
//                                     color: Color(0Xffff5722),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       "SIGN UP",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18.0,
//                                         fontFamily: 'Poppins1',
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 70.0),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => LogIn()),
//                       );
//                     },
//                     child: Text(
//                       "Already have an account? Login",
//                       style: AppWidget.semiBoldTextFeildStyle(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emerge_homely/pages/bottomnav.dart';
import 'package:emerge_homely/pages/login.dart';
import 'package:emerge_homely/widget/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _mailController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _mailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _mailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'user',
        'isActive': true,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

      // Navigate to homepage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak. Use at least 6 characters.';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;
    final isMediumScreen = screenWidth > 600 && screenWidth <= 800;

    // Adjust sizes based on screen size
    final padding = isLargeScreen
        ? 20.0
        : isMediumScreen
        ? 16.0
        : 12.0;
    final logoWidth =
        screenWidth /
        (isLargeScreen
            ? 1.5
            : isMediumScreen
            ? 1.8
            : 2.0);
    final formHeight =
        MediaQuery.of(context).size.height / (isLargeScreen ? 1.8 : 2.0);
    final fontSize = isLargeScreen
        ? 18.0
        : isMediumScreen
        ? 16.0
        : 14.0;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            width: screenWidth,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFff5c30), Color(0xFFe74b1a)],
              ),
            ),
          ),
          // White Card Background
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 3,
            ),
            height: MediaQuery.of(context).size.height / 2,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
          ),
          // Content
          Container(
            margin: EdgeInsets.symmetric(horizontal: padding, vertical: 60.0),
            child: Column(
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: logoWidth,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: isLargeScreen ? 50.0 : 30.0),
                // Form Card
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    width: screenWidth,
                    height: formHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: isLargeScreen ? 30.0 : 20.0),
                          Text(
                            "Sign up",
                            style: AppWidget.HeadlineTextFeildStyle().copyWith(
                              fontSize: isLargeScreen
                                  ? 24.0
                                  : isMediumScreen
                                  ? 20.0
                                  : 18.0,
                            ),
                          ),
                          SizedBox(height: isLargeScreen ? 30.0 : 20.0),
                          TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: AppWidget.semiBoldTextFeildStyle(),
                              prefixIcon: const Icon(Icons.person_outlined),
                            ),
                            style: TextStyle(fontSize: fontSize),
                          ),
                          SizedBox(height: isLargeScreen ? 30.0 : 20.0),
                          TextFormField(
                            controller: _mailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Email';
                              } else if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return 'Please Enter a Valid Email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: AppWidget.semiBoldTextFeildStyle(),
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                            style: TextStyle(fontSize: fontSize),
                          ),
                          SizedBox(height: isLargeScreen ? 30.0 : 20.0),
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: AppWidget.semiBoldTextFeildStyle(),
                              prefixIcon: const Icon(Icons.lock_outlined),
                            ),
                            style: TextStyle(fontSize: fontSize),
                          ),
                          SizedBox(height: isLargeScreen ? 20.0 : 15.0),
                          GestureDetector(
                            onTap: _isLoading ? null : _signUp,
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: isLargeScreen ? 10.0 : 8.0,
                                ),
                                width: isLargeScreen ? 250.0 : 200.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFff5722),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.0,
                                        )
                                      : Text(
                                          "SIGN UP",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontFamily: 'Poppins1',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isLargeScreen ? 70.0 : 50.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogIn()),
                    );
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: AppWidget.semiBoldTextFeildStyle().copyWith(
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
