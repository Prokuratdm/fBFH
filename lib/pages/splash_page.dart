import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/user_info.dart';
import '../services/auth_service.dart';
import '../services/auth_service_config.dart';

/// Экран загрузки при старте.
///
/// Если есть кука с токеном — вызывает [AuthService.me()].
/// В случае успеха переходит на [HomePage], при ошибке — на [LoginPage].
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authService = authService;

  @override
  void initState() {
    super.initState();
    // Ждём первый frame, чтобы избежать race condition при pushReplacement
    // при обновлении страницы (F5) — иначе Flutter выбрасывает Assertion
    // на _retakeInactiveElement.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuth());
  }

  Future<void> _checkAuth() async {
    // Если токена нет — сразу на логин
    if (!_authService.isLoggedIn()) {
      _goToLogin();
      return;
    }

    try {
      final userInfo = await _authService.me();
      if (!mounted) return;
      _goToHome(userInfo);
    } on AuthException {
      // Токен невалиден, куки уже очищены в me()
      if (!mounted) return;
      _goToLogin();
    } catch (_) {
      // Сетевая ошибка — всё равно показываем логин
      if (!mounted) return;
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _goToHome(UserInfo userInfo) {
    Navigator.pushReplacementNamed(context, '/home', arguments: userInfo);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.appTitle),
          ],
        ),
      ),
    );
  }
}