import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.95),
        border: Border(bottom: BorderSide(color: Colors.grey[800]!, width: 1)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.go('/comunidad'),
            child: const Row(
              children: [
                Text(
                  '>_',
                  style: TextStyle(
                    color: Color(0xFF2DD4BF),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
                Text(
                  'kiert',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Wrap(
            spacing: 4,
            children: [
              TextButton(
                onPressed: () => context.go('/comunidad'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
                child: const Text('Comunidad'),
              ),
              TextButton(
                onPressed: () => context.go('/comunidad/nueva-publicacion'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
                child: const Text('Publicar'),
              ),
              TextButton(
                onPressed: () => context.go('/mis-publicaciones'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
                child: const Text('Mis posts'),
              ),
              TextButton(
                onPressed: () => context.go('/chat'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
                child: const Text('Chat'),
              ),
              TextButton(
                onPressed: () => context.go('/perfil'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
                child: const Text('Perfil'),
              ),
              TextButton(
                onPressed: () => context.go('/ajustes'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
                child: const Text('Ajustes'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
