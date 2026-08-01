// lib/App/Modules/Home/widgets/home_loading.dart
import 'package:flutter/material.dart';

class HomeLoading extends StatelessWidget {
  const HomeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFE53935),
        strokeWidth: 2.5,
      ),
    );
  }
}
