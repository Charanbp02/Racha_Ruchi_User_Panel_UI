// lib/App/Models/Products_Model/products_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final double discount;
  final List<String> images; // First image is main, up to 5 images total
  final String category;
  final String subCategory;
  final String brand;
  final double rating;
  final int reviews;
  final bool isInStock;
  final int stock;
  final String sku;
  final bool isFeatured;
  final List<String>
  weightVariants; // Changed: weight variants instead of sizes/colors
  final Map<String, dynamic> specifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.images,
    required this.category,
    required this.subCategory,
    required this.brand,
    required this.rating,
    required this.reviews,
    required this.isInStock,
    required this.stock,
    required this.sku,
    required this.isFeatured,
    required this.weightVariants,
    required this.specifications,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper getters for images
  String get mainImage => images.isNotEmpty ? images.first : '';
  List<String> get additionalImages =>
      images.length > 1 ? images.sublist(1) : [];
  int get imageCount => images.length;
  bool get hasMultipleImages => images.length > 1;
  bool get isImageLimitReached => images.length >= 5;

  // Helper getters for weight variants
  bool get hasWeightVariants => weightVariants.isNotEmpty;
  String get weightVariantsDisplay => weightVariants.join(', ');
  List<String> get availableWeights => weightVariants;

  // Helper getters for stock status
  bool get isLowStock => stock <= 5 && stock > 0;
  bool get isOutOfStock => stock == 0;
  String get stockStatus {
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  Color get stockStatusColor {
    if (isOutOfStock) return Colors.red;
    if (isLowStock) return Colors.orange;
    return Colors.green;
  }

  // Helper for discount
  bool get hasDiscount => discount > 0;
  double get discountPercentage => hasDiscount ? discount : 0;
  double get savingsAmount => originalPrice - price;
  String get formattedDiscount => '${discount.toStringAsFixed(0)}% OFF';

  // Get best weight variant price (if weight variants affect pricing)
  String getCheapestWeightVariant() {
    if (!hasWeightVariants) return '';
    // This can be enhanced if weight variants have different prices
    return weightVariants.first;
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    // Ensure images is always a List<String>
    List<String> images = [];
    if (map['images'] != null) {
      if (map['images'] is List) {
        images = List<String>.from(map['images'].map((img) => img.toString()));
      } else if (map['images'] is String) {
        images = [map['images']];
      }
    }

    // Get weight variants (check both direct field and specifications)
    List<String> weightVariants = [];
    if (map['weightVariants'] != null && map['weightVariants'] is List) {
      weightVariants = List<String>.from(map['weightVariants']);
    } else if (map['specifications'] != null &&
        map['specifications']['weightVariants'] != null) {
      weightVariants = List<String>.from(
        map['specifications']['weightVariants'],
      );
    }

    // For backward compatibility: convert sizes/colors to empty list
    // (sizes and colors are deprecated but kept for compatibility)

    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      originalPrice: (map['originalPrice'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      images: images,
      category: map['category'] ?? '',
      subCategory: map['subCategory'] ?? '',
      brand: map['brand'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      reviews: map['reviews'] ?? 0,
      isInStock: map['isInStock'] ?? true,
      stock: map['stock'] ?? 0,
      sku: map['sku'] ?? '',
      isFeatured: map['isFeatured'] ?? false,
      weightVariants: weightVariants,
      specifications: Map<String, dynamic>.from(map['specifications'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'discount': discount,
      'images': images,
      'category': category,
      'subCategory': subCategory,
      'brand': brand,
      'rating': rating,
      'reviews': reviews,
      'isInStock': isInStock,
      'stock': stock,
      'sku': sku,
      'isFeatured': isFeatured,
      'weightVariants': weightVariants,
      'specifications': {...specifications, 'weightVariants': weightVariants},
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
