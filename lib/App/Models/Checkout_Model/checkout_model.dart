// lib/App/Models/Checkout_Model/checkout_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum PaymentMethod { cod, card, upi, netBanking }

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.cod:
        return 'Cash on Delivery';
      case PaymentMethod.card:
        return 'Credit/Debit Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.netBanking:
        return 'Net Banking';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.cod:
        return Icons.money;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.upi:
        return Icons.qr_code;
      case PaymentMethod.netBanking:
        return Icons.account_balance;
    }
  }
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.outForDelivery:
        return Colors.cyan;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

class OrderItemModel {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final String? selectedWeight;
  final double total;

  OrderItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.selectedWeight,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'selectedWeight': selectedWeight,
      'total': total,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      selectedWeight: map['selectedWeight'],
      total: (map['total'] ?? 0).toDouble(),
    );
  }
}

class CheckoutModel {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryCharge;
  // ❌ tax removed
  final double discount;
  final String? couponCode;
  final double total;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final Map<String, dynamic> shippingAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  CheckoutModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    // ❌ tax removed from constructor
    required this.discount,
    this.couponCode,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryCharge': deliveryCharge,
      // ❌ tax field removed from map
      'discount': discount,
      'couponCode': couponCode,
      'total': total,
      'paymentMethod': paymentMethod.toString(),
      'status': status.toString(),
      'shippingAddress': shippingAddress,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory CheckoutModel.fromMap(Map<String, dynamic> map, String id) {
    return CheckoutModel(
      id: id,
      userId: map['userId'] ?? '',
      items:
          (map['items'] as List?)
              ?.map((e) => OrderItemModel.fromMap(e))
              .toList() ??
          [],
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      deliveryCharge: (map['deliveryCharge'] ?? 0).toDouble(),
      // ❌ tax removed from fromMap
      discount: (map['discount'] ?? 0).toDouble(),
      couponCode: map['couponCode'],
      total: (map['total'] ?? 0).toDouble(),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString() == map['paymentMethod'],
        orElse: () => PaymentMethod.cod,
      ),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      shippingAddress: Map<String, dynamic>.from(map['shippingAddress'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
