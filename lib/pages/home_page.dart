import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/menu_items.dart';
import '../models/login_response.dart';
import '../services/auth_service.dart';
import '../services/auth_service_config.dart';

/// Домашний экран после входа.
class HomePage extends StatefulWidget {
  final LoginResponse user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = authService;

  void _logout() {
    _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final menuItems = MenuItems.forRoles(widget.user.roles, l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                l10n.welcome(widget.user.username),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: Text(l10n.logoutButton),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Боковое меню
          Expanded(
            flex: 1,
            child: NavigationRail(
              selectedIndex: null,
              labelType: NavigationRailLabelType.all,
              destinations: menuItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
              onDestinationSelected: (index) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${menuItems[index].label}: ${l10n.inDevelopment}'),
                  ),
                );
              },
            ),
          ),
          const VerticalDivider(width: 1),
          // Основная область
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.welcome(widget.user.username),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.user.roles.join(', '),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}