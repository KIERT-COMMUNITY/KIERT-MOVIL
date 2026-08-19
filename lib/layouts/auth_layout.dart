import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF131A22),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF26313C)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '>_',
                      style: TextStyle(
                        color: Color(0xFF2DD4BF),
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                    const Text(
                      'kiert',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '\$ comunidad para compartir casos y ayudarse entre todos',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
