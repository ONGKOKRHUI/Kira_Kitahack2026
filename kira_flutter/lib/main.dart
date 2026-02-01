/// Kira App Entry Point
/// 
/// Main entry point for the Kira Carbon Tracker Flutter application.
/// Sets up Firebase, Riverpod providers, theme, and routing.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'app/routes.dart';
import 'app/theme.dart';

/// Application entry point
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // ═══════════════════════════════════════════════
  // Initialize Firebase - KIRA26 PROJECT
  // ═══════════════════════════════════════════════
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'],
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
      measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'],
    ),
  );
  
  print('🔥 Firebase initialized successfully - kira26 project');
  
  // ═══════════════════════════════════════════════
  // Set system UI overlay style
  // ═══════════════════════════════════════════════
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Enable edge-to-edge mode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  
  // Run the app wrapped in ProviderScope for Riverpod
  runApp(
    const ProviderScope(
      child: KiraApp(),
    ),
  );
}

/// Root application widget
class KiraApp extends ConsumerWidget {
  const KiraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      // App configuration
      title: 'Kira',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: KiraTheme.darkTheme,
      themeMode: ThemeMode.dark,
      
      // Router configuration (Auth-aware GoRouter)
      routerConfig: router,
      
      // Builder for additional overlays
      builder: (context, child) {
        // Ensure text scaling doesn't break the UI
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

