import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiert_movil/app/app_config.dart';
import 'package:kiert_movil/core/api/api_client.dart';
import 'package:kiert_movil/core/providers/auth_provider.dart';
import 'package:kiert_movil/core/providers/personalizacion_provider.dart';

void main() {
  // Inicializar ApiClient
  ApiClient().init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authStateProvider);
      if (authState.user != null) {
        ref.read(personalizacionStateProvider.notifier).cargarTodos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kiert',
      debugShowCheckedModeBanner: false,
      theme: AppConfig.theme,
      routerConfig: AppConfig.router,
    );
  }
}
