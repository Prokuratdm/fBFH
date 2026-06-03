import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/l10n/app_localizations.dart';
import 'package:fbfh/pages/login_page.dart';
import 'package:fbfh/pages/home_page.dart';
import 'package:fbfh/models/login_response.dart';

/// Обёртка MaterialApp с локализацией для тестирования страниц.
Widget wrapWithMaterial(Widget child) {
  return MaterialApp(
    home: child,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('ru'),
  );
}

void main() {
  group('LoginPage', () {
    testWidgets('отображает форму логина', (tester) async {
      await tester.pumpWidget(wrapWithMaterial(const LoginPage()));
      await tester.pumpAndSettle();

      expect(find.text('Вход в систему'), findsOneWidget);
      expect(find.text('Войти'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('показывает ошибку при пустых полях', (tester) async {
      await tester.pumpWidget(wrapWithMaterial(const LoginPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Войти'));
      await tester.pumpAndSettle();

      expect(find.text('Обязательное поле'), findsNWidgets(2));
    });
  });

  group('HomePage', () {
    final testUser = LoginResponse(
      token: 'test-token',
      userId: 'test-uuid',
      username: 'admin',
      roles: ['ROLE_COACH'],
    );

    testWidgets('отображает приветствие и меню для COACH', (tester) async {
      await tester.pumpWidget(wrapWithMaterial(HomePage(user: testUser)));
      await tester.pumpAndSettle();

      // Приветствие в AppBar (1) + в центре экрана (1) = 2
      expect(find.text('Привет, admin!'), findsNWidgets(2));
      expect(find.text('Мои команды'), findsOneWidget);
      expect(find.text('Дети'), findsOneWidget);
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.text('Выйти'), findsOneWidget);
    });
  });
}