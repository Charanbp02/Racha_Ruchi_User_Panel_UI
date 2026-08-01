// lib/App/Modules/Cart/widgets/price_detail_row.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class PriceDetailRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool isTotal;
  final bool isDiscount;
  final bool isDarkMode;

  const PriceDetailRow({
    super.key,
    required this.title,
    required this.amount,
    this.isTotal = false,
    this.isDiscount = false,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final darkMode =
        isDarkMode || Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildTitle(darkMode), _buildAmount(darkMode)],
      ),
    );
  }

  Widget _buildTitle(bool darkMode) {
    if (isTotal) {
      return Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: darkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      );
    }

    if (isDiscount) {
      return Row(
        children: [
          Icon(Iconsax.discount_circle, size: 14, color: Colors.green.shade600),
          const SizedBox(width: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: darkMode ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
        ],
      );
    }

    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: darkMode ? Colors.grey.shade400 : Colors.grey.shade700,
      ),
    );
  }

  Widget _buildAmount(bool darkMode) {
    if (isTotal) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          amount,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
    }

    if (isDiscount) {
      return Text(
        amount,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.green.shade600,
        ),
      );
    }

    return Text(
      amount,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: darkMode ? Colors.grey.shade300 : Colors.grey.shade700,
      ),
    );
  }
}

// Alternative: Animated PriceDetailRow
class AnimatedPriceDetailRow extends StatefulWidget {
  final String title;
  final String amount;
  final bool isTotal;
  final bool isDiscount;
  final bool isDarkMode;

  const AnimatedPriceDetailRow({
    super.key,
    required this.title,
    required this.amount,
    this.isTotal = false,
    this.isDiscount = false,
    this.isDarkMode = false,
  });

  @override
  State<AnimatedPriceDetailRow> createState() => _AnimatedPriceDetailRowState();
}

class _AnimatedPriceDetailRowState extends State<AnimatedPriceDetailRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedPriceDetailRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.amount != oldWidget.amount) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode =
        widget.isDarkMode || Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildTitle(darkMode), _buildAmount(darkMode)],
        ),
      ),
    );
  }

  Widget _buildTitle(bool darkMode) {
    if (widget.isTotal) {
      return Text(
        widget.title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: darkMode ? Colors.white : const Color(0xFF2D2D2D),
        ),
      );
    }

    if (widget.isDiscount) {
      return Row(
        children: [
          Icon(Iconsax.discount_circle, size: 14, color: Colors.green.shade600),
          const SizedBox(width: 4),
          Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: darkMode ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.title,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: darkMode ? Colors.grey.shade400 : Colors.grey.shade700,
      ),
    );
  }

  Widget _buildAmount(bool darkMode) {
    if (widget.isTotal) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.amount,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );
    }

    if (widget.isDiscount) {
      return Text(
        widget.amount,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.green.shade600,
        ),
      );
    }

    return Text(
      widget.amount,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: darkMode ? Colors.grey.shade300 : Colors.grey.shade700,
      ),
    );
  }
}

// Alternative: Compact PriceDetailRow
class CompactPriceDetailRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool isTotal;
  final bool isDiscount;
  final bool isDarkMode;

  const CompactPriceDetailRow({
    super.key,
    required this.title,
    required this.amount,
    this.isTotal = false,
    this.isDiscount = false,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final darkMode =
        isDarkMode || Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color:
                  isTotal
                      ? (darkMode ? Colors.white : const Color(0xFF2D2D2D))
                      : (isDiscount
                          ? Colors.green.shade600
                          : (darkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade700)),
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 16 : 12,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color:
                  isTotal
                      ? const Color(0xFFE53935)
                      : (isDiscount
                          ? Colors.green.shade600
                          : (darkMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade700)),
            ),
          ),
        ],
      ),
    );
  }
}
