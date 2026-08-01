import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    // If user is logged in and trying to access auth pages, redirect to home
    if (user != null && (route == '/login' || route == '/signup')) {
      return const RouteSettings(name: '/bottom-nav');
    }

    // If user is not logged in and trying to access protected pages, redirect to login
    if (user == null && route != '/login' && route != '/signup') {
      return const RouteSettings(name: '/login');
    }

    return null;
  }
}
