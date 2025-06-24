

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emerge_homely/pages/home/foodlisting.dart';

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

  List<Map<String, dynamic>> locationSuggestions = [];
  bool isSearching = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  void _getCurrentUserId() {
    User? user = _auth.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      _loadSavedLocation();
    } else {
      setState(() {
        currentAddress = "Please log in to set location";
        isLoadingLocation = false;
      });
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
      setState(() {
        currentAddress = "Error loading saved location";
        isLoadingLocation = false;
      });
    }
  }

  Future<void> _saveLocationToFirestore(
    double latitude,
    double longitude,
    String address, {
    String searchMethod = 'manual_search',
  }) async {
    if (currentUserId == null) return;

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
      }, SetOptions(merge: true));

      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('locationHistory')
          .add({
            'latitude': latitude,
            'longitude': longitude,
            'address': address,
            'timestamp': FieldValue.serverTimestamp(),
            'searchMethod': searchMethod,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Location saved successfully!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save location"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = [
          if (place.street != null && place.street!.isNotEmpty) place.street,
          if (place.locality != null && place.locality!.isNotEmpty)
            place.locality,
          if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty)
            place.administrativeArea,
          if (place.country != null && place.country!.isNotEmpty) place.country,
        ].join(', ').trim();

        setState(() {
          currentAddress = address.isNotEmpty ? address : "Address not found";
          isLoadingLocation = false;
        });

        await _saveLocationToFirestore(
          latitude,
          longitude,
          address.isNotEmpty ? address : "Address not found",
          searchMethod: 'gps',
        );
      } else {
        setState(() {
          currentAddress = "Address not found";
          isLoadingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        currentAddress = "Error fetching address";
        isLoadingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching address"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showLocationDialog() {
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please log in to set location"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blue.shade600,
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Select Location",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (currentUserId != null)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "User ID: ${currentUserId!.substring(0, 8)}...",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                if (currentLatitude != null && currentLongitude != null)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Location",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            currentAddress,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Lat: ${currentLatitude!.toStringAsFixed(6)}, Lng: ${currentLongitude!.toStringAsFixed(6)}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _getCurrentLocation();
                        },
                        icon: Icon(Icons.my_location, size: 20),
                        label: Text("Use Current"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showAddressInputDialog();
                        },
                        icon: Icon(Icons.search, size: 20),
                        label: Text("Search"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade600,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.blue.shade600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showRecentLocations();
                    },
                    icon: Icon(Icons.history, size: 20),
                    label: Text("Recent Locations"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
      currentAddress = "Getting location...";
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          currentAddress = "Location services are disabled";
          isLoadingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enable location services"),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: "Settings",
              onPressed: () => Geolocator.openLocationSettings(),
            ),
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            currentAddress = "Location permission denied";
            isLoadingLocation = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Location permission is required")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          currentAddress = "Location permission permanently denied";
          isLoadingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enable location permission in settings"),
            action: SnackBarAction(
              label: "Settings",
              onPressed: () => Geolocator.openAppSettings(),
            ),
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
      });

      await _getAddressFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        currentAddress = "Unable to get location";
        isLoadingLocation = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unable to get location")));
    }
  }

  void _showAddressInputDialog() {
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text("Please log in to search and save locations"),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    TextEditingController addressController = TextEditingController();
    Map<String, dynamic>? selectedLocation;
    Timer? searchTimer;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.8, // 80% of screen
                  minWidth: 300,
                  maxWidth: 500,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.blue.shade600,
                            size: 28,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Search Address",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: () {
                              searchTimer?.cancel();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          hintText: "Enter address...",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.blue.shade600,
                          ),
                          suffixIcon: isSearching
                              ? Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        onChanged: (value) {
                          searchTimer?.cancel();
                          selectedLocation = null;
                          if (value.trim().length > 2) {
                            searchTimer = Timer(
                              Duration(milliseconds: 500),
                              () {
                                _searchLocationSuggestions(
                                  value.trim(),
                                  setDialogState,
                                );
                              },
                            );
                          } else {
                            setDialogState(() {
                              locationSuggestions.clear();
                              isSearching = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      if (locationSuggestions.isNotEmpty)
                        Container(
                          constraints: BoxConstraints(maxHeight: 200),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: locationSuggestions.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final suggestion = locationSuggestions[index];
                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.location_on,
                                    color: Colors.red.shade600,
                                  ),
                                  title: Text(
                                    suggestion['displayName'] ?? 'Unknown',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${suggestion['locality'] ?? ''}, ${suggestion['country'] ?? ''}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  onTap: () {
                                    setDialogState(() {
                                      selectedLocation = suggestion;
                                      addressController.text =
                                          suggestion['displayName'] ?? '';
                                      locationSuggestions.clear();
                                      isSearching = false;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      if (locationSuggestions.isEmpty &&
                          !isSearching &&
                          addressController.text.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "No results found. Try a different search term.",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                searchTimer?.cancel();
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey.shade600,
                                padding: EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                String inputAddress = addressController.text
                                    .trim();
                                if (inputAddress.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Please enter or select an address",
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }
                                searchTimer?.cancel();
                                if (selectedLocation != null) {
                                  await _saveLocationToFirestore(
                                    selectedLocation!['latitude']?.toDouble() ??
                                        0.0,
                                    selectedLocation!['longitude']
                                            ?.toDouble() ??
                                        0.0,
                                    selectedLocation!['displayName'] ??
                                        inputAddress,
                                    searchMethod: 'manual_search',
                                  );
                                  setState(() {
                                    currentLatitude =
                                        selectedLocation!['latitude']
                                            ?.toDouble();
                                    currentLongitude =
                                        selectedLocation!['longitude']
                                            ?.toDouble();
                                    currentAddress =
                                        selectedLocation!['displayName'] ??
                                        inputAddress;
                                    isLoadingLocation = false;
                                  });
                                  Navigator.of(context).pop();
                                } else {
                                  Navigator.of(context).pop();
                                  await _searchAndSetLocation(inputAddress);
                                }
                              },
                              child: Text("Save"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) => searchTimer?.cancel());
  }

  Future<void> _searchLocationSuggestions(
    String query,
    StateSetter setDialogState,
  ) async {
    setDialogState(() => isSearching = true);
    try {
      List<Location> locations = await locationFromAddress(query);
      List<Map<String, dynamic>> suggestions = [];
      for (Location location in locations.take(5)) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String displayName = [
            if (place.name != null && place.name!.isNotEmpty) place.name,
            if (place.street != null &&
                place.street!.isNotEmpty &&
                place.street != place.name)
              place.street,
            if (place.locality != null && place.locality!.isNotEmpty)
              place.locality,
            if (place.administrativeArea != null &&
                place.administrativeArea!.isNotEmpty)
              place.administrativeArea,
            if (place.country != null && place.country!.isNotEmpty)
              place.country,
          ].join(', ').trim();

          suggestions.add({
            'displayName': displayName.isNotEmpty ? displayName : query,
            'locality': place.locality ?? '',
            'country': place.country ?? '',
            'latitude': location.latitude,
            'longitude': location.longitude,
          });
        }
      }
      setDialogState(() {
        locationSuggestions = suggestions;
        isSearching = false;
      });
    } catch (e) {
      setDialogState(() {
        locationSuggestions = [];
        isSearching = false;
      });
    }
  }

  Future<void> _searchAndSetLocation(String address) async {
    setState(() {
      isLoadingLocation = true;
      currentAddress = "Searching...";
    });
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        await _saveLocationToFirestore(
          location.latitude,
          location.longitude,
          address,
          searchMethod: 'manual_search',
        );
        setState(() {
          currentLatitude = location.latitude;
          currentLongitude = location.longitude;
          currentAddress = address;
          isLoadingLocation = false;
        });
      } else {
        setState(() {
          currentAddress = "Address not found";
          isLoadingLocation = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Location not found")));
      }
    } catch (e) {
      setState(() {
        currentAddress = "Error occurred";
        isLoadingLocation = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error searching location")));
    }
  }

  void _showRecentLocations() async {
    if (currentUserId == null) return;

    try {
      QuerySnapshot recentLocations = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('locationHistory')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();

      List<Map<String, dynamic>> locations = recentLocations.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, color: Colors.blue.shade600, size: 28),
                    SizedBox(width: 10),
                    Text(
                      "Recent Locations",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 250,
                  child: ListView.builder(
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      final location = locations[index];
                      return Card(
                        elevation: 1,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.red.shade600,
                          ),
                          title: Text(
                            location['address'] ?? 'Unknown',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "Lat: ${location['latitude']?.toStringAsFixed(4)}, Lng: ${location['longitude']?.toStringAsFixed(4)}",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          onTap: () {
                            setState(() {
                              currentLatitude = location['latitude']
                                  ?.toDouble();
                              currentLongitude = location['longitude']
                                  ?.toDouble();
                              currentAddress = location['address'] ?? 'Unknown';
                              isLoadingLocation = false;
                            });
                            Navigator.of(context).pop();
                            if (currentLatitude != null &&
                                currentLongitude != null) {
                              _saveLocationToFirestore(
                                currentLatitude!,
                                currentLongitude!,
                                currentAddress,
                                searchMethod: 'history',
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.blue.shade600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading recent locations")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: GestureDetector(
          onTap: _showLocationDialog,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue.shade600, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Deliver to",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              isLoadingLocation
                                  ? "Getting location..."
                                  : currentAddress,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
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
      body: FoodItemsPage(),
    );
  }
}
