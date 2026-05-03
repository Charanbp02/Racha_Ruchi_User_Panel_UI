import 'package:racharuchi/App/Modules/Coupons/controller/coupons_controller.dart';

class CouponModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final String discount;
  final String minOrder;
  final String maxDiscount;
  final String validTill;
  final CouponType type;
  final String? usedOn;
  final bool isNew;
  final bool isTrending;
  final bool isExpired;

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
  });
}
