import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;
  var orders = <Map<String, dynamic>>[].obs;
  var filteredOrders = <Map<String, dynamic>>[].obs;
  var selectedTabIndex = 0.obs;

  // Store original orders for filtering
  var allOrders = <Map<String, dynamic>>[].obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;

      if (user == null) {
        isLoading.value = false;
        return;
      }

      print("Current UID : ${user.uid}");

      final snapshot =
          await _firestore
              .collection('orders')
              .where('userId', isEqualTo: user.uid)
              .orderBy('createdAt', descending: true)
              .get();

      print("Orders Found : ${snapshot.docs.length}");

      allOrders.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        final address = data['shippingAddress'] as Map<String, dynamic>? ?? {};

        allOrders.add({
          'orderId': doc.id,
          'date': _formatDate(data['createdAt']),
          'status': _formatStatus(data['status']),
          'totalAmount': (data['total'] ?? 0).toDouble(),
          'paymentMethod': _formatPaymentMethod(data['paymentMethod']),
          'deliveryAddress':
              "${address['addressLine1'] ?? ''}, "
              "${address['addressLine2'] ?? ''}, "
              "${address['city'] ?? ''}, "
              "${address['state'] ?? ''}",
          'items': List<Map<String, dynamic>>.from(data['items'] ?? []),
        });
      }

      orders.assignAll(allOrders);

      print(orders);

      isLoading.value = false;
    } catch (e, s) {
      print(e);
      print(s);

      isLoading.value = false;

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _formatStatus(String? status) {
    switch (status) {
      case 'OrderStatus.pending':
        return 'Pending';

      case 'OrderStatus.processing':
        return 'Processing';

      case 'OrderStatus.confirmed':
        return 'Confirmed';

      case 'OrderStatus.shipped':
        return 'Shipped';

      case 'OrderStatus.delivered':
        return 'Delivered';

      case 'OrderStatus.cancelled':
        return 'Cancelled';

      default:
        return 'Pending';
    }
  }

  String _formatPaymentMethod(String? method) {
    switch (method) {
      case 'PaymentMethod.cod':
        return 'Cash on Delivery';

      case 'PaymentMethod.online':
        return 'Online Payment';

      default:
        return method ?? '';
    }
  }

  String _formatDate(dynamic value) {
    if (value == null) return '';

    DateTime date;

    if (value is Timestamp) {
      date = value.toDate();
    } else {
      date = DateTime.parse(value.toString());
    }

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

    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;

    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;

    // Filter orders based on tab
    final statuses = ['All', 'Pending', 'Processing', 'Delivered', 'Cancelled'];
    final selectedStatus = statuses[index];

    if (selectedStatus == 'All') {
      // Show all orders
      orders.value = List.from(allOrders.value);
    } else {
      // Filter orders by status
      final filtered =
          allOrders.where((order) {
            return order['status'] == selectedStatus;
          }).toList();
      orders.value = filtered;
    }
  }

  void reorder(String orderId) {
    // Find the order to reorder
    final order = allOrders.firstWhere(
      (order) => order['orderId'] == orderId,
      orElse: () => {},
    );

    if (order.isNotEmpty) {
      Get.snackbar(
        'Reorder Successful',
        'Order #$orderId has been reordered',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // You can add logic here to add items to cart
      // addToCart(order['items']);
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Cancel Order"),
        content: const Text("Are you sure you want to cancel this order?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final doc = await _firestore.collection('orders').doc(orderId).get();

      if (!doc.exists) {
        throw Exception("Order not found");
      }

      if (doc['status'] != 'OrderStatus.pending') {
        throw Exception("Only pending orders can be cancelled.");
      }

      await doc.reference.update({
        'status': 'OrderStatus.cancelled',
        'cancelledBy': 'user',
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.back(); // loading

      final index = allOrders.indexWhere((e) => e['orderId'] == orderId);

      if (index != -1) {
        allOrders[index]['status'] = 'Cancelled';
        allOrders.refresh();
      }

      changeTab(selectedTabIndex.value);

      Get.snackbar(
        "Success",
        "Order cancelled successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void viewOrderDetails(Map<String, dynamic> order) {
    final items = order['items'] as List;
    final totalItems = items.fold<int>(
      0,
      (sum, item) => sum + (item['quantity'] as int),
    );

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order Details',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        order['status'],
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order['status'],
                      style: TextStyle(
                        color: _getStatusColor(order['status']),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Order Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Order ID', order['orderId']),
                    const SizedBox(height: 8),
                    _buildDetailRow('Date', order['date']),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Payment Method',
                      order['paymentMethod'] ?? 'N/A',
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Total Items', totalItems.toString()),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Delivery Address
              const Text(
                'Delivery Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order['deliveryAddress'],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),

              // Items
              const Text(
                'Items Ordered',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          item['name'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        'x${item['quantity']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '₹${item['price'] * item['quantity']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${order['totalAmount']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE53935)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (order['status'] != 'Cancelled' &&
                      order['status'] != 'Delivered')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          cancelOrder(order['orderId']);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Cancel Order'),
                      ),
                    ),
                  if (order['status'] == 'Delivered')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          reorder(order['orderId']);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Reorder'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void refreshOrders() {
    fetchOrders();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
