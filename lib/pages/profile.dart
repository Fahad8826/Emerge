// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:emerge_homely/pages/login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Profile extends StatefulWidget {
//   const Profile({super.key});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool _isLoading = true;
//   Map<String, dynamic>? _userData;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//   Future<void> _fetchUserData() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         final userDoc = await _firestore
//             .collection('users')
//             .doc(user.uid)
//             .get();
//         if (userDoc.exists) {
//           setState(() {
//             _userData = userDoc.data();
//             _isLoading = false;
//           });
//         } else {
//           setState(() {
//             _errorMessage = 'User data not found.';
//             _isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           _errorMessage = 'No user is logged in.';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error fetching user data: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _logout() async {
//     try {
//       await _auth.signOut();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LogIn()),
//       );
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Logged out successfully!')));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get screen size using MediaQuery
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isLargeScreen = screenWidth > 800;
//     final isMediumScreen = screenWidth > 600 && screenWidth <= 800;

//     // Adjust sizes based on screen size
//     final padding = isLargeScreen
//         ? 24.0
//         : isMediumScreen
//         ? 16.0
//         : 8.0;
//     final fontSize = isLargeScreen
//         ? 18.0
//         : isMediumScreen
//         ? 16.0
//         : 14.0;
//     final buttonWidth = isLargeScreen
//         ? 250.0
//         : isMediumScreen
//         ? 200.0
//         : 150.0;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Profile',
//           style: TextStyle(
//             fontSize: isLargeScreen
//                 ? 24.0
//                 : isMediumScreen
//                 ? 20.0
//                 : 18.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: const Color(0xFFff5c30),
//         foregroundColor: Colors.white,
//       ),
//       body: _isLoading
//           ? Center(
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
//             )
//           : _errorMessage != null
//           ? Center(
//               child: Text(
//                 _errorMessage!,
//                 style: TextStyle(fontSize: fontSize, color: Colors.red),
//                 textAlign: TextAlign.center,
//               ),
//             )
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.all(padding),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Profile Header
//                     Center(
//                       child: CircleAvatar(
//                         radius: isLargeScreen
//                             ? 60.0
//                             : isMediumScreen
//                             ? 50.0
//                             : 40.0,
//                         backgroundColor: Colors.grey[300],
//                         child: Icon(
//                           Icons.person,
//                           size: isLargeScreen
//                               ? 50.0
//                               : isMediumScreen
//                               ? 40.0
//                               : 30.0,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: isLargeScreen
//                           ? 24.0
//                           : isMediumScreen
//                           ? 16.0
//                           : 8.0,
//                     ),
//                     Center(
//                       child: Text(
//                         _userData?['name'] ?? 'N/A',
//                         style: TextStyle(
//                           fontSize: isLargeScreen
//                               ? 24.0
//                               : isMediumScreen
//                               ? 20.0
//                               : 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: isLargeScreen ? 8.0 : 4.0),
//                     Center(
//                       child: Text(
//                         _userData?['email'] ?? 'N/A',
//                         style: TextStyle(
//                           fontSize: fontSize,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: isLargeScreen
//                           ? 32.0
//                           : isMediumScreen
//                           ? 24.0
//                           : 16.0,
//                     ),

//                     // User Details
//                     Card(
//                       elevation: 4.0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(padding),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'User Details',
//                               style: TextStyle(
//                                 fontSize: fontSize + 2,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: isLargeScreen ? 16.0 : 8.0),
//                             _buildDetailRow(
//                               'Name',
//                               _userData?['name'] ?? 'N/A',
//                               fontSize,
//                             ),
//                             _buildDetailRow(
//                               'Email',
//                               _userData?['email'] ?? 'N/A',
//                               fontSize,
//                             ),
//                             _buildDetailRow(
//                               'Role',
//                               _userData?['role'] ?? 'N/A',
//                               fontSize,
//                             ),
//                             _buildDetailRow(
//                               'Status',
//                               (_userData?['isActive'] ?? false)
//                                   ? 'Active'
//                                   : 'Inactive',
//                               fontSize,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: isLargeScreen
//                           ? 32.0
//                           : isMediumScreen
//                           ? 24.0
//                           : 16.0,
//                     ),

