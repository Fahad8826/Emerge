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
  String? _userName;
  bool _isLoadingUserName = true;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            _userName = doc.get('name') as String? ?? 'User';
            _isLoadingUserName = false;
          });
        } else {
          setState(() {
            _userName = 'User';
            _isLoadingUserName = false;
          });
        }
      } else {
        setState(() {
          _userName = 'Guest';
          _isLoadingUserName = false;
        });
      }
    } catch (e) {
      setState(() {
        _userName = 'User';
        _isLoadingUserName = false;
      });
    }
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isLoadingUserName
                      ? Text(
                          "Hello, Loading...",
                          style: AppWidget.boldTextFeildStyle(),
                        )
                      : Text(
                          "Hello, $_userName",
                          style: AppWidget.boldTextFeildStyle(),
                        ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                "Nearby Delicious Food",
                style: AppWidget.HeadlineTextFeildStyle().copyWith(
                  color: Colors.black87,
                  fontSize: 28,
                ),
              ),
              Text(
                "Discover food items near you",
                style: AppWidget.LightTextFeildStyle().copyWith(
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20.0),

              // Distance Filter
              Container(
                child: Row(
                  children: [
                    Text("Within: ", style: AppWidget.semiBoldTextFeildStyle()),
                    DropdownButton<double>(
                      value: _selectedDistance,
                      items: _distanceOptions.map((distance) {
                        return DropdownMenuItem<double>(
                          value: distance,
                          child: Text(
                            "${distance.toInt()} km",
                            style: TextStyle(fontSize: 14),
                          ),
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
                      style: AppWidget.semiBoldTextFeildStyle(),
                      dropdownColor: Colors.white,
                      underline: Container(height: 1, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),

              // Food Type Categories Horizontal List
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Food Categories",
                      style: AppWidget.semiBoldTextFeildStyle().copyWith(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Container(
                      height: 100,
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
                              width: 80,
                              margin: EdgeInsets.only(right: 12.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.black87
                                          : Colors.grey[300]!,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: _getCategoryIcon(foodType),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    foodType,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.black87
                                          : Colors.grey[600],
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
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
              SizedBox(height: 30.0),

              // Food Items List
              _isLoadingLocation
                  ? Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black87,
                            ),
                          ),
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
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black87,
                            ),
                          ),
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
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.restaurant,
                                size: 18,
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
                                margin: EdgeInsets.only(bottom: 16.0),
                                child: Material(
                                  elevation: 3.0,
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                            ),
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
                                        SizedBox(width: 16.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      data['name'] ??
                                                          'Unknown Item',
                                                      style:
                                                          AppWidget.semiBoldTextFeildStyle()
                                                              .copyWith(
                                                                fontSize: 16,
                                                              ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      // Food type badge
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              _getFoodTypeColor(
                                                                data['foodType'],
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          data['foodType'] ??
                                                              'Unknown',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 6),
                                                      if (index == 0)
                                                        Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 4,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            "NEAREST",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
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
                                              SizedBox(height: 8.0),
                                              Text(
                                                data['description'] ??
                                                    'No description available',
                                                style:
                                                    AppWidget.LightTextFeildStyle()
                                                        .copyWith(fontSize: 13),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 8.0),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    size: 16,
                                                    color: Colors.redAccent,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      "${data['distance'].toStringAsFixed(1)} km • ${data['vendorLocation'] ?? 'Unknown Location'}",
                                                      style:
                                                          AppWidget.LightTextFeildStyle()
                                                              .copyWith(
                                                                fontSize: 12,
                                                              ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "₹${data['price']?.toStringAsFixed(0) ?? '0'}",
                                                    style:
                                                        AppWidget.semiBoldTextFeildStyle()
                                                            .copyWith(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black87,
                                                            ),
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
}

Icon _getCategoryIcon(String foodType) {
  switch (foodType.toLowerCase()) {
    case 'all':
      return const Icon(Icons.restaurant_menu, color: Colors.deepOrange, size: 32);
    case 'vegetarian':
      return const Icon(Icons.eco, color: Colors.green, size: 32);
    case 'non-vegetarian':
      return const Icon(Icons.set_meal, color: Colors.red, size: 32);
    case 'vegan':
      return const Icon(Icons.spa, color: Colors.lightGreen, size: 32);
    case 'beverages':
      return const Icon(Icons.local_cafe, color: Colors.blue, size: 32);
    case 'desserts':
      return const Icon(Icons.cake, color: Colors.purple, size: 32);
    default:
      return const Icon(Icons.restaurant_menu, color: Colors.deepOrange, size: 32);
  }
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
