import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Models/HelpSupport_Model/helpsupport_model.dart';

class HelpSupportController extends GetxController {
  var isLoading = false.obs;
  var selectedCategory = 'General'.obs;
  var searchQuery = ''.obs;

  var faqCategories =
      <String>[
        'General',
        'Orders',
        'Payment',
        'Delivery',
        'Returns & Refunds',
        'Account',
        'Technical',
      ].obs;

  var allFaqs = <FaqModel>[].obs;
  var filteredFaqs = <FaqModel>[].obs;
  var expandedFaqId = ''.obs;

  var supportTickets = <SupportTicketModel>[].obs;

  // Contact Info
  var contactInfo =
      ContactInfo(
        email: 'support@racharuchi.com',
        phone: '+91 98765 43210',
        whatsapp: '+91 98765 43210',
        address: '123, Food Street, Bangalore - 560001',
        workingHours: 'Mon - Sat, 9:00 AM - 8:00 PM',
      ).obs;

  @override
  void onInit() {
    super.onInit();
    loadFaqs();
    loadSupportTickets();
  }

  void loadFaqs() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      allFaqs.value = [
        FaqModel(
          id: '1',
          category: 'General',
          question: 'What is Racha Ruchi?',
          answer:
              'Racha Ruchi is a food delivery platform that brings delicious home-cooked meals and restaurant dishes to your doorstep.',
        ),
        FaqModel(
          id: '2',
          category: 'General',
          question: 'How do I create an account?',
          answer:
              'You can create an account by clicking on the Profile icon and selecting "Sign Up". You can sign up using your email, phone number, or social media accounts.',
        ),
        FaqModel(
          id: '3',
          category: 'Orders',
          question: 'How do I track my order?',
          answer:
              'You can track your order in real-time from the "My Orders" section. Click on your active order to see the live status and delivery partner location.',
        ),
        FaqModel(
          id: '4',
          category: 'Orders',
          question: 'Can I cancel my order?',
          answer:
              'Yes, you can cancel your order within 2 minutes of placing it. Go to "My Orders" and click on "Cancel Order". Cancellation after that may incur charges.',
        ),
        FaqModel(
          id: '5',
          category: 'Payment',
          question: 'What payment methods are accepted?',
          answer:
              'We accept多种 payment methods including Credit/Debit Cards, UPI, Net Banking, Wallet, and Cash on Delivery.',
        ),
        FaqModel(
          id: '6',
          category: 'Payment',
          question: 'Is it safe to pay online?',
          answer:
              'Yes, we use secure payment gateways with 128-bit SSL encryption to ensure your payment information is safe and secure.',
        ),
        FaqModel(
          id: '7',
          category: 'Delivery',
          question: 'What is the delivery time?',
          answer:
              'Standard delivery time is 30-45 minutes depending on your location and restaurant preparation time.',
        ),
        FaqModel(
          id: '8',
          category: 'Delivery',
          question: 'Is there free delivery?',
          answer:
              'Free delivery is available on orders above ₹399. Check the app for special offers and free delivery coupons.',
        ),
        FaqModel(
          id: '9',
          category: 'Returns & Refunds',
          question: 'What is your refund policy?',
          answer:
              'If you receive damaged or incorrect items, you can request a refund within 24 hours. Refunds are processed within 5-7 business days.',
        ),
        FaqModel(
          id: '10',
          category: 'Returns & Refunds',
          question: 'How do I request a refund?',
          answer:
              'Go to "My Orders", select the order, and click on "Request Refund". Provide the reason and supporting photos if any.',
        ),
        FaqModel(
          id: '11',
          category: 'Account',
          question: 'How do I change my password?',
          answer:
              'Go to Profile → Settings → Change Password. Enter your current password and new password to update.',
        ),
        FaqModel(
          id: '12',
          category: 'Account',
          question: 'How do I delete my account?',
          answer:
              'To delete your account, please contact our support team. Account deletion is permanent and cannot be undone.',
        ),
        FaqModel(
          id: '13',
          category: 'Technical',
          question: 'App is crashing, what to do?',
          answer:
              'Try clearing app cache, updating to the latest version, or reinstalling the app. If issue persists, contact support.',
        ),
        FaqModel(
          id: '14',
          category: 'Technical',
          question: 'How to update the app?',
          answer:
              'Visit Play Store (Android) or App Store (iOS) and check for updates. Enable auto-updates for seamless experience.',
        ),
      ];
      applyFilters();
      isLoading.value = false;
    });
  }

  void loadSupportTickets() {
    supportTickets.value = [
      SupportTicketModel(
        id: '1',
        subject: 'Order delayed',
        status: 'Resolved',
        createdAt: '2024-03-15',
        lastUpdated: '2024-03-16',
      ),
      SupportTicketModel(
        id: '2',
        subject: 'Wrong item delivered',
        status: 'In Progress',
        createdAt: '2024-03-20',
        lastUpdated: '2024-03-21',
      ),
      SupportTicketModel(
        id: '3',
        subject: 'Payment issue',
        status: 'Open',
        createdAt: '2024-03-25',
        lastUpdated: '2024-03-25',
      ),
    ];
  }

  void applyFilters() {
    var filtered = allFaqs.toList();

    if (searchQuery.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (faq) =>
                    faq.question.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ||
                    faq.answer.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ),
              )
              .toList();
    } else if (selectedCategory.value != 'General') {
      filtered =
          filtered
              .where((faq) => faq.category == selectedCategory.value)
              .toList();
    }

    filteredFaqs.value = filtered;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    searchQuery.value = '';
    applyFilters();
  }

  void searchFaqs(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void clearSearch() {
    searchQuery.value = '';
    applyFilters();
  }

  void toggleFaq(String id) {
    if (expandedFaqId.value == id) {
      expandedFaqId.value = '';
    } else {
      expandedFaqId.value = id;
    }
  }

  void createSupportTicket(String subject, String message) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Create Support Ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Ticket Created',
                'Support ticket has been created successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void sendFeedback() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Your Feedback',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Rating:'),
                const SizedBox(width: 8),
                Row(
                  children: List.generate(
                    5,
                    (index) => IconButton(
                      icon: Icon(
                        Icons.star,
                        color: index < 4 ? Colors.amber : Colors.grey,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Thank You!',
                'Your feedback has been submitted',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void callSupport() {
    // Implement phone call
    Get.snackbar(
      'Call Support',
      'Calling support team...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void whatsappSupport() {
    // Implement WhatsApp
    Get.snackbar(
      'WhatsApp Support',
      'Opening WhatsApp...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void emailSupport() {
    // Implement email
    Get.snackbar(
      'Email Support',
      'Opening email app...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void rateApp() {
    Get.snackbar(
      'Rate App',
      'Thank you for rating us!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void shareApp() {
    Get.snackbar(
      'Share App',
      'Sharing Racha Ruchi app...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void aboutApp() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('About Racha Ruchi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'RR',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Racha Ruchi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text(
              'Your favorite food delivery app',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              '© 2024 Racha Ruchi. All rights reserved.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }
}

