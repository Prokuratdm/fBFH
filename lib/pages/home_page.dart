import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/menu_items.dart';
import '../models/user_info.dart';
import '../services/auth_service_config.dart';
import 'clubs_page.dart';
import 'exercises_page.dart';
import 'inventory_page.dart';
import 'locations_page.dart';
import 'users_page.dart';

/// Главный экран с боковым меню, всегда видимым.
class HomePage extends StatefulWidget {
  final UserInfo user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = authService;
  bool _expanded = true;
  int _selectedIndex = 0;
  final _clubsKey = GlobalKey<ClubsPageState>();
  final _usersKey = GlobalKey<UsersPageState>();
  final _locationsKey = GlobalKey<LocationsPageState>();
  final _inventoryKey = GlobalKey<InventoryPageState>();
  final _exercisesKey = GlobalKey<ExercisesPageState>();

  void _logout() {
    _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final menuItems = MenuItems.forRoles(widget.user.roles, l10n);

    return PopScope(
      canPop: false,
      child: Scaffold(
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _expanded ? 200 : 72,
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                labelType: _expanded
                    ? NavigationRailLabelType.all
                    : NavigationRailLabelType.none,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: IconButton(
                    icon: Icon(_expanded ? Icons.chevron_left : Icons.menu),
                    onPressed: () => setState(() => _expanded = !_expanded),
                    tooltip: _expanded ? 'Свернуть меню' : 'Развернуть меню',
                  ),
                ),
                destinations: menuItems
                    .map(
                      (item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        label: Text(item.label),
                      ),
                    )
                    .toList(),
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                  _clubsKey.currentState?.refresh();
                  _usersKey.currentState?.refresh();
                  _locationsKey.currentState?.refresh();
                  _inventoryKey.currentState?.refresh();
                  _exercisesKey.currentState?.refresh();
                },
              ),
            ),
            const VerticalDivider(width: 1),
            // Контентная область
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: menuItems.map((item) {
                  if (item.label == l10n.menuClubs ||
                      item.label == l10n.menuMyClub) {
                    return ClubsPage(key: _clubsKey);
                  }
                  if (item.label == l10n.menuUsers) {
                    return UsersPage(key: _usersKey);
                  }
                  if (item.label == l10n.menuLocations) {
                    return LocationsPage(
                      key: _locationsKey,
                      clubId: widget.user.clubId,
                    );
                  }
                  if (item.label == l10n.menuInventory) {
                    return InventoryPage(
                      key: _inventoryKey,
                      defaultClubId: widget.user.clubId,
                    );
                  }
                  if (item.label == l10n.menuExercises) {
                    return ExercisesPage(
                      key: _exercisesKey,
                      defaultClubId: widget.user.clubId,
                    );
                  }
                  return _buildPlaceholder(item.label, l10n);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String label, AppLocalizations l10n) {
    return Center(
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
            '$label — ${l10n.inDevelopment}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ],
      ),
    );
  }
}