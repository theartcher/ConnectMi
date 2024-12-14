import 'package:connect_mi/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Future<void> clearAllPreferences() async {
    var preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () => clearAllPreferences(), child: const Text("Reset")),
        ElevatedButton(
            onPressed: () => clearAllPreferences(), child: const Text("Reset")),
        ElevatedButton(
            onPressed: () => context.push(homePageRoute),
            child: const Text("Home")),
        ElevatedButton(
            onPressed: () => context.push(remotePageRoute),
            child: const Text("Remote")),
        const Placeholder(),
      ],
    );
  }
}
