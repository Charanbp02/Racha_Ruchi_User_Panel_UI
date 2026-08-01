import 'package:flutter/material.dart';

class PaymentIcons {
  static IconData getIcon(String method) {
    switch (method) {
      case 'Cash on Delivery':
        return Icons.money_outlined;
      case 'Card Payment':
        return Icons.credit_card_outlined;
      case 'UPI':
        return Icons.qr_code_scanner;
      case 'Net Banking':
        return Icons.account_balance_outlined;
      default:
        return Icons.payment_outlined;
    }
  }
}
