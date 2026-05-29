import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/HelpSupport_Model/helpsupport_model.dart';
import '../controller/help_support_controller.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final HelpSupportController controller = Get.put(HelpSupportController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text(
            'Help & Support',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF2D2D2D),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left, color: Color(0xFF2D2D2D)),
            onPressed: () => Get.back(),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFFE53935),
            labelColor: Color(0xFFE53935),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'FAQs'),
              Tab(text: 'Contact Us'),
              Tab(text: 'Support Tickets'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // FAQs Tab
            _buildFaqsTab(controller),

            // Contact Us Tab
            _buildContactUsTab(controller),

            // Support Tickets Tab
            _buildSupportTicketsTab(controller),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.createSupportTicket('', ''),
          backgroundColor: const Color(0xFFE53935),
          child: const Icon(Iconsax.message, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFaqsTab(HelpSupportController controller) {
    return Column(
      children: [
        // Search Bar
        _buildSearchBar(controller),
        const SizedBox(height: 12),

        // Categories
        _buildCategories(controller),
        const SizedBox(height: 12),

        // FAQs List
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFE53935)),
              );
            }

            if (controller.filteredFaqs.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.filteredFaqs.length,
              itemBuilder: (context, index) {
                final faq = controller.filteredFaqs[index];
                return _buildFaqCard(faq, controller);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSearchBar(HelpSupportController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) => controller.searchFaqs(value),
        decoration: InputDecoration(
          hintText: 'Search FAQs...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(
            Iconsax.search_normal,
            size: 20,
            color: Colors.grey,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE53935)),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(HelpSupportController controller) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.faqCategories.length,
        itemBuilder: (context, index) {
          final category = controller.faqCategories[index];
          final isSelected = controller.selectedCategory.value == category;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => controller.setCategory(category),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE53935) : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color:
                        isSelected ? Colors.transparent : Colors.grey.shade200,
                    width: 1,
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: const Color(
                                0xFFE53935,
                              ).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFaqCard(FaqModel faq, HelpSupportController controller) {
    final isExpanded = controller.expandedFaqId.value == faq.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            if (expanded) {
              controller.toggleFaq(faq.id);
            } else {
              controller.expandedFaqId.value = '';
            }
          },
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Iconsax.message_question,
              size: 20,
              color: Color(0xFFE53935),
            ),
          ),
          title: Text(
            faq.question,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                faq.answer,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactUsTab(HelpSupportController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Contact Cards
          _buildContactCard(
            icon: Iconsax.call,
            title: 'Call Us',
            subtitle: controller.contactInfo.value.phone,
            color: Colors.green,
            onTap: () => controller.callSupport(),
          ),
          const SizedBox(height: 12),

          _buildContactCard(
            icon: Iconsax.message,
            title: 'WhatsApp',
            subtitle: controller.contactInfo.value.whatsapp,
            color: Colors.green,
            onTap: () => controller.whatsappSupport(),
          ),
          const SizedBox(height: 12),

          _buildContactCard(
            icon: Iconsax.directbox_send,
            title: 'Email Us',
            subtitle: controller.contactInfo.value.email,
            color: Colors.blue,
            onTap: () => controller.emailSupport(),
          ),
          const SizedBox(height: 24),

          // Office Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Office Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Iconsax.location,
                      size: 20,
                      color: Color(0xFFE53935),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        controller.contactInfo.value.address,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Iconsax.clock,
                      size: 20,
                      color: Color(0xFFE53935),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        controller.contactInfo.value.workingHours,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Other Options
          _buildActionCard(
            icon: Iconsax.star,
            title: 'Rate Us',
            subtitle: 'Rate Racha Ruchi on Play Store',
            onTap: () => controller.rateApp(),
          ),
          const SizedBox(height: 12),

          _buildActionCard(
            icon: Iconsax.share,
            title: 'Share App',
            subtitle: 'Share Racha Ruchi with friends',
            onTap: () => controller.shareApp(),
          ),
          const SizedBox(height: 12),

          _buildActionCard(
            icon: Iconsax.info_circle,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () => controller.aboutApp(),
          ),
          const SizedBox(height: 12),

          _buildActionCard(
            icon: Iconsax.document_text,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () => controller.aboutApp(),
          ),
          const SizedBox(height: 12),

          _buildActionCard(
            icon: Iconsax.document_text,
            title: 'Terms & Conditions',
            subtitle: 'Read terms and conditions',
            onTap: () => controller.aboutApp(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSupportTicketsTab(HelpSupportController controller) {
    return Obx(
      () =>
          controller.supportTickets.isEmpty
              ? _buildNoTicketsState()
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.supportTickets.length,
                itemBuilder: (context, index) {
                  final ticket = controller.supportTickets[index];
                  return _buildTicketCard(ticket);
                },
              ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_right_3, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: const Color(0xFFE53935)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_right_3, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(SupportTicketModel ticket) {
    Color statusColor;
    switch (ticket.status) {
      case 'Resolved':
        statusColor = Colors.green;
        break;
      case 'In Progress':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ticket #${ticket.id}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ticket.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(ticket.subject, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Iconsax.calendar, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Created: ${ticket.createdAt}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              const Icon(Iconsax.clock, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Updated: ${ticket.lastUpdated}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.document_text,
              size: 60,
              color: Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No FAQs Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildNoTicketsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.ticket,
              size: 60,
              color: Color(0xFFE53935),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Support Tickets',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a ticket for any issues',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed:
                () => Get.find<HelpSupportController>().createSupportTicket(
                  '',
                  '',
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Create Ticket'),
          ),
        ],
      ),
    );
  }
}
