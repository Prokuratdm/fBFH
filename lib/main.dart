import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'models/login_response.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/auth_service_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fBFH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'), // русский по умолчанию
      // Определяем начальный маршрут на основе куки
      initialRoute: authService.isLoggedIn() ? '/home' : '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/home':
            final user = settings.arguments as LoginResponse;
            return MaterialPageRoute(
              builder: (_) => HomePage(user: user),
            );
          default:
            return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      },
    );
  }
}