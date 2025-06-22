// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ServicesPage extends StatefulWidget {
//   @override
//   _ServicesPageState createState() => _ServicesPageState();
// }

// class _ServicesPageState extends State<ServicesPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String _selectedServiceType = 'All';
//   List<String> _serviceTypes = [
//     'All',
//     'Home Services',
//     'Professional',
//     'Beauty & Wellness',
//     'Repair',
//     'Tutoring',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text('Services', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.location_on_outlined),
//             onPressed: () {
//               // Location selector
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.notifications_outlined),
//             onPressed: () {
//               // Notifications
//             },
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(60),
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Search services...',
//                         prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(vertical: 10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Icon(Icons.filter_list, color: Colors.grey[600]),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Service type filter
//           Container(
//             height: 60,
//             color: Colors.white,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               itemCount: _serviceTypes.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: EdgeInsets.only(right: 8),
//                   child: FilterChip(
//                     label: Text(_serviceTypes[index]),
//                     selected: _selectedServiceType == _serviceTypes[index],
//                     onSelected: (selected) {
//                       setState(() {
//                         _selectedServiceType = _serviceTypes[index];
//                       });
//                     },
//                     selectedColor: Colors.purple[100],
//                     checkmarkColor: Colors.purple,
//                   ),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('Products')
//                   .where('category', isEqualTo: 'Services')
//                   .where('isAvailable', isEqualTo: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(color: Colors.purple),
//                   );
//                 }

//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.handyman_outlined,
//                           size: 80,
//                           color: Colors.grey[400],
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           'No services available',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Check back later for new services',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[500],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 // Filter services based on selected type
//                 List<QueryDocumentSnapshot> filteredServices =
//                     snapshot.data!.docs;
//                 if (_selectedServiceType != 'All') {
//                   filteredServices = filteredServices.where((doc) {
//                     Map<String, dynamic> data =
//                         doc.data() as Map<String, dynamic>;
//                     return data['serviceType'] == _selectedServiceType;
//                   }).toList();
//                 }

//                 return ListView.builder(
//                   padding: EdgeInsets.all(16),
//                   itemCount: filteredServices.length,
//                   itemBuilder: (context, index) {
//                     Map<String, dynamic> service =
//                         filteredServices[index].data() as Map<String, dynamic>;

