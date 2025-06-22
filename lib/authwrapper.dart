import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emerge_homely/pages/bottomnav.dart';
import 'package:emerge_homely/pages/loginpage.dart' show LogIn;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? _currentUser;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  void _initializeAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
    });
  }

  Future<Widget> _buildAuthenticatedWidget() async {
    if (_currentUser == null) {
      return const LogIn();
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          _showError('User data not found. Please log in again.');
        }
        return const LogIn();
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final String role = userData['role'] ?? 'unknown';
      final bool isActive = userData['isActive'] ?? false;

      if (role == 'user' && isActive) {
        return const BottomNav();
      } else {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          _showError(
            role != 'user'
                ? 'Access denied: Invalid user role.'
                : 'Access denied: Account is inactive.',
          );
        }
        return const LogIn();
      }
    } catch (e) {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        _showError('Authentication error. Please try again.');
      }
      return const LogIn();
    }
  }

  void _showError(String message) {
    setState(() {
      _hasError = true;
      _errorMessage = message;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFFF44336),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;
    final isMediumScreen = screenWidth > 600 && screenWidth <= 800;

    // Show loading screen
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: isLargeScreen
                ? 4.0
                : isMediumScreen
                ? 3.0
                : 2.0,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFff5722)),
          ),
        ),
      );
    }

    // If there's an error or no user, show login
    if (_hasError || _currentUser == null) {
      return const LogIn();
    }

    // For authenticated users, use FutureBuilder only once
    return FutureBuilder<Widget>(
      future: _buildAuthenticatedWidget(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: isLargeScreen
                    ? 4.0
                    : isMediumScreen
                    ? 3.0
                    : 2.0,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFff5722),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const LogIn();
        }

        return snapshot.data ?? const LogIn();
      },
    );
  }
}
