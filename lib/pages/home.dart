import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emerge_homely/pages/details.dart';
import 'package:emerge_homely/pages/wallet.dart';
import 'package:emerge_homely/widget/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
    _getCurrentLocation();
  }

  void _getCurrentUserId() {
    User? user = _auth.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      _loadSavedLocation(); // Load previously saved location
    }
  }

  Future<void> _loadSavedLocation() async {
    if (currentUserId == null) return;

    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('location')) {
          Map<String, dynamic> locationData = data['location'];
          setState(() {
            currentLatitude = locationData['latitude']?.toDouble();
            currentLongitude = locationData['longitude']?.toDouble();
            currentAddress = locationData['address'] ?? "Unknown location";
            isLoadingLocation = false;
          });
        }
      }
    } catch (e) {
      print("Error loading saved location: $e");
    }
  }

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

      // Save to Firestore
      if (currentLatitude != null && currentLongitude != null) {
        await _saveLocationToFirestore(
          currentLatitude!,
          currentLongitude!,
          currentAddress,
        );
      }
    } catch (e) {
      setState(() {
        currentAddress = "Unable to get location";
        isLoadingLocation = false;
      });
      print("Error getting location: $e");
    }
  }

  Future<void> _saveLocationToFirestore(
    double latitude,
    double longitude,
    String address,
  ) async {
    if (currentUserId == null) {
      print("User not authenticated");
      return;
    }

    try {
      await _firestore.collection('users').doc(currentUserId).set({
        'location': {
          'latitude': latitude,
          'longitude': longitude,
          'address': address,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        'userId': currentUserId,
        'lastLocationUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // merge: true to update only location fields

      print("Location saved successfully to Firestore");
    } catch (e) {
      print("Error saving location to Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save location. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      print("Getting address for coordinates: $latitude, $longitude");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Create a more detailed address
        String address = "";
        if (place.street != null && place.street!.isNotEmpty) {
          address += "${place.street}, ";
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          address += "${place.locality}, ";
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          address += place.administrativeArea!;
        }

        // Remove trailing comma and space
        if (address.endsWith(", ")) {
          address = address.substring(0, address.length - 2);
        }

        print("Formatted address: $address");

        setState(() {
          currentAddress = address.isNotEmpty ? address : "Unknown location";
          isLoadingLocation = false;
        });

        // Save updated address to Firestore
        await _saveLocationToFirestore(latitude, longitude, currentAddress);
      } else {
        setState(() {
          currentAddress = "Address not available";
          isLoadingLocation = false;
        });
      }
    } catch (e) {
      print("Error getting address from coordinates: $e");
      setState(() {
        currentAddress = "Address lookup failed";
        isLoadingLocation = false;
      });
    }
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Select Location",
            style: AppWidget.semiBoldTextFeildStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (currentUserId != null)
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "User ID: ${currentUserId!.substring(0, 8)}...",
                    style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                  ),
                ),
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
          title: Text(
            "Enter Address",
            style: AppWidget.semiBoldTextFeildStyle(),
          ),
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
                // Debug print to check if button is pressed
                print("Save button pressed");

                // Trim whitespace and check if not empty
                String inputAddress = addressController.text.trim();

                if (inputAddress.isNotEmpty) {
                  print("Address input: $inputAddress");

                  // Close dialog first
                  Navigator.of(context).pop();

                  // Then search for location
                  await _searchAndSetLocation(inputAddress);
                } else {
                  // Show error if address is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please enter an address"),
                      backgroundColor: Colors.orange,
                    ),
                  );
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

  Future<void> _searchAndSetLocation(String address) async {
    try {
      print("Searching for address: $address");

      setState(() {
        isLoadingLocation = true;
        currentAddress = "Searching...";
      });

      // Import required: import 'package:geocoding/geocoding.dart';
      List<Location> locations = await locationFromAddress(address);

      print("Found ${locations.length} locations");

      if (locations.isNotEmpty) {
        Location location = locations.first;

        print(
          "Location found - Lat: ${location.latitude}, Lng: ${location.longitude}",
        );

        setState(() {
          currentLatitude = location.latitude;
          currentLongitude = location.longitude;
        });

        // Get formatted address from coordinates
        await _getAddressFromCoordinates(location.latitude, location.longitude);

        // Save to Firestore
        await _saveLocationToFirestore(
          location.latitude,
          location.longitude,
          currentAddress,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Location updated and saved successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          currentAddress = "Address not found";
          isLoadingLocation = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Location not found. Please try a different address.",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error searching location: $e");

      setState(() {
        currentAddress = "Error occurred";
        isLoadingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error searching location: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to get all user locations (for admin or history purposes)
  Future<List<Map<String, dynamic>>> getUserLocationHistory() async {
    if (currentUserId == null) return [];

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('locationHistory')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      print("Error getting location history: $e");
      return [];
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
          icon: Icon(Icons.location_on, color: Colors.black, size: 28),
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
