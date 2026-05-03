import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  var isLoading = false.obs;
  var lastUpdated = '29 April 2026'.obs;

  var policySections = <PolicySection>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPrivacyPolicy();
  }

  void loadPrivacyPolicy() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      policySections.value = [
        PolicySection(
          title: '1. Information We Collect',
          content: '''
We collect information you provide directly to us, such as when you create an account, place an order, or contact us for support. This may include:
• Name, email address, phone number, and delivery address
• Payment information (processed securely through our payment partners)
• Account preferences and settings
• Communications with us
• Reviews and feedback you submit''',
          icon: '📊',
        ),
        PolicySection(
          title: '2. How We Use Your Information',
          content: '''
We use the information we collect to:
• Process and deliver your orders
• Communicate with you about your orders
• Provide customer support
• Send you promotional offers and updates (with your consent)
• Improve our services and develop new features
• Protect against fraud and unauthorized transactions
• Comply with legal obligations''',
          icon: '⚙️',
        ),
        PolicySection(
          title: '3. Information Sharing',
          content: '''
We do not sell your personal information. We may share your information with:
• Delivery partners to fulfill your orders
• Payment processors to handle transactions
• Service providers who assist our operations
• Law enforcement when required by law
• With your consent''',
          icon: '🤝',
        ),
        PolicySection(
          title: '4. Data Security',
          content: '''
We implement appropriate technical and organizational measures to protect your personal information, including:
• SSL encryption for data transmission
• Secure servers and firewalls
• Regular security assessments
• Access controls and authentication
• Employee training on data protection''',
          icon: '🔒',
        ),
        PolicySection(
          title: '5. Your Rights',
          content: '''
You have the right to:
• Access your personal information
• Correct inaccurate information
• Delete your account and data
• Opt-out of marketing communications
• Data portability
• Lodge a complaint with regulatory authorities''',
          icon: '📋',
        ),
        PolicySection(
          title: '6. Cookies and Tracking',
          content: '''
We use cookies and similar technologies to:
• Remember your preferences
• Understand how you use our app
• Improve user experience
• Analyze app performance
You can manage cookie preferences through your browser settings.''',
          icon: '🍪',
        ),
        PolicySection(
          title: '7. Children\'s Privacy',
          content: '''
Our services are not directed to children under 13. We do not knowingly collect personal information from children. If you believe a child has provided us with personal information, please contact us.''',
          icon: '👶',
        ),
        PolicySection(
          title: '8. Changes to This Policy',
          content: '''
We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "last updated" date.''',
          icon: '📅',
        ),
        PolicySection(
          title: '9. Contact Us',
          content: '''
If you have questions about this privacy policy, please contact us at:
Email: privacy@racharuchi.com
Phone: +91 98765 43210
Address: 123, Food Street, Bangalore - 560001''',
          icon: '📞',
        ),
      ];
      isLoading.value = false;
    });
  }

  void acceptPolicy() {
    Get.back();
    Get.snackbar(
      'Accepted',
      'Privacy policy accepted',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}

class PolicySection {
  final String title;
  final String content;
  final String icon;
  var isExpanded = false.obs;

  PolicySection({
    required this.title,
    required this.content,
    required this.icon,
  });
}