//                     // Logout Button
//                     Center(
//                       child: ElevatedButton(
//                         onPressed: _logout,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFff5722),
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(
//                             horizontal: isLargeScreen
//                                 ? 32.0
//                                 : isMediumScreen
//                                 ? 24.0
//                                 : 16.0,
//                             vertical: isLargeScreen
//                                 ? 16.0
//                                 : isMediumScreen
//                                 ? 12.0
//                                 : 8.0,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           minimumSize: Size(buttonWidth, 0),
//                         ),
//                         child: Text(
//                           'Logout',
//                           style: TextStyle(
//                             fontSize: fontSize,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Poppins1',
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, double fontSize) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             '$label:',
//             style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
//           ),
//           Flexible(
//             child: Text(
//               value,
//               style: TextStyle(fontSize: fontSize, color: Colors.grey[800]),
//               textAlign: TextAlign.right,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emerge_homely/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    // Initialize animation controller for button
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            _userData = userDoc.data();
            _isLoading = false;
            _errorMessage = null;
          });
        } else {
          setState(() {
            _errorMessage = 'User data not found.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'No user is logged in.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching user data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFff5722)),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logged out successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
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
        ? 24.0
        : isMediumScreen
        ? 16.0
        : 8.0;
    final fontSize = isLargeScreen
        ? 18.0
        : isMediumScreen
        ? 16.0
        : 14.0;
    final avatarRadius = isLargeScreen
        ? 60.0
        : isMediumScreen
        ? 50.0
        : 40.0;
    final buttonWidth = isLargeScreen
        ? 250.0
        : isMediumScreen
        ? 200.0
        : 150.0;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Header
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFff5c30), Color(0xFFe74b1a)],
              ),
            ),
          ),
          // Main Content
          Column(
            children: [
              // AppBar (Transparent)
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: isLargeScreen
                        ? 24.0
                        : isMediumScreen
                        ? 20.0
                        : 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: fontSize + 4,
                      color: Colors.white,
                    ),
                    onPressed: _fetchUserData,
                    tooltip: 'Refresh Profile',
                  ),
                ],
              ),
              // Content Card
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: avatarRadius),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isLargeScreen ? 40.0 : 30.0),
                      topRight: Radius.circular(isLargeScreen ? 40.0 : 30.0),
                    ),
                  ),
                  child: _isLoading
                      ? Center(
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
                        )
                      : _errorMessage != null
                      ? Center(
                          child: Card(
                            margin: EdgeInsets.all(padding * 2),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: isLargeScreen
                                        ? 48.0
                                        : isMediumScreen
                                        ? 40.0
                                        : 32.0,
                                    color: Colors.red,
                                  ),
                                  SizedBox(height: padding),
                                  Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: padding),
                                  ElevatedButton(
                                    onPressed: _fetchUserData,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFff5722),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(fontSize: fontSize - 2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              // Profile Avatar
                              Transform.translate(
                                offset: Offset(0, -avatarRadius),
                                child: CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: avatarRadius - 4,
                                    backgroundColor: Colors.grey[300],
                                    child: Icon(
                                      Icons.person,
                                      size: avatarRadius * 0.8,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                              // User Info
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: padding,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _userData?['name'] ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: isLargeScreen
                                            ? 24.0
                                            : isMediumScreen
                                            ? 20.0
                                            : 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: padding / 2),
                                    Text(
                                      _userData?['email'] ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: padding * 2),
                                    // Details Card
                                    Card(
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(padding),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'User Details',
                                              style: TextStyle(
                                                fontSize: fontSize + 2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: padding),
                                            _buildDetailTile(
                                              icon: Icons.person_outline,
                                              label: 'Name',
                                              value:
                                                  _userData?['name'] ?? 'N/A',
                                              fontSize: fontSize,
                                            ),
                                            _buildDetailTile(
                                              icon: Icons.email_outlined,
                                              label: 'Email',
                                              value:
                                                  _userData?['email'] ?? 'N/A',
                                              fontSize: fontSize,
                                            ),
                                            _buildDetailTile(
                                              icon: Icons.badge_outlined,
                                              label: 'Role',
                                              value:
                                                  _userData?['role'] ?? 'N/A',
                                              fontSize: fontSize,
                                            ),
                                            _buildDetailTile(
                                              icon: Icons.check_circle_outline,
                                              label: 'Status',
                                              value:
                                                  (_userData?['isActive'] ??
                                                      false)
                                                  ? 'Active'
                                                  : 'Inactive',
                                              fontSize: fontSize,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: padding * 2),
                                    // Logout Button
                                    Center(
                                      child: GestureDetector(
                                        onTapDown: (_) =>
                                            _animationController.forward(),
                                        onTapUp: (_) =>
                                            _animationController.reverse(),
                                        onTapCancel: () =>
                                            _animationController.reverse(),
                                        onTap: _logout,
                                        child: ScaleTransition(
                                          scale: _buttonAnimation,
                                          child: Container(
                                            width: buttonWidth,
                                            padding: EdgeInsets.symmetric(
                                              vertical: isLargeScreen
                                                  ? 16.0
                                                  : isMediumScreen
                                                  ? 12.0
                                                  : 8.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFff5722),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 8.0,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              'Logout',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontFamily: 'Poppins1',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: padding * 2),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
    required double fontSize,
  }) {
    return ListTile(
      leading: Icon(icon, size: fontSize + 4, color: const Color(0xFFff5722)),
      title: Text(
        label,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: fontSize - 2, color: Colors.grey[800]),
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
