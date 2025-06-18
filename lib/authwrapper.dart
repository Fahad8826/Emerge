// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emerge_homely/pages/bottomnav.dart';
// import 'package:emerge_homely/pages/login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Get screen size using MediaQuery for responsive loading indicator
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isLargeScreen = screenWidth > 800;
//     final isMediumScreen = screenWidth > 600 && screenWidth <= 800;

//     // Adjust loading indicator size
//     final loaderSize = isLargeScreen
//         ? 40.0
//         : isMediumScreen
//         ? 32.0
//         : 24.0;

//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // Handle connection state
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(
//                 strokeWidth: isLargeScreen
//                     ? 4.0
//                     : isMediumScreen
//                     ? 3.0
//                     : 2.0,
//                 valueColor: const AlwaysStoppedAnimation<Color>(
//                   Color(0xFFff5722),
//                 ),
//               ),
//             ),
//           );
//         }

//         // Check if user is logged in
//         if (snapshot.hasData && snapshot.data != null) {
//           // User is logged in, check Firestore for role and isActive
//           return FutureBuilder<DocumentSnapshot>(
//             future: FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(snapshot.data!.uid)
//                 .get(),
//             builder: (context, userSnapshot) {
//               if (userSnapshot.connectionState == ConnectionState.waiting) {
//                 return Scaffold(
//                   body: Center(
//                     child: CircularProgressIndicator(
//                       strokeWidth: isLargeScreen
//                           ? 4.0
//                           : isMediumScreen
//                           ? 3.0
//                           : 2.0,
//                       valueColor: const AlwaysStoppedAnimation<Color>(
//                         Color(0xFFff5722),
//                       ),
//                     ),
//                   ),
//                 );
//               }

//               if (userSnapshot.hasError ||
//                   !userSnapshot.hasData ||
//                   !userSnapshot.data!.exists) {
//                 // Error or no user data, show login page
//                 FirebaseAuth.instance
//                     .signOut(); // Optional: Sign out if data is missing
//                 return const LogIn();
//               }

//               final userData =
//                   userSnapshot.data!.data() as Map<String, dynamic>;
//               final String role = userData['role'] ?? 'unknown';
//               final bool isActive = userData['isActive'] ?? false;

//               // Check role and isActive status
//               if (role == 'user' && isActive) {
//                 return const BottomNav();
//               } else {
//                 // Invalid role or inactive, sign out and show login page
//                 FirebaseAuth.instance.signOut();
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         role != 'user'
//                             ? 'Access denied: Invalid user role.'
//                             : 'Access denied: Account is inactive.',
//                       ),
//                     ),
//                   );
//                 });
//                 return const LogIn();
//               }
//             },
//           );
//         }

//         // User is not logged in, show login page
//         return const LogIn();
//       },
//     );
//   }
// }
import 'package:emerge_homely/pages/bottomnav.dart';
import 'package:emerge_homely/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery for responsive loading indicator
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;
    final isMediumScreen = screenWidth > 600 && screenWidth <= 800;

    // Adjust loading indicator size
    final loaderSize = isLargeScreen
        ? 40.0
        : isMediumScreen
        ? 32.0
        : 24.0;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Handle connection state
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

        // Check if user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return const BottomNav();
        }

        // User is not logged in, show login page
        return const LogIn();
      },
    );
  }
}
