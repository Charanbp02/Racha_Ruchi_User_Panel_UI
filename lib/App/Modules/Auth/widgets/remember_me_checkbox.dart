import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RememberMeCheckbox extends StatelessWidget {
  final RxBool isChecked;
  final VoidCallback onTap;

  const RememberMeCheckbox({
    super.key,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isChecked.value
                          ? const Color(0xFFE53935)
                          : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isChecked.value
                            ? const Color(0xFFE53935)
                            : Colors.transparent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Remember me",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
