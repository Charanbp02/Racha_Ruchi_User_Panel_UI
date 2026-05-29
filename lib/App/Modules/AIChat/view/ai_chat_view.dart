import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Models/AIChat/chat_message_model.dart';
import 'package:racharuchi/App/Modules/AIChat/controller/ai_chat_controller.dart';
import 'package:racharuchi/App/Modules/AIChat/binding/ai_chat_binding.dart';

class AIChatView extends StatelessWidget {
  const AIChatView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.find instead of GetBuilder with init
    // Make sure binding is initialized first
    if (!Get.isRegistered<AIChatController>()) {
      AIChatBinding().dependencies();
    }

    final controller = Get.find<AIChatController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(controller),
      body: Obx(
        () => Column(
          children: [
            // Chat Messages
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                itemCount:
                    controller.messages.length +
                    (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.messages.length &&
                      controller.isTyping.value) {
                    return _buildTypingIndicator();
                  }
                  final message = controller.messages[index];
                  return _buildMessageBubble(message, controller);
                },
              ),
            ),

            // Suggested Prompts (when few messages)
            if (controller.messages.length <= 2)
              _buildSuggestedPrompts(controller),

            // Input Bar
            _buildInputBar(controller),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AIChatController controller) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Iconsax.microphone_2,
              color: Color(0xFFE53935),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Recipe Assistant',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              Text(
                'Powered by Gemini AI',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left, color: Color(0xFF2D2D2D)),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.trash, color: Color(0xFFE53935)),
          onPressed: () => controller.clearChat(),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(
    ChatMessageModel message,
    AIChatController controller,
  ) {
    final isUser = message.isUser;

    return GestureDetector(
      onLongPress: () {
        if (message.status == MessageStatus.error) {
          controller.retryMessage(message);
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          left: isUser ? 60 : 0,
          right: isUser ? 0 : 60,
          bottom: 12,
        ),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Iconsax.microphone_2,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isUser ? const Color(0xFFE53935) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                isUser
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : Colors.grey.shade500,
                          ),
                        ),
                        if (isUser && message.status == MessageStatus.sending)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        if (isUser && message.status == MessageStatus.error)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Iconsax.warning_2,
                              size: 12,
                              color: Colors.white70,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE53935),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Iconsax.microphone_2, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDot(delay: Duration(milliseconds: 0)),
                SizedBox(width: 4),
                _TypingDot(delay: Duration(milliseconds: 200)),
                SizedBox(width: 4),
                _TypingDot(delay: Duration(milliseconds: 400)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedPrompts(AIChatController controller) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.suggestedPrompts.length,
        itemBuilder: (context, index) {
          final prompt = controller.suggestedPrompts[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => controller.useSuggestedPrompt(prompt),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade50,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.messages_1,
                        size: 16,
                        color: Color(0xFFE53935),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        prompt,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(AIChatController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: controller.messageController,
                  focusNode: controller.focusNode,
                  onSubmitted: (_) => controller.sendMessage(),
                  decoration: InputDecoration(
                    hintText: 'Ask about recipes...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Iconsax.attach_circle,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Get.snackbar(
                          'Coming Soon',
                          'Image attachment feature coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE53935).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon:
                      controller.isLoading.value
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Iconsax.send_1, color: Colors.white),
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () => controller.sendMessage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}

// Animated typing dot widget
class _TypingDot extends StatefulWidget {
  final Duration delay;

  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 6 * _animation.value,
          height: 6 * _animation.value,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      },
    );
  }
}
