import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OrderController extends GetxController {
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

  void fetchOrders() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Sample data - Replace with your actual API call
      allOrders.value = [
        {
          'orderId': 'ORD001',
          'date': '15 Jan 2024',
          'status': 'Delivered',
          'totalAmount': '450',
          'paymentMethod': 'Credit Card',
          'deliveryAddress': '123 Main St, New York, NY 10001',
          'items': [
            {
              'name': 'Butter Chicken',
              'quantity': 2,
              'price': 250,
              'imageUrl': 'https://via.placeholder.com/50',
            },
            {
              'name': 'Garlic Naan',
              'quantity': 4,
              'price': 40,
              'imageUrl': 'https://via.placeholder.com/50',
            },
            {
              'name': 'Veg Biryani',
              'quantity': 1,
              'price': 180,
              'imageUrl': 'https://via.placeholder.com/50',
            },
          ],
        },
        {
          'orderId': 'ORD002',
          'date': '10 Jan 2024',
          'status': 'Processing',
          'totalAmount': '320',
          'paymentMethod': 'Google Pay',
          'deliveryAddress': '456 Oak Ave, Los Angeles, CA 90001',
          'items': [
            {
              'name': 'Paneer Tikka',
              'quantity': 1,
              'price': 220,
              'imageUrl': 'https://via.placeholder.com/50',
            },
            {
              'name': 'Masala Chai',
              'quantity': 2,
              'price': 50,
              'imageUrl': 'https://via.placeholder.com/50',
            },
          ],
        },
        {
          'orderId': 'ORD003',
          'date': '05 Jan 2024',
          'status': 'Pending',
          'totalAmount': '890',
          'paymentMethod': 'Cash on Delivery',
          'deliveryAddress': '789 Pine Rd, Chicago, IL 60601',
          'items': [
            {
              'name': 'Chicken Biryani',
              'quantity': 2,
              'price': 320,
              'imageUrl': 'https://via.placeholder.com/50',
            },
            {
              'name': 'Raita',
              'quantity': 2,
              'price': 50,
              'imageUrl': 'https://via.placeholder.com/50',
            },
            {
              'name': 'Gulab Jamun',
              'quantity': 3,
              'price': 50,
              'imageUrl': 'https://via.placeholder.com/50',
            },
          ],
        },
        {
          'orderId': 'ORD004',
          'date': '20 Dec 2023',
          'status': 'Cancelled',
          'totalAmount': '150',
          'paymentMethod': 'Credit Card',
          'deliveryAddress': '321 Elm St, Houston, TX 77001',
          'items': [
            {
              'name': 'French Fries',
              'quantity': 1,
              'price': 150,
              'imageUrl': 'https://via.placeholder.com/50',
            },
          ],
        },
      ];

      orders.value = List.from(allOrders.value);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load orders: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
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

  void cancelOrder(String orderId) {
    Get.defaultDialog(
      title: 'Cancel Order',
      middleText: 'Are you sure you want to cancel this order?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        // Implement cancel API call
        Get.back();

        // Update the order status locally
        final index = orders.indexWhere((order) => order['orderId'] == orderId);
        if (index != -1) {
          orders[index]['status'] = 'Cancelled';
          orders.refresh();
        }

        // Also update in allOrders
        final allIndex = allOrders.indexWhere(
          (order) => order['orderId'] == orderId,
        );
        if (allIndex != -1) {
          allOrders[allIndex]['status'] = 'Cancelled';
        }

        Get.snackbar(
          'Order Cancelled',
          'Order #$orderId has been cancelled successfully',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
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
