import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app_keys.dart';
import 'config/supabase_config.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Praktik 10: Mendaftarkan background notification handler.
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // 3. Praktik 9: Mendengarkan token FCM.
  FirebaseMessaging.instance.onRegistered.listen((token) {
    debugPrint('FCM TOKEN BERHASIL DITERIMA: $token');
  });

  // 4. Mendaftarkan perangkat ke Firebase Cloud Messaging.
  await FirebaseMessaging.instance.register();

  // 5. Inisialisasi Supabase.
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    publishableKey: SupabaseConfig.supabaseAnonKey,
  );

  // 6. Inisialisasi data source dan repository.
  final CourseDataSource dataSource = CourseSupabaseService();
  final repository = CourseRepository(dataSource);

  // 7. Menjalankan aplikasi.
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosFinder',
      scaffoldMessengerKey: messengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session =
            Supabase.instance.client.auth.currentSession;

        if (session == null) {
          return const LoginPage();
        }

        return const HomePage();
      },
    );
  }
}