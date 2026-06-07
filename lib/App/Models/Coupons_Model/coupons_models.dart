// lib/App/Models/Coupons_Model/coupons_models.dart
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

enum CouponType { percentage, flat, freeDelivery, bogo }

extension CouponTypeExtension on CouponType {
  String get icon {
    switch (this) {
      case CouponType.percentage:
        return '%';
      case CouponType.flat:
        return '₹';
      case CouponType.freeDelivery:
        return '🚚';
      case CouponType.bogo:
        return '🎁';
    }
  }

  Color get color {
    switch (this) {
      case CouponType.percentage:
        return const Color(0xFF4CAF50);
      case CouponType.flat:
        return const Color(0xFFFF9800);
      case CouponType.freeDelivery:
        return const Color(0xFF2196F3);
      case CouponType.bogo:
        return const Color(0xFF9C27B0);
    }
  }

  String get displayName {
    switch (this) {
      case CouponType.percentage:
        return 'Percentage';
      case CouponType.flat:
        return 'Flat';
      case CouponType.freeDelivery:
        return 'Free Delivery';
      case CouponType.bogo:
        return 'Buy One Get One';
    }
  }
}

class CouponModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final String discount;
  final double minOrder;
  final double maxDiscount;
  final DateTime validTill;
  final CouponType type;
  final String? usedOn;
  final bool isNew;
  final bool isTrending;
  final bool isExpired;
  final bool isEnabled;
  final int usageLimit;
  final int usedCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  CouponModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discount,
    required this.minOrder,
    required this.maxDiscount,
    required this.validTill,
    required this.type,
    this.usedOn,
    this.isNew = false,
    this.isTrending = false,
    this.isExpired = false,
    this.isEnabled = true,
    this.usageLimit = 100,
    this.usedCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CouponModel.fromMap(Map<String, dynamic> map, String id) {
    return CouponModel(
      id: id,
      code: map['code'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      discount: map['discount'] ?? '',
      minOrder: (map['minOrder'] ?? 0).toDouble(),
      maxDiscount: (map['maxDiscount'] ?? 0).toDouble(),
      validTill: (map['validTill'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: CouponType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => CouponType.percentage,
      ),
      usedOn: map['usedOn'],
      isNew: map['isNew'] ?? false,
      isTrending: map['isTrending'] ?? false,
      isExpired: map['isExpired'] ?? false,
      isEnabled: map['isEnabled'] ?? true,
      usageLimit: map['usageLimit'] ?? 100,
      usedCount: map['usedCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code.toUpperCase(),
      'title': title,
      'description': description,
      'discount': discount,
      'minOrder': minOrder,
      'maxDiscount': maxDiscount,
      'validTill': Timestamp.fromDate(validTill),
      'type': type.toString(),
      'usedOn': usedOn,
      'isNew': isNew,
      'isTrending': isTrending,
      'isExpired': isExpired,
      'isEnabled': isEnabled,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Helper getters
  bool get isValid =>
      isEnabled &&
      !isExpired &&
      validTill.isAfter(DateTime.now()) &&
      usedCount < usageLimit;
  String get formattedValidTill =>
      '${validTill.day}/${validTill.month}/${validTill.year}';
  String get formattedMinOrder => '₹${minOrder.toStringAsFixed(0)}';
  String get formattedMaxDiscount =>
      type == CouponType.percentage
          ? '₹${maxDiscount.toStringAsFixed(0)}'
          : discount;

  bool canApply(double orderTotal) {
    return isValid && orderTotal >= minOrder;
  }

  double calculateDiscount(double orderTotal) {
    if (!canApply(orderTotal)) return 0;

    double discountAmount = 0;
    switch (type) {
      case CouponType.percentage:
        final percentage = double.tryParse(discount.replaceAll('%', '')) ?? 0;
        discountAmount = orderTotal * percentage / 100;
        if (discountAmount > maxDiscount) discountAmount = maxDiscount;
        break;
      case CouponType.flat:
        discountAmount = double.tryParse(discount.replaceAll('₹', '')) ?? 0;
        break;
      case CouponType.freeDelivery:
        discountAmount = 40; // Standard delivery charge
        break;
      case CouponType.bogo:
        discountAmount = orderTotal * 0.5;
        if (discountAmount > maxDiscount) discountAmount = maxDiscount;
        break;
    }
    return discountAmount;
  }
}
