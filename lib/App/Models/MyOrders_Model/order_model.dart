// order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OrderModel {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final double totalAmount;
  final String status;
  final List<OrderItem> items;
  final String paymentMethod;
  final String deliveryAddress;
  final String estimatedDelivery;
  final String? trackingNumber;
  final bool isRated;
  final double? rating;
  final String? review;
  final DateTime? lastUpdated;
  final DateTime? cancelledAt;
  final DateTime? deliveredAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.items,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.estimatedDelivery,
    this.trackingNumber,
    this.isRated = false,
    this.rating,
    this.review,
    this.lastUpdated,
    this.cancelledAt,
    this.deliveredAt,
  });

  // CopyWith method for updating specific fields
  OrderModel copyWith({
    String? id,
    String? orderNumber,
    DateTime? orderDate,
    double? totalAmount,
    String? status,
    List<OrderItem>? items,
    String? paymentMethod,
    String? deliveryAddress,
    String? estimatedDelivery,
    String? trackingNumber,
    bool? isRated,
    double? rating,
    String? review,
    DateTime? lastUpdated,
    DateTime? cancelledAt,
    DateTime? deliveredAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      orderDate: orderDate ?? this.orderDate,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      items: items ?? this.items,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      isRated: isRated ?? this.isRated,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      orderDate:
          json['orderDate'] is Timestamp
              ? (json['orderDate'] as Timestamp).toDate()
              : DateTime.parse(
                json['orderDate'] ?? DateTime.now().toIso8601String(),
              ),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      items:
          (json['items'] as List? ?? [])
              .map((item) => OrderItem.fromJson(item))
              .toList(),
      paymentMethod: json['paymentMethod'] ?? 'COD',
      deliveryAddress: json['deliveryAddress'] ?? '',
      estimatedDelivery: json['estimatedDelivery'] ?? '',
      trackingNumber: json['trackingNumber'],
      isRated: json['isRated'] ?? false,
      rating: json['rating']?.toDouble(),
      review: json['review'],
      lastUpdated:
          json['lastUpdated'] is Timestamp
              ? (json['lastUpdated'] as Timestamp).toDate()
              : null,
      cancelledAt:
          json['cancelledAt'] is Timestamp
              ? (json['cancelledAt'] as Timestamp).toDate()
              : null,
      deliveredAt:
          json['deliveredAt'] is Timestamp
              ? (json['deliveredAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'orderDate': orderDate.toIso8601String(),
      'totalAmount': totalAmount,
      'status': status,
      'items': items.map((item) => item.toJson()).toList(),
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress,
      'estimatedDelivery': estimatedDelivery,
      'trackingNumber': trackingNumber,
      'isRated': isRated,
      'rating': rating,
      'review': review,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  String get statusText {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF9800);
      case 'confirmed':
        return const Color(0xFF2196F3);
      case 'processing':
        return const Color(0xFF9C27B0);
      case 'shipped':
        return const Color(0xFF00BCD4);
      case 'delivered':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status.toLowerCase()) {
      case 'pending':
        return Iconsax.timer_1;
      case 'confirmed':
        return Iconsax.tick_circle;
      case 'processing':
        return Iconsax.setting_2;
      case 'shipped':
        return Iconsax.truck;
      case 'delivered':
        return Iconsax.home;
      case 'cancelled':
        return Iconsax.close_circle;
      default:
        return Iconsax.bag;
    }
  }

  String get formattedDate {
    return '${orderDate.day} ${_getMonthName(orderDate.month)} ${orderDate.year}';
  }

  String get formattedTime {
    final hour = orderDate.hour > 12 ? orderDate.hour - 12 : orderDate.hour;
    final minute = orderDate.minute.toString().padLeft(2, '0');
    final period = orderDate.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

class OrderItem {
  final String id;
  final String name;
  final String image;
  final int quantity;
  final double price;
  final String? weight;

  OrderItem({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    this.weight,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'quantity': quantity,
      'price': price,
      'weight': weight,
    };
  }

  double get totalPrice => price * quantity;
}
