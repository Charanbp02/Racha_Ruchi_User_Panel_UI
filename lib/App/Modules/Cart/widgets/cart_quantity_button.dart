// lib/App/Modules/Cart/widgets/cart_quantity_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class CartQuantityButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isLoading;

  const CartQuantityButton({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.grey.shade700
                : const Color(0xFFE53935).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade600 : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Iconsax.minus,
            onPressed: onDecrement,
            isDarkMode: isDarkMode,
          ),
          _buildQuantityText(isDarkMode),
          _buildButton(
            icon: Iconsax.add,
            onPressed: onIncrement,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDarkMode,
  }) {
    final isDisabled = quantity <= 1 && icon == Iconsax.minus;

    return IconButton(
      icon:
          isLoading
              ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                      isDarkMode
                          ? Colors.grey.shade300
                          : const Color(0xFFE53935),
                ),
              )
              : Icon(
                icon,
                size: 16,
                color:
                    isDisabled
                        ? (isDarkMode
                            ? Colors.grey.shade500
                            : Colors.grey.shade400)
                        : (isDarkMode
                            ? Colors.grey.shade300
                            : const Color(0xFFE53935)),
              ),
      onPressed: isDisabled ? null : onPressed,
      color:
          isDisabled
              ? (isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400)
              : (isDarkMode ? Colors.grey.shade300 : const Color(0xFFE53935)),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      splashRadius: 14,
      disabledColor: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
    );
  }

  Widget _buildQuantityText(bool isDarkMode) {
    return SizedBox(
      width: 28,
      child: Text(
        quantity.toString(),
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

// Alternative: CartQuantityButton with Stock Limit
class CartQuantityButtonWithLimit extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isLoading;

  const CartQuantityButtonWithLimit({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.onIncrement,
    required this.onDecrement,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isAtMax = quantity >= maxQuantity;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.grey.shade700
                : const Color(0xFFE53935).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade600 : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Iconsax.minus,
            onPressed: onDecrement,
            isDarkMode: isDarkMode,
            isDisabled: quantity <= 1,
          ),
          _buildQuantityText(isDarkMode),
          _buildButton(
            icon: Iconsax.add,
            onPressed: onIncrement,
            isDarkMode: isDarkMode,
            isDisabled: isAtMax,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDarkMode,
    bool isDisabled = false,
  }) {
    return IconButton(
      icon:
          isLoading
              ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                      isDarkMode
                          ? Colors.grey.shade300
                          : const Color(0xFFE53935),
                ),
              )
              : Icon(
                icon,
                size: 16,
                color:
                    isDisabled
                        ? (isDarkMode
                            ? Colors.grey.shade500
                            : Colors.grey.shade400)
                        : (isDarkMode
                            ? Colors.grey.shade300
                            : const Color(0xFFE53935)),
              ),
      onPressed: isDisabled ? null : onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      splashRadius: 14,
      disabledColor: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
    );
  }

  Widget _buildQuantityText(bool isDarkMode) {
    return SizedBox(
      width: 28,
      child: Text(
        quantity.toString(),
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

// Alternative: Animated CartQuantityButton
class AnimatedCartQuantityButton extends StatefulWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isLoading;

  const AnimatedCartQuantityButton({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.isLoading = false,
  });

  @override
  State<AnimatedCartQuantityButton> createState() =>
      _AnimatedCartQuantityButtonState();
}

class _AnimatedCartQuantityButtonState extends State<AnimatedCartQuantityButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(AnimatedCartQuantityButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quantity != oldWidget.quantity) {
      _controller.forward(from: 0).then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? Colors.grey.shade700
                : const Color(0xFFE53935).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade600 : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Iconsax.minus,
            onPressed: widget.onDecrement,
            isDarkMode: isDarkMode,
          ),
          _buildQuantityText(isDarkMode),
          _buildButton(
            icon: Iconsax.add,
            onPressed: widget.onIncrement,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDarkMode,
  }) {
    final isDisabled = widget.quantity <= 1 && icon == Iconsax.minus;

    return IconButton(
      icon:
          widget.isLoading
              ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                      isDarkMode
                          ? Colors.grey.shade300
                          : const Color(0xFFE53935),
                ),
              )
              : Icon(
                icon,
                size: 16,
                color:
                    isDisabled
                        ? (isDarkMode
                            ? Colors.grey.shade500
                            : Colors.grey.shade400)
                        : (isDarkMode
                            ? Colors.grey.shade300
                            : const Color(0xFFE53935)),
              ),
      onPressed: isDisabled ? null : onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      splashRadius: 14,
      disabledColor: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
    );
  }

  Widget _buildQuantityText(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: SizedBox(
        width: 28,
        child: Text(
          widget.quantity.toString(),
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
