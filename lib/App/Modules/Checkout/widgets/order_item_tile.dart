import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderItemTile extends StatelessWidget {
  final dynamic item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool showWeight;
  final bool showOriginalPrice;
  final bool showRemoveButton;
  final VoidCallback? onRemove;
  final Color? accentColor;
  final bool isEditable;

  const OrderItemTile({
    Key? key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    this.showWeight = true,
    this.showOriginalPrice = true,
    this.showRemoveButton = false,
    this.onRemove,
    this.accentColor,
    this.isEditable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? const Color(0xFFE53935);
    final theme = Theme.of(context);

    // Safely extract values with null checks
    final price = _getPrice(item);
    final quantity = _getQuantity(item);
    final totalPrice = price * quantity;
    final imageUrl = _getImageUrl(item);
    final name = _getName(item);
    final weight = _getWeight(item);
    final originalPrice = _getOriginalPrice(item);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          _buildProductImage(imageUrl),
          const SizedBox(width: 14),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Remove Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: const Color(0xFF1A1A2E),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (showRemoveButton && onRemove != null)
                      InkWell(
                        onTap: onRemove,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Iconsax.close_circle,
                            size: 18,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),

                // Weight Badge
                if (showWeight && weight != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.08),
                          color.withOpacity(0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: color.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.weight, size: 10, color: color),
                        const SizedBox(width: 4),
                        Text(
                          'Weight: $weight',
                          style: TextStyle(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),

                // Quantity Controls and Price
                Row(
                  children: [
                    // Quantity Controls
                    if (isEditable) ...[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Decrement Button
                            InkWell(
                              onTap: quantity > 1 ? onDecrement : null,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(11),
                                bottomLeft: Radius.circular(11),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      quantity > 1
                                          ? Colors.transparent
                                          : Colors.grey.shade50,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(11),
                                    bottomLeft: Radius.circular(11),
                                  ),
                                ),
                                child: Icon(
                                  Iconsax.minus,
                                  size: 16,
                                  color:
                                      quantity > 1
                                          ? const Color(0xFF1A1A2E)
                                          : Colors.grey.shade400,
                                ),
                              ),
                            ),

                            // Quantity Text
                            Container(
                              width: 34,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Text(
                                  '$quantity',
                                  key: ValueKey(quantity),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                              ),
                            ),

                            // Increment Button
                            InkWell(
                              onTap: onIncrement,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(11),
                                bottomRight: Radius.circular(11),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Icon(
                                  Iconsax.add,
                                  size: 16,
                                  color: const Color(0xFF1A1A2E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Iconsax.shopping_bag,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Qty: $quantity',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Price Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Total Price
                        Text(
                          '₹${totalPrice.toStringAsFixed(0)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: color,
                            letterSpacing: -0.3,
                          ),
                        ),
                        // Original Price
                        if (showOriginalPrice &&
                            originalPrice != null &&
                            originalPrice > price)
                          Text(
                            '₹${originalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 1.5,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for safe data extraction
  dynamic _getPrice(dynamic item) {
    try {
      return item.price ?? 0.0;
    } catch (_) {
      return 0.0;
    }
  }

  dynamic _getQuantity(dynamic item) {
    try {
      return item.quantity ?? 1;
    } catch (_) {
      return 1;
    }
  }

  String _getName(dynamic item) {
    try {
      return item.name ?? 'Item';
    } catch (_) {
      return 'Item';
    }
  }

  String _getImageUrl(dynamic item) {
    try {
      return item.imageUrl ?? '';
    } catch (_) {
      return '';
    }
  }

  String? _getWeight(dynamic item) {
    try {
      return item.selectedWeight?.toString();
    } catch (_) {
      return null;
    }
  }

  double? _getOriginalPrice(dynamic item) {
    try {
      return item.originalPrice ?? item.price;
    } catch (_) {
      return null;
    }
  }

  Widget _buildProductImage(String imageUrl) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child:
            imageUrl.isNotEmpty
                ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildPlaceholder(),
                  errorWidget: (context, url, error) => _buildPlaceholder(),
                )
                : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 72,
      height: 72,
      color: Colors.grey.shade100,
      child: Icon(Iconsax.image, size: 24, color: Colors.grey.shade400),
    );
  }
}

// Simplified version for read-only order items
class OrderItemTileReadOnly extends StatelessWidget {
  final dynamic item;
  final bool showWeight;
  final bool showOriginalPrice;

  const OrderItemTileReadOnly({
    Key? key,
    required this.item,
    this.showWeight = true,
    this.showOriginalPrice = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderItemTile(
      item: item,
      onIncrement: () {},
      onDecrement: () {},
      isEditable: false,
      showWeight: showWeight,
      showOriginalPrice: showOriginalPrice,
    );
  }
}

// Cart item tile with remove functionality
class CartItemTile extends StatelessWidget {
  final dynamic item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemTile({
    Key? key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderItemTile(
      item: item,
      onIncrement: onIncrement,
      onDecrement: onDecrement,
      showRemoveButton: true,
      onRemove: onRemove,
    );
  }
}

// Usage example with different states
class OrderItemTileExample extends StatelessWidget {
  final List<dynamic> items = [
    // Your items here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: OrderItemTile(
            item: item,
            onIncrement: () {
              // Increment logic
            },
            onDecrement: () {
              // Decrement logic
            },
            showRemoveButton: true,
            onRemove: () {
              // Remove logic
            },
          ),
        );
      },
    );
  }
}
