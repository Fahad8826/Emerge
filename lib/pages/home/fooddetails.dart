import 'package:emerge_homely/widget/widget_support.dart';
import 'package:flutter/material.dart';

class FoodItemDetails extends StatefulWidget {
  final Map<String, dynamic> foodData;

  const FoodItemDetails({Key? key, required this.foodData}) : super(key: key);

  @override
  State<FoodItemDetails> createState() => _FoodItemDetailsState();
}

class _FoodItemDetailsState extends State<FoodItemDetails> {
  int quantity = 1;
  int selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                Container(
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

            // Food Images
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  // Main image
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          widget.foodData['images'] != null &&
                              widget.foodData['images'].isNotEmpty
                          ? Image.network(
                              widget.foodData['images'][selectedImageIndex],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.restaurant,
                                    size: 100,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.restaurant,
                                size: 100,
                                color: Colors.grey[400],
                              ),
                            ),
                    ),
                  ),

                  // Image indicators (if multiple images)
                  if (widget.foodData['images'] != null &&
                      widget.foodData['images'].length > 1)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.foodData['images'].length,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImageIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedImageIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Distance badge
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${widget.foodData['distance']?.toStringAsFixed(1) ?? '0.0'} km",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.0),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food name and veg/non-veg indicator
                    Row(
                      children: [
                        // Veg/Non-veg indicator
                        if (widget.foodData['foodType'] != null)
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: widget.foodData['foodType'] == 'Veg'
                                    ? Colors.green
                                    : Colors.red,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: widget.foodData['foodType'] == 'Veg'
                                      ? Colors.green
                                      : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.foodData['name'] ?? 'Unknown Item',
                            style: AppWidget.HeadlineTextFeildStyle(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.0),

                    // Cuisine type
                    if (widget.foodData['cuisineType'] != null)
                      Text(
                        widget.foodData['cuisineType'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    SizedBox(height: 10.0),

                    // Rating and preparation time
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 5),
                        Text(
                          "4.2 (120 reviews)", // You can add rating field to your data
                          style: AppWidget.LightTextFeildStyle(),
                        ),
                        SizedBox(width: 20),
                        if (widget.foodData['preparationTime'] != null)
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.grey[600],
                                size: 16,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "${widget.foodData['preparationTime']} min",
                                style: AppWidget.LightTextFeildStyle(),
                              ),
                            ],
                          ),
                      ],
                    ),

                    SizedBox(height: 20.0),

                    // Description
                    Text(
                      "Description",
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      widget.foodData['description'] ??
                          'No description available',
                      style: AppWidget.LightTextFeildStyle(),
                    ),

                    SizedBox(height: 20.0),

                    // Ingredients (if available)
                    if (widget.foodData['ingredients'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ingredients",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            widget.foodData['ingredients'],
                            style: AppWidget.LightTextFeildStyle(),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),

                    // Nutritional info (if available)
                    if (widget.foodData['calories'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nutritional Information",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${widget.foodData['calories']} cal",
                                  style: AppWidget.LightTextFeildStyle(),
                                ),
                              ),
                              if (widget.foodData['protein'] != null)
                                SizedBox(width: 10),
                              if (widget.foodData['protein'] != null)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${widget.foodData['protein']}g protein",
                                    style: AppWidget.LightTextFeildStyle(),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom bar with price and add to cart
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Quantity selector
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.remove, size: 20),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      quantity.toString(),
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.add, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 20),

            // Price and Add to Cart
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: AppWidget.LightTextFeildStyle(),
                      ),
                      Text(
                        "₹${((widget.foodData['price'] ?? 0) * quantity).toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () {
                      // Add to cart functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${widget.foodData['name']} added to cart!',
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Add to Cart",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
}
