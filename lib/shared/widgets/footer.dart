import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[800]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Text(
                '>_',
                style: TextStyle(
                  color: Color(0xFF2DD4BF),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  fontFamily: 'JetBrainsMono',
                ),
              ),
              Text(
                'kiert',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  fontFamily: 'JetBrainsMono',
                ),
              ),
              SizedBox(width: 8),
              Text(
                '— comunidad para compartir y ayudarse',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Text(
            '© $year',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