//                     return Card(
//                       margin: EdgeInsets.only(bottom: 16),
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: InkWell(
//                         onTap: () {
//                           // Navigate to service details
//                           _navigateToServiceDetails(
//                             filteredServices[index].id,
//                             service,
//                           );
//                         },
//                         borderRadius: BorderRadius.circular(12),
//                         child: Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Row(
//                             children: [
//                               // Service Image
//                               Container(
//                                 width: 80,
//                                 height: 80,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   color: Colors.grey[200],
//                                 ),
//                                 child: service['imageUrl'] != null
//                                     ? ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.network(
//                                           service['imageUrl'],
//                                           fit: BoxFit.cover,
//                                           errorBuilder:
//                                               (context, error, stackTrace) {
//                                                 return Icon(
//                                                   Icons.handyman,
//                                                   size: 40,
//                                                   color: Colors.grey[400],
//                                                 );
//                                               },
//                                         ),
//                                       )
//                                     : Icon(
//                                         Icons.handyman,
//                                         size: 40,
//                                         color: Colors.grey[400],
//                                       ),
//                               ),
//                               SizedBox(width: 16),
//                               // Service Details
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       service['name'] ?? 'Service Name',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       service['description'] ??
//                                           'No description available',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.star,
//                                           size: 16,
//                                           color: Colors.amber,
//                                         ),
//                                         SizedBox(width: 4),
//                                         Text(
//                                           '${service['rating'] ?? '0.0'}',
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         SizedBox(width: 8),
//                                         Text(
//                                           '(${service['reviewCount'] ?? '0'} reviews)',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             color: Colors.grey[500],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // Price and Action
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     '₹${service['price'] ?? '0'}',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.purple,
//                                     ),
//                                   ),
//                                   SizedBox(height: 4),
//                                   Text(
//                                     service['priceUnit'] ?? 'per hour',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey[500],
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       _bookService(
//                                         filteredServices[index].id,
//                                         service,
//                                       );
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.purple,
//                                       foregroundColor: Colors.white,
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                         vertical: 8,
//                                       ),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       'Book',
//                                       style: TextStyle(fontSize: 12),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _navigateToServiceDetails(
//     String serviceId,
//     Map<String, dynamic> service,
//   ) {
//     // Navigate to service details page
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             ServiceDetailsPage(serviceId: serviceId, service: service),
//       ),
//     );
//   }

//   void _bookService(String serviceId, Map<String, dynamic> service) {
//     // Show booking dialog or navigate to booking page
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Book Service'),
//           content: Text('Do you want to book "${service['name']}"?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 // Handle booking logic here
//                 _handleBooking(serviceId, service);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.purple,
//                 foregroundColor: Colors.white,
//               ),
//               child: Text('Confirm'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _handleBooking(String serviceId, Map<String, dynamic> service) {
//     // Implement booking logic
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Booking request sent for ${service['name']}'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
// }

// // Placeholder for ServiceDetailsPage
// class ServiceDetailsPage extends StatelessWidget {
//   final String serviceId;
//   final Map<String, dynamic> service;

//   const ServiceDetailsPage({
//     Key? key,
//     required this.serviceId,
//     required this.service,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(service['name'] ?? 'Service Details'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: Center(child: Text('Service Details Page - Implementation needed')),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedServiceType = 'All';
  List<String> _serviceTypes = ['All', 'Home Services', 'Professional', 'Beauty & Wellness', 'Repair', 'Tutoring'];
  
  Position? _currentPosition;
  bool _isLoadingLocation = true;
  double _maxDistance = 10.0; // Default 10km radius
  List<double> _distanceOptions = [1.0, 5.0, 10.0, 15.0, 20.0];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radius of Earth in kilometers
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello Shivam,", 
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        )),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(_isLoadingLocation 
                            ? "Getting location..." 
                            : "Within ${_maxDistance.toInt()} km",
                            style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              
              // Title Section
              Text("Professional Services", 
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )),
              Text("Discover and Book Great Services",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                )),
              SizedBox(height: 20.0),
              
              // Search Bar
              Container(
                margin: EdgeInsets.only(right: 20.0),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search services...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              
              // Distance Filter
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Row(
                  children: [
                    Text("Distance: ", 
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _distanceOptions.map((distance) {
                            return Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text("${distance.toInt()}km"),
                                selected: _maxDistance == distance,
                                onSelected: (selected) {
                                  setState(() {
                                    _maxDistance = distance;
                                  });
                                },
                                selectedColor: Colors.purple[100],
                                checkmarkColor: Colors.purple,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              
              // Service Type Filter
              Container(
                margin: EdgeInsets.only(right: 20.0), 
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _serviceTypes.map((type) {
                      bool isSelected = _selectedServiceType == type;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedServiceType = type;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.purple : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              
              // Services List
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Products')
                    .where('category', isEqualTo: 'Services')
                    .where('isAvailable', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.purple),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.handyman_outlined, 
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No services available',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  List<QueryDocumentSnapshot> services = snapshot.data!.docs;
                  
                  // Filter and sort services
                  List<Map<String, dynamic>> servicesWithDistance = [];
                  
                  for (var doc in services) {
                    Map<String, dynamic> service = doc.data() as Map<String, dynamic>;
                    service['id'] = doc.id;
                    
                    // Apply service type filter
                    if (_selectedServiceType != 'All' && 
                        service['serviceType'] != _selectedServiceType) {
                      continue;
                    }
                    
                    // Apply search filter
                    if (_searchQuery.isNotEmpty) {
                      String serviceName = (service['name'] ?? '').toLowerCase();
                      String serviceDesc = (service['description'] ?? '').toLowerCase();
                      if (!serviceName.contains(_searchQuery) && 
                          !serviceDesc.contains(_searchQuery)) {
                        continue;
                      }
                    }
                    
                    // Calculate distance
                    double distance = 0.0;
                    if (_currentPosition != null && 
                        service['latitude'] != null && 
                        service['longitude'] != null) {
                      distance = _calculateDistance(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                        service['latitude'].toDouble(),
                        service['longitude'].toDouble(),
                      );
                      
                      // Apply distance filter
                      if (distance > _maxDistance) {
                        continue;
                      }
                    }
                    
                    service['distance'] = distance;
                    servicesWithDistance.add(service);
                  }
                  
                  // Sort by distance
                  servicesWithDistance.sort((a, b) => 
                    a['distance'].compareTo(b['distance']));

                  if (servicesWithDistance.isEmpty) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No services found nearby',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Try increasing the distance or changing filters',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: servicesWithDistance.map((service) {
                      return _buildServiceCard(service);
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: InkWell(
            onTap: () {
              _navigateToServiceDetails(service['id'], service);
            },
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: service['imageUrl'] != null
                          ? Image.network(
                              service['imageUrl'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.handyman,
                                  size: 40,
                                  color: Colors.grey[400],
                                );
                              },
                            )
                          : Icon(
                              Icons.handyman,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                    ),
                  ),
                  SizedBox(width: 16),
                  
                  // Service Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service['name'] ?? 'Service Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        
                        // Distance and Service Type
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.purple),
                            SizedBox(width: 4),
                            Text(
                              '${service['distance'].toStringAsFixed(1)} km away',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.purple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                service['serviceType'] ?? 'Service',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        
                        Text(
                          service['description'] ?? 'No description available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        
                        // Rating and Price Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                SizedBox(width: 4),
                                Text(
                                  '${service['rating'] ?? '4.0'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '(${service['reviewCount'] ?? '0'})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '₹${service['price'] ?? '0'}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
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
      ),
    );
  }

  void _navigateToServiceDetails(String serviceId, Map<String, dynamic> service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailsPage(
          serviceId: serviceId,
          service: service,
        ),
      ),
    );
  }
}

// Service Details Page
class ServiceDetailsPage extends StatelessWidget {
  final String serviceId;
  final Map<String, dynamic> service;

  const ServiceDetailsPage({
    Key? key,
    required this.serviceId,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image
            Container(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: service['imageUrl'] != null
                        ? Image.network(
                            service['imageUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.handyman,
                                size: 80,
                                color: Colors.grey[400],
                              );
                            },
                          )
                        : Icon(
                            Icons.handyman,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Service Details
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'] ?? 'Service Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    service['description'] ?? 'No description available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.purple),
                      SizedBox(width: 8),
                      Text(
                        '${service['distance']?.toStringAsFixed(1) ?? '0.0'} km away',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.purple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  
                  // Book Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _showBookingDialog(context, service);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Book for ₹${service['price'] ?? '0'}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context, Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Book Service'),
          content: Text('Do you want to book "${service['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking confirmed for ${service['name']}!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}