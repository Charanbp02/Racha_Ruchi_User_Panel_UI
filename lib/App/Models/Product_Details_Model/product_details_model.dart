// lib/App/Models/Product_Details_Model/product_details_model.dart
import 'package:flutter/material.dart';
import 'package:racharuchi/App/Models/Products_Model/products_model.dart';

class ProductDetailsModel {
  final ProductModel product;
  var selectedQuantity = 1;
  var selectedWeight = ''; // Changed from selectedSize
  var selectedImageIndex = 0;

  ProductDetailsModel({required this.product}) {
    // Auto-select first weight variant if available
    if (product.hasWeightVariants && product.weightVariants.isNotEmpty) {
      selectedWeight = product.weightVariants.first;
    }
  }

  double get totalPrice => product.price * selectedQuantity;

  String get stockStatus {
    if (!product.isInStock || product.stock == 0) return 'Out of Stock';
    if (product.stock <= 10) return 'Limited Stock';
    return 'In Stock';
  }

  Color get stockStatusColor {
    if (!product.isInStock || product.stock == 0) return Colors.red;
    if (product.stock <= 10) return Colors.orange;
    return Colors.green;
  }

  // Get all images (first is main)
  List<String> get allImages => product.images;

  // Get main image
  String get mainImage => product.mainImage;

  // Get additional images (all except first)
  List<String> get additionalImages => product.additionalImages;

  // Check if product has multiple images
  bool get hasMultipleImages => product.hasMultipleImages;

  // Check if product has weight variants
  bool get hasWeightVariants => product.hasWeightVariants;

  // Get available weight variants
  List<String> get weightVariants => product.weightVariants;
}
