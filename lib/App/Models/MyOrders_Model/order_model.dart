// lib/app/Modules/Orders/models/order_model.dart
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
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      orderDate: DateTime.parse(
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
    };
  }

  String get statusText {
    switch (status) {
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
    switch (status) {
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
    switch (status) {
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
