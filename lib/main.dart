import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramas_git/config/router.dart'; 

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp())); 
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Ramas Git',
      routerConfig: router, 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
