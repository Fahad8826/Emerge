// // import 'package:emerge_homely/pages/details.dart';
// // import 'package:emerge_homely/pages/wallet.dart';
// // import 'package:emerge_homely/widget/widget_support.dart';
// // import 'package:flutter/material.dart';

// // class Home extends StatefulWidget {
// //   const Home({super.key});

// //   @override
// //   State<Home> createState() => _HomeState();
// // }

// // class _HomeState extends State<Home> {
// //   bool icecream = false, pizza = false, salad = false, burger = false;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         child: Container(
// //           margin: EdgeInsets.only(top: 50.0, left: 20.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text("Hello Shivam,", style: AppWidget.boldTextFeildStyle()),
// //                   Container(
// //                     margin: EdgeInsets.only(right: 20.0),
// //                     padding: EdgeInsets.all(3),
// //                     decoration: BoxDecoration(
// //                       color: Colors.black,
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     // child: Icon(
// //                     //   Icons.shopping_cart_outlined,
// //                     //   color: Colors.white,
// //                     // ),
// //                     child: IconButton(
// //                       onPressed: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(builder: (context) => Wallet()),
// //                         );
// //                       },
// //                       icon: Icon(Icons.shopping_cart_outlined),
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 20.0),
// //               Text("Delicious Food", style: AppWidget.HeadlineTextFeildStyle()),
// //               Text(
// //                 "Discover and Get Great Food",
// //                 style: AppWidget.LightTextFeildStyle(),
// //               ),
// //               SizedBox(height: 20.0),
// //               Container(
// //                 margin: EdgeInsets.only(right: 20.0),
// //                 child: showItem(),
// //               ),
// //               SizedBox(height: 30.0),
// //               SingleChildScrollView(
// //                 scrollDirection: Axis.horizontal,
// //                 child: Row(
// //                   children: [
// //                     GestureDetector(
// //                       onTap: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(builder: (context) => Details()),
// //                         );
// //                       },
// //                       child: Container(
// //                         margin: EdgeInsets.all(4),
// //                         child: Material(
// //                           elevation: 5.0,
// //                           borderRadius: BorderRadius.circular(20),
// //                           child: Container(
// //                             padding: EdgeInsets.all(14),
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Image.asset(
// //                                   "assets/images/salad2.png",
// //                                   height: 150,
// //                                   width: 150,
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                                 Text(
// //                                   "Veggie Taco Hash",
// //                                   style: AppWidget.semiBoldTextFeildStyle(),
// //                                 ),
// //                                 SizedBox(height: 5.0),
// //                                 Text(
// //                                   "Fresh and Healthy",
// //                                   style: AppWidget.LightTextFeildStyle(),
// //                                 ),
// //                                 SizedBox(height: 5.0),
// //                                 Text(
// //                                   "\$25",
// //                                   style: AppWidget.semiBoldTextFeildStyle(),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(width: 15.0),
// //                     Container(
// //                       margin: EdgeInsets.all(4),
// //                       child: Material(
// //                         elevation: 5.0,
// //                         borderRadius: BorderRadius.circular(20),
// //                         child: Container(
// //                           padding: EdgeInsets.all(14),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Image.asset(
// //                                 "assets/images/salad4.png",
// //                                 height: 150,
// //                                 width: 150,
// //                                 fit: BoxFit.cover,
// //                               ),
// //                               Text(
// //                                 "Mix Veg Salad",
// //                                 style: AppWidget.semiBoldTextFeildStyle(),
// //                               ),
// //                               SizedBox(height: 5.0),
// //                               Text(
// //                                 "Spicy with Onion",
// //                                 style: AppWidget.LightTextFeildStyle(),
// //                               ),
// //                               SizedBox(height: 5.0),
// //                               Text(
// //                                 "\$28",
// //                                 style: AppWidget.semiBoldTextFeildStyle(),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 30.0),
// //               Container(
// //                 margin: EdgeInsets.only(right: 20.0),
// //                 child: Material(
// //                   elevation: 5.0,
// //                   borderRadius: BorderRadius.circular(20),
// //                   child: Container(
// //                     padding: EdgeInsets.all(5),
// //                     child: Row(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Image.asset(
// //                           "assets/images/salad4.png",
// //                           height: 120,
// //                           width: 120,
// //                           fit: BoxFit.cover,
// //                         ),
// //                         SizedBox(width: 20.0),
// //                         Expanded(
// //                           child: Column(
// //                             children: [
// //                               Container(
// //                                 width: MediaQuery.of(context).size.width / 2,
// //                                 child: Text(
// //                                   "Mediterranean Chickpea Salad",
// //                                   style: AppWidget.semiBoldTextFeildStyle(),
// //                                 ),
// //                               ),
// //                               SizedBox(height: 5.0),
// //                               Container(
// //                                 width: MediaQuery.of(context).size.width / 2,
// //                                 child: Text(
// //                                   "Honey goot cheese",
// //                                   style: AppWidget.LightTextFeildStyle(),
// //                                 ),
// //                               ),
// //                               SizedBox(height: 5.0),
// //                               Container(
// //                                 width: MediaQuery.of(context).size.width / 2,
// //                                 child: Text(
// //                                   "\$28",
// //                                   style: AppWidget.semiBoldTextFeildStyle(),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 30.0),
// //               Container(
// //                 margin: EdgeInsets.only(right: 20.0),
// //                 child: Material(
// //                   elevation: 5.0,
// //                   borderRadius: BorderRadius.circular(20),
// //                   child: Container(
// //                     padding: EdgeInsets.all(5),
// //                     child: Row(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Image.asset(
// //                           "assets/images/salad2.png",
// //                           height: 120,
// //                           width: 120,
// //                           fit: BoxFit.cover,
// //                         ),
// //                         SizedBox(width: 20.0),
// //                         Expanded(
// //                           child: Column(
// //                             children: [
// //                               Container(
// //                                 width: MediaQuery.of(context).size.width / 2,
// //                                 child: Text(
// //                                   "Veggie Taco Hash",
// //                                   style: AppWidget.semiBoldTextFeildStyle(),
// //                                 ),
// //                               ),
// //                               SizedBox(height: 5.0),
// //                               Container(
// //                                 width: MediaQuery.of(context).size.width / 2,
// //                                 child: Text(
// //                                   "Honey goot cheese",
// //                                   style: AppWidget.LightTextFeildStyle(),
// //                                 ),
// //                               ),
// //                               SizedBox(height: 5.0),
// //                               Container(
// //                                 width: MediaQuery.of(context).size.width / 2,
// //                                 child: Text(
// //                                   "\$28",
// //                                   style: AppWidget.semiBoldTextFeildStyle(),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget showItem() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         GestureDetector(
// //           onTap: () {
// //             icecream = true;
// //             pizza = false;
// //             salad = false;
// //             burger = false;
// //             setState(() {});
// //           },
// //           child: Material(
// //             elevation: 5.0,
// //             borderRadius: BorderRadius.circular(10),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: icecream ? Colors.black : Colors.white,
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               padding: EdgeInsets.all(8),
// //               child: Image.asset(
// //                 "assets/images/ice-cream.png",
// //                 height: 40,
// //                 width: 40,
// //                 fit: BoxFit.cover,
// //                 color: icecream ? Colors.white : Colors.black,
// //               ),
// //             ),
// //           ),
// //         ),
// //         GestureDetector(
// //           onTap: () {
// //             icecream = false;
// //             pizza = true;
// //             salad = false;
// //             burger = false;
// //             setState(() {});
// //           },
// //           child: Material(
// //             elevation: 5.0,
// //             borderRadius: BorderRadius.circular(10),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: pizza ? Colors.black : Colors.white,
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               padding: EdgeInsets.all(8),
// //               child: Image.asset(
// //                 "assets/images/pizza.png",
// //                 height: 40,
// //                 width: 40,
// //                 fit: BoxFit.cover,
// //                 color: pizza ? Colors.white : Colors.black,
// //               ),
// //             ),
// //           ),
// //         ),
// //         GestureDetector(
// //           onTap: () {
// //             icecream = false;
// //             pizza = false;
// //             salad = true;
// //             burger = false;
// //             setState(() {});
// //           },
// //           child: Material(
// //             elevation: 5.0,
// //             borderRadius: BorderRadius.circular(10),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: salad ? Colors.black : Colors.white,
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               padding: EdgeInsets.all(8),
// //               child: Image.asset(
// //                 "assets/images/salad.png",
// //                 height: 40,
// //                 width: 40,
// //                 fit: BoxFit.cover,
// //                 color: salad ? Colors.white : Colors.black,
// //               ),
// //             ),
// //           ),
// //         ),
// //         GestureDetector(
// //           onTap: () {
// //             icecream = false;
// //             pizza = false;
// //             salad = false;
// //             burger = true;
// //             setState(() {});
// //           },
// //           child: Material(
// //             elevation: 5.0,
// //             borderRadius: BorderRadius.circular(10),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: burger ? Colors.black : Colors.white,
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               padding: EdgeInsets.all(8),
// //               child: Image.asset(
// //                 "assets/images/burger.png",
// //                 height: 40,
// //                 width: 40,
// //                 fit: BoxFit.cover,
// //                 color: burger ? Colors.white : Colors.black,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'package:emerge_homely/pages/details.dart';
// import 'package:emerge_homely/pages/wallet.dart';
// import 'package:emerge_homely/widget/widget_support.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   bool icecream = false, pizza = false, salad = false, burger = false;
//   double? _latitude;
//   double? _longitude;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied')),
//           );
//           return;
//         }
//       }
//       if (permission == LocationPermission.deniedForever) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Location permissions are permanently denied, we cannot request permissions.',
//             ),
//           ),
//         );
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         _latitude = position.latitude;
//         _longitude = position.longitude;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
//     }
//   }

//   Future<void> _showLocationDialog() async {
//     final TextEditingController latController = TextEditingController(
//       text: _latitude?.toString() ?? '',
//     );
//     final TextEditingController lonController = TextEditingController(
//       text: _longitude?.toString() ?? '',
//     );

//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Change Location'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: latController,
//               decoration: const InputDecoration(labelText: 'Latitude'),
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//               ),
//             ),
//             TextField(
//               controller: lonController,
//               decoration: const InputDecoration(labelText: 'Longitude'),
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//               ),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 await _getCurrentLocation();
//                 if (_latitude != null && _longitude != null) {
//                   latController.text = _latitude.toString();
//                   lonController.text = _longitude.toString();
//                 }
//               },
//               child: const Text('Use Current Location'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               final newLat = double.tryParse(latController.text);
//               final newLon = double.tryParse(lonController.text);
//               if (newLat != null && newLon != null) {
//                 setState(() {
//                   _latitude = newLat;
//                   _longitude = newLon;
//                 });
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Location updated successfully'),
//                   ),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Invalid latitude or longitude'),
//                   ),
//                 );
//               }
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.location_on),
//           onPressed: _showLocationDialog,
//           color: Colors.black,
//         ),
//         title: Text("Hello Shivam,", style: AppWidget.boldTextFeildStyle()),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 20.0),
//             padding: const EdgeInsets.all(3),
//             decoration: const BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.all(Radius.circular(8)),
//             ),
//             child: IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const Wallet()),
//                 );
//               },
//               icon: const Icon(Icons.shopping_cart_outlined),
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.only(top: 20.0, left: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Delicious Food", style: AppWidget.HeadlineTextFeildStyle()),
//               Text(
//                 "Discover and Get Great Food",
//                 style: AppWidget.LightTextFeildStyle(),
//               ),
//               const SizedBox(height: 20.0),
//               Container(
//                 margin: const EdgeInsets.only(right: 20.0),
//                 child: showItem(),
//               ),
//               const SizedBox(height: 30.0),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const Details(),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.all(4),
//                         child: Material(
//                           elevation: 5.0,
//                           borderRadius: BorderRadius.circular(20),
//                           child: Container(
//                             padding: const EdgeInsets.all(14),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Image.asset(
//                                   "assets/images/salad2.png",
//                                   height: 150,
//                                   width: 150,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 Text(
//                                   "Veggie Taco Hash",
//                                   style: AppWidget.semiBoldTextFeildStyle(),
//                                 ),
//                                 const SizedBox(height: 5.0),
//                                 Text(
//                                   "Fresh and Healthy",
//                                   style: AppWidget.LightTextFeildStyle(),
//                                 ),
//                                 const SizedBox(height: 5.0),
//                                 Text(
//                                   "\$25",
//                                   style: AppWidget.semiBoldTextFeildStyle(),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 15.0),
//                     Container(
//                       margin: const EdgeInsets.all(4),
//                       child: Material(
//                         elevation: 5.0,
//                         borderRadius: BorderRadius.circular(20),
//                         child: Container(
//                           padding: const EdgeInsets.all(14),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Image.asset(
//                                 "assets/images/salad4.png",
//                                 height: 150,
//                                 width: 150,
//                                 fit: BoxFit.cover,
//                               ),
//                               Text(
//                                 "Mix Veg Salad",
//                                 style: AppWidget.semiBoldTextFeildStyle(),
//                               ),
//                               const SizedBox(height: 5.0),
//                               Text(
//                                 "Spicy with Onion",
//                                 style: AppWidget.LightTextFeildStyle(),
//                               ),
//                               const SizedBox(height: 5.0),
//                               Text(
//                                 "\$28",
//                                 style: AppWidget.semiBoldTextFeildStyle(),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30.0),
//               Container(
//                 margin: const EdgeInsets.only(right: 20.0),
//                 child: Material(
//                   elevation: 5.0,
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     padding: const EdgeInsets.all(5),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.asset(
//                           "assets/images/salad4.png",
//                           height: 120,
//                           width: 120,
//                           fit: BoxFit.cover,
//                         ),
//                         const SizedBox(width: 20.0),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Container(
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   "Mediterranean Chickpea Salad",
//                                   style: AppWidget.semiBoldTextFeildStyle(),
//                                 ),
//                               ),
//                               const SizedBox(height: 5.0),
//                               Container(
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   "Honey goot cheese",
//                                   style: AppWidget.LightTextFeildStyle(),
//                                 ),
//                               ),
//                               const SizedBox(height: 5.0),
//                               Container(
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   "\$28",
//                                   style: AppWidget.semiBoldTextFeildStyle(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30.0),
//               Container(
//                 margin: const EdgeInsets.only(right: 20.0),
//                 child: Material(
//                   elevation: 5.0,
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     padding: const EdgeInsets.all(5),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.asset(
//                           "assets/images/salad2.png",
//                           height: 120,
//                           width: 120,
//                           fit: BoxFit.cover,
//                         ),
//                         const SizedBox(width: 20.0),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Container(
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   "Veggie Taco Hash",
//                                   style: AppWidget.semiBoldTextFeildStyle(),
//                                 ),
//                               ),
//                               const SizedBox(height: 5.0),
//                               Container(
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   "Honey goot cheese",
//                                   style: AppWidget.LightTextFeildStyle(),
//                                 ),
//                               ),
//                               const SizedBox(height: 5.0),
//                               Container(
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   "\$28",
//                                   style: AppWidget.semiBoldTextFeildStyle(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget showItem() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         GestureDetector(
//           onTap: () {
//             icecream = true;
//             pizza = false;
//             salad = false;
//             burger = false;
//             setState(() {});
//           },
//           child: Material(
//             elevation: 5.0,
//             borderRadius: BorderRadius.circular(10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: icecream ? Colors.black : Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               padding: const EdgeInsets.all(8),
//               child: Image.asset(
//                 "assets/images/ice-cream.png",
//                 height: 40,
//                 width: 40,
//                 fit: BoxFit.cover,
//                 color: icecream ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             icecream = false;
//             pizza = true;
//             salad = false;
//             burger = false;
//             setState(() {});
//           },
//           child: Material(
//             elevation: 5.0,
//             borderRadius: BorderRadius.circular(10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: pizza ? Colors.black : Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               padding: const EdgeInsets.all(8),
//               child: Image.asset(
//                 "assets/images/pizza.png",
//                 height: 40,
//                 width: 40,
//                 fit: BoxFit.cover,
//                 color: pizza ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             icecream = false;
//             pizza = false;
//             salad = true;
//             burger = false;
//             setState(() {});
//           },
//           child: Material(
//             elevation: 5.0,
//             borderRadius: BorderRadius.circular(10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: salad ? Colors.black : Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               padding: const EdgeInsets.all(8),
//               child: Image.asset(
//                 "assets/images/salad.png",
//                 height: 40,
//                 width: 40,
//                 fit: BoxFit.cover,
//                 color: salad ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             icecream = false;
//             pizza = false;
//             salad = false;
//             burger = true;
//             setState(() {});
//           },
//           child: Material(
//             elevation: 5.0,
//             borderRadius: BorderRadius.circular(10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: burger ? Colors.black : Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               padding: const EdgeInsets.all(8),
//               child: Image.asset(
//                 "assets/images/burger.png",
//                 height: 40,
//                 width: 40,
//                 fit: BoxFit.cover,
//                 color: burger ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:emerge_homely/pages/details.dart';
import 'package:emerge_homely/pages/wallet.dart';
import 'package:emerge_homely/widget/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false, pizza = false, salad = false, burger = false;
  
  // Location variables
  double? currentLatitude;
  double? currentLongitude;
  String currentAddress = "Getting location...";
  bool isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Function to get current location
  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        isLoadingLocation = true;
        currentAddress = "Getting location...";
      });

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            currentAddress = "Location permission denied";
            isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          currentAddress = "Location permission permanently denied";
          isLoadingLocation = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
      });

      // Get address from coordinates
      await _getAddressFromCoordinates(position.latitude, position.longitude);

    } catch (e) {
      setState(() {
        currentAddress = "Unable to get location";
        isLoadingLocation = false;
      });
      print("Error getting location: $e");
    }
  }

  // Function to get address from coordinates
  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          currentAddress = "${place.locality}, ${place.administrativeArea}";
          isLoadingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        currentAddress = "Address not found";
        isLoadingLocation = false;
      });
      print("Error getting address: $e");
    }
  }

  // Function to show location selection dialog
  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Location", style: AppWidget.semiBoldTextFeildStyle()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (currentLatitude != null && currentLongitude != null)
                Text(
                  "Current Location:\nLat: ${currentLatitude!.toStringAsFixed(6)}\nLng: ${currentLongitude!.toStringAsFixed(6)}\n\n$currentAddress",
                  style: AppWidget.LightTextFeildStyle(),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _getCurrentLocation(); // Refresh current location
                    },
                    icon: Icon(Icons.my_location),
                    label: Text("Use Current"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showAddressInputDialog();
                    },
                    icon: Icon(Icons.edit_location),
                    label: Text("Change"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to show address input dialog
  void _showAddressInputDialog() {
    TextEditingController addressController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Address", style: AppWidget.semiBoldTextFeildStyle()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: "Enter your delivery address",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text(
                "Or search for a location by name",
                style: AppWidget.LightTextFeildStyle(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (addressController.text.isNotEmpty) {
                  await _searchAndSetLocation(addressController.text);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Function to search location by address
  Future<void> _searchAndSetLocation(String address) async {
    try {
      setState(() {
        isLoadingLocation = true;
        currentAddress = "Searching...";
      });

      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        setState(() {
          currentLatitude = location.latitude;
          currentLongitude = location.longitude;
        });
        
        await _getAddressFromCoordinates(location.latitude, location.longitude);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Location updated successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          isLoadingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Location not found. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoadingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error searching location. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
      print("Error searching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: _showLocationDialog,
          icon: Icon(
            Icons.location_on,
            color: Colors.black,
            size: 28,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Delivery to",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              isLoadingLocation ? "Getting location..." : currentAddress,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20.0),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Wallet()),
                );
              },
              icon: Icon(Icons.shopping_cart_outlined),
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Shivam,", style: AppWidget.boldTextFeildStyle()),
                ],
              ),
              SizedBox(height: 20.0),
              Text("Delicious Food", style: AppWidget.HeadlineTextFeildStyle()),
              Text(
                "Discover and Get Great Food",
                style: AppWidget.LightTextFeildStyle(),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: showItem(),
              ),
              SizedBox(height: 30.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Details()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/salad2.png",
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "Veggie Taco Hash",
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "Fresh and Healthy",
                                  style: AppWidget.LightTextFeildStyle(),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "\$25",
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Container(
                      margin: EdgeInsets.all(4),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/salad4.png",
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                "Mix Veg Salad",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "Spicy with Onion",
                                style: AppWidget.LightTextFeildStyle(),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "\$28",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/salad4.png",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  "Mediterranean Chickpea Salad",
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  "Honey goot cheese",
                                  style: AppWidget.LightTextFeildStyle(),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  "\$28",
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/salad2.png",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  "Veggie Taco Hash",
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  "Honey goot cheese",
                                  style: AppWidget.LightTextFeildStyle(),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  "\$28",
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                ),
                              ),
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
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            icecream = true;
            pizza = false;
            salad = false;
            burger = false;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: icecream ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "assets/images/ice-cream.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: icecream ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            pizza = true;
            salad = false;
            burger = false;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: pizza ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "assets/images/pizza.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: pizza ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            pizza = false;
            salad = true;
            burger = false;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: salad ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "assets/images/salad.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: salad ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecream = false;
            pizza = false;
            salad = false;
            burger = true;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: burger ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "assets/images/burger.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                color: burger ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}