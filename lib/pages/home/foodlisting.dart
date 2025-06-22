import 'package:emerge_homely/pages/home/fooddetails.dart';
import 'package:emerge_homely/widget/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodItemsPage extends StatefulWidget {
  @override
  _FoodItemsPageState createState() => _FoodItemsPageState();
}

class _FoodItemsPageState extends State<FoodItemsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool icecream = false, pizza = false, salad = false, burger = false;
  Position? _currentPosition;
  List<Map<String, dynamic>> _foodItemsWithDistance = [];
  bool _isLoadingLocation = true;
  bool _isLoadingFoodItems = false;
  double _selectedDistance = 50.0; // Default 50km
  List<double> _distanceOptions = [5.0, 10.0, 25.0, 50.0, 100.0];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      setState(() {
        _isLoadingLocation = true;
      });
      // Get current user's stored location from Firestore
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('No user is currently signed in');
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;

        if (userData['location'] != null &&
            userData['location']['latitude'] != null &&
            userData['location']['longitude'] != null) {
          // Create a Position object from stored location data
          _currentPosition = Position(
            latitude: userData['location']['latitude'].toDouble(),
            longitude: userData['location']['longitude'].toDouble(),
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          );

          setState(() {
            _isLoadingLocation = false;
          });

          // Load food items once we have the user's stored location
          _loadFoodItemsWithDistance();
        } else {
          print('User location data not found in Firestore');
          setState(() {
            _isLoadingLocation = false;
          });
        }
      } else {
        print('User document not found');
        setState(() {
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      print('Error getting user location: $e');
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  // Alternative method if you have the current user ID available elsewhere
  Future<void> _getUserLocationById(String userId) async {
    try {
      setState(() {
        _isLoadingLocation = true;
      });

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;

        if (userData['location'] != null &&
            userData['location']['latitude'] != null &&
            userData['location']['longitude'] != null) {
          _currentPosition = Position(
            latitude: userData['location']['latitude'].toDouble(),
            longitude: userData['location']['longitude'].toDouble(),
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          );

          setState(() {
            _isLoadingLocation = false;
          });

          _loadFoodItemsWithDistance();
        } else {
          print('User location data not found');
          setState(() {
            _isLoadingLocation = false;
          });
        }
      } else {
        print('User not found');
        setState(() {
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      print('Error getting user location: $e');
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  // Keep the existing distance calculation method unchanged
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) /
        1000; // Convert to km
  }

  String _getSelectedCategory() {
    if (icecream) return 'Ice Cream';
    if (pizza) return 'Pizza';
    if (salad) return 'Salad';
    if (burger) return 'Burger';
    return 'All';
  }

  // Keep the existing _loadFoodItemsWithDistance method unchanged
  Future<void> _loadFoodItemsWithDistance() async {
    if (_currentPosition == null) return;

    setState(() {
      _isLoadingFoodItems = true;
    });

    try {
      // Get all food items
      QuerySnapshot productsSnapshot = await _firestore
          .collection('Products')
          .where('category', isEqualTo: 'Food Items')
          .where('isAvailable', isEqualTo: true)
          .get();

      // Get all users locations
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();

      // Get all vendor profiles locations
      QuerySnapshot vendorProfilesSnapshot = await _firestore
          .collection('vendor_profile')
          .get();

      // Create maps for quick location lookup
      Map<String, Map<String, dynamic>> userLocations = {};
      Map<String, Map<String, dynamic>> vendorLocations = {};

      // Process users locations
      for (var doc in usersSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data['location'] != null &&
            data['location']['latitude'] != null &&
            data['location']['longitude'] != null) {
          userLocations[doc.id] = {
            'latitude': data['location']['latitude'],
            'longitude': data['location']['longitude'],
            'address': data['location']['address'] ?? 'Unknown Address',
          };
        }
      }

      // Process vendor profiles locations
      for (var doc in vendorProfilesSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data['latitude'] != null && data['longitude'] != null) {
          vendorLocations[doc.id] = {
            'latitude': data['latitude'],
            'longitude': data['longitude'],
            'locationName': data['locationName'] ?? 'Unknown Location',
          };
        }
      }

      List<Map<String, dynamic>> foodItemsWithDistance = [];

      // Process each food item
      for (var doc in productsSnapshot.docs) {
        var foodData = doc.data() as Map<String, dynamic>;

        // Try to find location from vendor profile first, then users
        String? vendorId = foodData['vendorId'] ?? foodData['userId'];
        Map<String, dynamic>? locationData;
        String locationSource = '';

        if (vendorId != null) {
          if (vendorLocations.containsKey(vendorId)) {
            locationData = vendorLocations[vendorId];
            locationSource = 'vendor';
          } else if (userLocations.containsKey(vendorId)) {
            locationData = userLocations[vendorId];
            locationSource = 'user';
          }
        }

        if (locationData != null) {
          double distance = _calculateDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            locationData['latitude'].toDouble(),
            locationData['longitude'].toDouble(),
          );

          if (distance <= _selectedDistance) {
            var itemData = Map<String, dynamic>.from(foodData);
            itemData['distance'] = distance;
            itemData['docId'] = doc.id;
            itemData['vendorId'] = vendorId;
            itemData['locationSource'] = locationSource;
            itemData['latitude'] = locationData['latitude'];
            itemData['longitude'] = locationData['longitude'];

            // Set location name based on source
            if (locationSource == 'vendor') {
              itemData['vendorLocation'] = locationData['locationName'];
            } else {
              itemData['vendorLocation'] = locationData['address'];
            }

            // Category filter
            String selectedCategory = _getSelectedCategory();
            if (selectedCategory == 'All' ||
                _matchesCategory(itemData, selectedCategory)) {
              foodItemsWithDistance.add(itemData);
            }
          }
        } else {
          // Debug: Print items without location data
          print(
            'No location found for food item: ${foodData['name']} with vendorId: $vendorId',
          );
        }
      }

      // Sort by distance (nearest first)
      foodItemsWithDistance.sort(
        (a, b) => a['distance'].compareTo(b['distance']),
      );

      setState(() {
        _foodItemsWithDistance = foodItemsWithDistance;
        _isLoadingFoodItems = false;
      });

      // Debug: Print results
      print(
        'Found ${foodItemsWithDistance.length} food items within ${_selectedDistance}km',
      );
      for (var item in foodItemsWithDistance.take(5)) {
        print(
          '${item['name']}: ${item['distance'].toStringAsFixed(2)}km from ${item['locationSource']}',
        );
      }
    } catch (e) {
      print('Error loading food items: $e');
      setState(() {
        _isLoadingFoodItems = false;
      });
    }
  }

  bool _matchesCategory(Map<String, dynamic> itemData, String category) {
    String? foodCategory = itemData['foodCategory']?.toString().toLowerCase();
    String? name = itemData['name']?.toString().toLowerCase();
    String? description = itemData['description']?.toString().toLowerCase();
    String categoryLower = category.toLowerCase();

    return (foodCategory != null && foodCategory.contains(categoryLower)) ||
        (name != null && name.contains(categoryLower)) ||
        (description != null && description.contains(categoryLower));
  }

  // Add these variables to your state class
  List<String> _foodTypes = [
    'All',
    'Vegetarian',
    'Non-Vegetarian',
    'Vegan',
    'Beverages',
    'Desserts',
  ];
  String _selectedFoodType = 'All';

  // Add this method to filter food items by food type
  List<Map<String, dynamic>> _getFilteredFoodItems() {
    if (_selectedFoodType == 'All') {
      return _foodItemsWithDistance;
    }
    return _foodItemsWithDistance.where((item) {
      return item['foodType']?.toString().toLowerCase() ==
          _selectedFoodType.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: SingleChildScrollView(
    //     child: Container(
    //       margin: EdgeInsets.only(top: 50.0, left: 20.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text("Hello Shivam,", style: AppWidget.boldTextFeildStyle()),
    //               Container(
    //                 margin: EdgeInsets.only(right: 20.0),
    //                 padding: EdgeInsets.all(3),
    //                 decoration: BoxDecoration(
    //                   color: Colors.black,
    //                   borderRadius: BorderRadius.circular(8),
    //                 ),
    //                 child: Icon(
    //                   Icons.shopping_cart_outlined,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           SizedBox(height: 20.0),
    //           Text(
    //             "Nearby Delicious Food",
    //             style: AppWidget.HeadlineTextFeildStyle(),
    //           ),
    //           Text(
    //             "Discover food items near you",
    //             style: AppWidget.LightTextFeildStyle(),
    //           ),
    //           SizedBox(height: 20.0),

    //           // Distance Filter
    //           Container(
    //             margin: EdgeInsets.only(right: 20.0),
    //             child: Row(
    //               children: [
    //                 Text("Within: ", style: AppWidget.semiBoldTextFeildStyle()),
    //                 DropdownButton<double>(
    //                   value: _selectedDistance,
    //                   items: _distanceOptions.map((distance) {
    //                     return DropdownMenuItem<double>(
    //                       value: distance,
    //                       child: Text("${distance.toInt()} km"),
    //                     );
    //                   }).toList(),
    //                   onChanged: (value) {
    //                     setState(() {
    //                       _selectedDistance = value!;
    //                     });
    //                     if (_currentPosition != null) {
    //                       _loadFoodItemsWithDistance();
    //                     }
    //                   },
    //                 ),
    //               ],
    //             ),
    //           ),
    //           SizedBox(height: 20.0),

    //           // Category Filter
    //           Container(
    //             margin: EdgeInsets.only(right: 20.0),
    //             child: showItem(),
    //           ),
    //           SizedBox(height: 30.0),

    //           // Current Location Display (for debugging)
    //           if (_currentPosition != null)
    //             Container(
    //               margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
    //               padding: EdgeInsets.all(10),
    //               decoration: BoxDecoration(
    //                 color: Colors.blue[50],
    //                 borderRadius: BorderRadius.circular(10),
    //               ),
    //               child: Row(
    //                 children: [
    //                   Icon(Icons.my_location, size: 16, color: Colors.blue),
    //                   SizedBox(width: 8),
    //                   Expanded(
    //                     child: Text(
    //                       "Your location: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}",
    //                       style: TextStyle(
    //                         fontSize: 12,
    //                         color: Colors.blue[700],
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),

    //           // Food Items List
    //           _isLoadingLocation
    //               ? Center(
    //                   child: Column(
    //                     children: [
    //                       CircularProgressIndicator(),
    //                       SizedBox(height: 16),
    //                       Text(
    //                         "Getting your location...",
    //                         style: AppWidget.LightTextFeildStyle(),
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               : _currentPosition == null
    //               ? Center(
    //                   child: Column(
    //                     children: [
    //                       Icon(
    //                         Icons.location_off,
    //                         size: 80,
    //                         color: Colors.grey[400],
    //                       ),
    //                       SizedBox(height: 16),
    //                       Text(
    //                         "Location access denied",
    //                         style: AppWidget.LightTextFeildStyle(),
    //                       ),
    //                       SizedBox(height: 8),
    //                       Text(
    //                         "Please enable location to see nearby food items",
    //                         style: AppWidget.LightTextFeildStyle(),
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               : _isLoadingFoodItems
    //               ? Center(
    //                   child: Column(
    //                     children: [
    //                       CircularProgressIndicator(),
    //                       SizedBox(height: 16),
    //                       Text(
    //                         "Finding nearby food items...",
    //                         style: AppWidget.LightTextFeildStyle(),
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               : _foodItemsWithDistance.isEmpty
    //               ? Center(
    //                   child: Column(
    //                     children: [
    //                       Icon(
    //                         Icons.restaurant_menu,
    //                         size: 80,
    //                         color: Colors.grey[400],
    //                       ),
    //                       SizedBox(height: 16),
    //                       Text(
    //                         'No food items found within ${_selectedDistance.toInt()} km',
    //                         style: AppWidget.LightTextFeildStyle(),
    //                       ),
    //                       SizedBox(height: 8),
    //                       Text(
    //                         'Try increasing the distance or check different categories',
    //                         style: AppWidget.LightTextFeildStyle(),
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               : Column(
    //                   children: [
    //                     // Show total count
    //                     Container(
    //                       margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
    //                       child: Row(
    //                         children: [
    //                           Icon(
    //                             Icons.restaurant,
    //                             size: 16,
    //                             color: Colors.green,
    //                           ),
    //                           SizedBox(width: 8),
    //                           Text(
    //                             "${_foodItemsWithDistance.length} food items found nearby",
    //                             style: AppWidget.semiBoldTextFeildStyle(),
    //                           ),
    //                         ],
    //                       ),
    //                     ),

    //                     // Horizontal scroll for featured items (top 5 nearest)
    //                     Container(
    //                       height: 270,
    //                       child: ListView.builder(
    //                         scrollDirection: Axis.horizontal,
    //                         itemCount: _foodItemsWithDistance.length > 5
    //                             ? 5
    //                             : _foodItemsWithDistance.length,
    //                         itemBuilder: (context, index) {
    //                           var data = _foodItemsWithDistance[index];
    //                           return GestureDetector(
    //                             onTap: () {
    //                               Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       FoodItemDetails(foodData: data),
    //                                 ),
    //                               );
    //                             },
    //                             child: Container(
    //                               margin: EdgeInsets.only(right: 15.0),
    //                               width: 200,
    //                               child: Material(
    //                                 elevation: 5.0,
    //                                 borderRadius: BorderRadius.circular(20),
    //                                 child: Container(
    //                                   padding: EdgeInsets.all(14),
    //                                   child: Column(
    //                                     crossAxisAlignment:
    //                                         CrossAxisAlignment.start,
    //                                     children: [
    //                                       // Nearest badge for first item
    //                                       if (index == 0)
    //                                         Container(
    //                                           padding: EdgeInsets.symmetric(
    //                                             horizontal: 8,
    //                                             vertical: 4,
    //                                           ),
    //                                           decoration: BoxDecoration(
    //                                             color: Colors.green,
    //                                             borderRadius:
    //                                                 BorderRadius.circular(12),
    //                                           ),
    //                                           child: Text(
    //                                             "NEAREST",
    //                                             style: TextStyle(
    //                                               color: Colors.white,
    //                                               fontSize: 10,
    //                                               fontWeight: FontWeight.bold,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       SizedBox(height: index == 0 ? 8 : 0),
    //                                       ClipRRect(
    //                                         borderRadius: BorderRadius.circular(
    //                                           10,
    //                                         ),
    //                                         child: Container(
    //                                           height: 120,
    //                                           width: double.infinity,
    //                                           child:
    //                                               data['images'] != null &&
    //                                                   data['images'].isNotEmpty
    //                                               ? Image.network(
    //                                                   data['images'][0],
    //                                                   fit: BoxFit.cover,
    //                                                   errorBuilder:
    //                                                       (
    //                                                         context,
    //                                                         error,
    //                                                         stackTrace,
    //                                                       ) {
    //                                                         return Container(
    //                                                           color: Colors
    //                                                               .grey[200],
    //                                                           child: Icon(
    //                                                             Icons
    //                                                                 .restaurant,
    //                                                             size: 40,
    //                                                             color: Colors
    //                                                                 .grey[400],
    //                                                           ),
    //                                                         );
    //                                                       },
    //                                                 )
    //                                               : Container(
    //                                                   color: Colors.grey[200],
    //                                                   child: Icon(
    //                                                     Icons.restaurant,
    //                                                     size: 40,
    //                                                     color: Colors.grey[400],
    //                                                   ),
    //                                                 ),
    //                                         ),
    //                                       ),
    //                                       SizedBox(height: 8),
    //                                       Text(
    //                                         data['name'] ?? 'Unknown Item',
    //                                         style:
    //                                             AppWidget.semiBoldTextFeildStyle(),
    //                                         maxLines: 1,
    //                                         overflow: TextOverflow.ellipsis,
    //                                       ),
    //                                       SizedBox(height: 5.0),
    //                                       Row(
    //                                         children: [
    //                                           Icon(
    //                                             Icons.location_on,
    //                                             size: 14,
    //                                             color: Colors.red,
    //                                           ),
    //                                           SizedBox(width: 4),
    //                                           Expanded(
    //                                             child: Text(
    //                                               "${data['distance'].toStringAsFixed(1)} km away",
    //                                               style:
    //                                                   AppWidget.LightTextFeildStyle(),
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                       SizedBox(height: 5.0),
    //                                       Text(
    //                                         "₹${data['price']?.toStringAsFixed(0) ?? '0'}",
    //                                         style:
    //                                             AppWidget.semiBoldTextFeildStyle(),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           );
    //                         },
    //                       ),
    //                     ),
    //                     SizedBox(height: 30.0),

    //                     // Vertical list for all items
    //                     ListView.builder(
    //                       shrinkWrap: true,
    //                       physics: NeverScrollableScrollPhysics(),
    //                       itemCount: _foodItemsWithDistance.length,
    //                       itemBuilder: (context, index) {
    //                         var data = _foodItemsWithDistance[index];
    //                         return GestureDetector(
    //                           onTap: () {
    //                             Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                 builder: (context) =>
    //                                     FoodItemDetails(foodData: data),
    //                               ),
    //                             );
    //                           },
    //                           child: Container(
    //                             margin: EdgeInsets.only(
    //                               right: 20.0,
    //                               bottom: 20.0,
    //                             ),
    //                             child: Material(
    //                               elevation: 5.0,
    //                               borderRadius: BorderRadius.circular(20),
    //                               child: Container(
    //                                 padding: EdgeInsets.all(10),
    //                                 child: Row(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                   children: [
    //                                     ClipRRect(
    //                                       borderRadius: BorderRadius.circular(
    //                                         10,
    //                                       ),
    //                                       child: Container(
    //                                         height: 120,
    //                                         width: 120,
    //                                         child:
    //                                             data['images'] != null &&
    //                                                 data['images'].isNotEmpty
    //                                             ? Image.network(
    //                                                 data['images'][0],
    //                                                 fit: BoxFit.cover,
    //                                                 errorBuilder:
    //                                                     (
    //                                                       context,
    //                                                       error,
    //                                                       stackTrace,
    //                                                     ) {
    //                                                       return Container(
    //                                                         color: Colors
    //                                                             .grey[200],
    //                                                         child: Icon(
    //                                                           Icons.restaurant,
    //                                                           size: 40,
    //                                                           color: Colors
    //                                                               .grey[400],
    //                                                         ),
    //                                                       );
    //                                                     },
    //                                               )
    //                                             : Container(
    //                                                 color: Colors.grey[200],
    //                                                 child: Icon(
    //                                                   Icons.restaurant,
    //                                                   size: 40,
    //                                                   color: Colors.grey[400],
    //                                                 ),
    //                                               ),
    //                                       ),
    //                                     ),
    //                                     SizedBox(width: 20.0),
    //                                     Expanded(
    //                                       child: Column(
    //                                         crossAxisAlignment:
    //                                             CrossAxisAlignment.start,
    //                                         children: [
    //                                           Row(
    //                                             children: [
    //                                               Expanded(
    //                                                 child: Text(
    //                                                   data['name'] ??
    //                                                       'Unknown Item',
    //                                                   style:
    //                                                       AppWidget.semiBoldTextFeildStyle(),
    //                                                 ),
    //                                               ),
    //                                               if (index == 0)
    //                                                 Container(
    //                                                   padding:
    //                                                       EdgeInsets.symmetric(
    //                                                         horizontal: 6,
    //                                                         vertical: 2,
    //                                                       ),
    //                                                   decoration: BoxDecoration(
    //                                                     color: Colors.green,
    //                                                     borderRadius:
    //                                                         BorderRadius.circular(
    //                                                           8,
    //                                                         ),
    //                                                   ),
    //                                                   child: Text(
    //                                                     "NEAREST",
    //                                                     style: TextStyle(
    //                                                       color: Colors.white,
    //                                                       fontSize: 8,
    //                                                       fontWeight:
    //                                                           FontWeight.bold,
    //                                                     ),
    //                                                   ),
    //                                                 ),
    //                                             ],
    //                                           ),
    //                                           SizedBox(height: 5.0),
    //                                           Text(
    //                                             data['description'] ??
    //                                                 'No description available',
    //                                             style:
    //                                                 AppWidget.LightTextFeildStyle(),
    //                                             maxLines: 2,
    //                                             overflow: TextOverflow.ellipsis,
    //                                           ),
    //                                           SizedBox(height: 5.0),
    //                                           Row(
    //                                             children: [
    //                                               Icon(
    //                                                 Icons.location_on,
    //                                                 size: 16,
    //                                                 color: Colors.red,
    //                                               ),
    //                                               SizedBox(width: 4),
    //                                               Expanded(
    //                                                 child: Text(
    //                                                   "${data['distance'].toStringAsFixed(1)} km • ${data['vendorLocation'] ?? 'Unknown Location'}",
    //                                                   style:
    //                                                       AppWidget.LightTextFeildStyle(),
    //                                                   maxLines: 1,
    //                                                   overflow:
    //                                                       TextOverflow.ellipsis,
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                           SizedBox(height: 5.0),
    //                                           Row(
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment
    //                                                     .spaceBetween,
    //                                             children: [
    //                                               Text(
    //                                                 "₹${data['price']?.toStringAsFixed(0) ?? '0'}",
    //                                                 style:
    //                                                     AppWidget.semiBoldTextFeildStyle(),
    //                                               ),
    //                                               Text(
    //                                                 "From ${data['locationSource']}",
    //                                                 style: TextStyle(
    //                                                   fontSize: 10,
    //                                                   color: Colors.grey[600],
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Shivam,", style: AppWidget.boldTextFeildStyle()),
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                "Nearby Delicious Food",
                style: AppWidget.HeadlineTextFeildStyle(),
              ),
              Text(
                "Discover food items near you",
                style: AppWidget.LightTextFeildStyle(),
              ),
              SizedBox(height: 20.0),

              // Distance Filter
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Row(
                  children: [
                    Text("Within: ", style: AppWidget.semiBoldTextFeildStyle()),
                    DropdownButton<double>(
                      value: _selectedDistance,
                      items: _distanceOptions.map((distance) {
                        return DropdownMenuItem<double>(
                          value: distance,
                          child: Text("${distance.toInt()} km"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDistance = value!;
                        });
                        if (_currentPosition != null) {
                          _loadFoodItemsWithDistance();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),

              // Food Type Categories Horizontal List
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Food Categories",
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _foodTypes.length,
                        itemBuilder: (context, index) {
                          String foodType = _foodTypes[index];
                          bool isSelected = _selectedFoodType == foodType;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFoodType = foodType;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 15.0),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.black : Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.grey[300]!,
                                  width: 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  foodType,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),

              // Category Filter (existing)
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: showItem(),
              ),
              SizedBox(height: 30.0),

              // Current Location Display (for debugging)
              if (_currentPosition != null)
                Container(
                  margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.my_location, size: 16, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Your location: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Food Items List
              _isLoadingLocation
                  ? Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            "Getting your location...",
                            style: AppWidget.LightTextFeildStyle(),
                          ),
                        ],
                      ),
                    )
                  : _currentPosition == null
                  ? Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Location access denied",
                            style: AppWidget.LightTextFeildStyle(),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Please enable location to see nearby food items",
                            style: AppWidget.LightTextFeildStyle(),
                          ),
                        ],
                      ),
                    )
                  : _isLoadingFoodItems
                  ? Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            "Finding nearby food items...",
                            style: AppWidget.LightTextFeildStyle(),
                          ),
                        ],
                      ),
                    )
                  : _getFilteredFoodItems().isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            _selectedFoodType == 'All'
                                ? 'No food items found within ${_selectedDistance.toInt()} km'
                                : 'No $_selectedFoodType items found within ${_selectedDistance.toInt()} km',
                            style: AppWidget.LightTextFeildStyle(),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try selecting different categories or increasing the distance',
                            style: AppWidget.LightTextFeildStyle(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Show total count with selected category
                        Container(
                          margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.restaurant,
                                size: 16,
                                color: Colors.green,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "${_getFilteredFoodItems().length} ${_selectedFoodType == 'All' ? '' : _selectedFoodType} food items found nearby",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                            ],
                          ),
                        ),

                        // Horizontal scroll for featured items (top 5 nearest)
                        Container(
                          height: 290,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _getFilteredFoodItems().length > 5
                                ? 5
                                : _getFilteredFoodItems().length,
                            itemBuilder: (context, index) {
                              var data = _getFilteredFoodItems()[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FoodItemDetails(foodData: data),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 15.0),
                                  width: 200,
                                  child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Category and Nearest badges
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Food type badge
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getFoodTypeColor(
                                                    data['foodType'],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  data['foodType'] ?? 'Unknown',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              // Nearest badge for first item
                                              if (index == 0)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "NEAREST",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Container(
                                              height: 120,
                                              width: double.infinity,
                                              child:
                                                  data['images'] != null &&
                                                      data['images'].isNotEmpty
                                                  ? Image.network(
                                                      data['images'][0],
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Container(
                                                              color: Colors
                                                                  .grey[200],
                                                              child: Icon(
                                                                Icons
                                                                    .restaurant,
                                                                size: 40,
                                                                color: Colors
                                                                    .grey[400],
                                                              ),
                                                            );
                                                          },
                                                    )
                                                  : Container(
                                                      color: Colors.grey[200],
                                                      child: Icon(
                                                        Icons.restaurant,
                                                        size: 40,
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            data['name'] ?? 'Unknown Item',
                                            style:
                                                AppWidget.semiBoldTextFeildStyle(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5.0),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  "${data['distance'].toStringAsFixed(1)} km away",
                                                  style:
                                                      AppWidget.LightTextFeildStyle(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.0),
                                          Text(
                                            "₹${data['price']?.toStringAsFixed(0) ?? '0'}",
                                            style:
                                                AppWidget.semiBoldTextFeildStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 30.0),

                        // Vertical list for all items
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _getFilteredFoodItems().length,
                          itemBuilder: (context, index) {
                            var data = _getFilteredFoodItems()[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FoodItemDetails(foodData: data),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: 20.0,
                                  bottom: 20.0,
                                ),
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Container(
                                            height: 120,
                                            width: 120,
                                            child:
                                                data['images'] != null &&
                                                    data['images'].isNotEmpty
                                                ? Image.network(
                                                    data['images'][0],
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Container(
                                                            color: Colors
                                                                .grey[200],
                                                            child: Icon(
                                                              Icons.restaurant,
                                                              size: 40,
                                                              color: Colors
                                                                  .grey[400],
                                                            ),
                                                          );
                                                        },
                                                  )
                                                : Container(
                                                    color: Colors.grey[200],
                                                    child: Icon(
                                                      Icons.restaurant,
                                                      size: 40,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        SizedBox(width: 20.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      data['name'] ??
                                                          'Unknown Item',
                                                      style:
                                                          AppWidget.semiBoldTextFeildStyle(),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      // Food type badge
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 6,
                                                              vertical: 2,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              _getFoodTypeColor(
                                                                data['foodType'],
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          data['foodType'] ??
                                                              'Unknown',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      if (index == 0)
                                                        Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 6,
                                                                vertical: 2,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            "NEAREST",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.0),
                                              Text(
                                                data['description'] ??
                                                    'No description available',
                                                style:
                                                    AppWidget.LightTextFeildStyle(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 5.0),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    size: 16,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      "${data['distance'].toStringAsFixed(1)} km • ${data['vendorLocation'] ?? 'Unknown Location'}",
                                                      style:
                                                          AppWidget.LightTextFeildStyle(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "₹${data['price']?.toStringAsFixed(0) ?? '0'}",
                                                    style:
                                                        AppWidget.semiBoldTextFeildStyle(),
                                                  ),
                                                  Text(
                                                    "From ${data['locationSource']}",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getFoodTypeColor(String? foodType) {
  switch (foodType?.toLowerCase()) {
    case 'vegetarian':
      return Colors.green;
    case 'non-vegetarian':
      return Colors.red;
    case 'vegan':
      return Colors.lightGreen;
    case 'beverages':
      return Colors.blue;
    case 'desserts':
      return Colors.purple;
    default:
      return Colors.grey;
  }
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
            if (_currentPosition != null) {
              _loadFoodItemsWithDistance();
            }
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
            if (_currentPosition != null) {
              _loadFoodItemsWithDistance();
            }
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
            if (_currentPosition != null) {
              _loadFoodItemsWithDistance();
            }
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
            if (_currentPosition != null) {
              _loadFoodItemsWithDistance();
            }
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
