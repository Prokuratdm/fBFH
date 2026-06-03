import 'package:flutter/material.dart';

import 'app_localizations.dart';

/// Элемент бокового меню.
class MenuItem {
  final String label;
  final IconData icon;

  const MenuItem({required this.label, required this.icon});
}

/// Внутренний шаблон пункта меню — label берётся из l10n,
/// roles — множество ролей, которым пункт доступен.
class _ItemTemplate {
  final String label;
  final IconData icon;
  final Set<String> roles;

  const _ItemTemplate(this.label, this.icon, this.roles);
}

/// Статическая логика формирования меню по ролям.
///
/// Каждый пункт объявлен ровно один раз с множеством ролей, которым он доступен.
/// При формировании меню пункты объединяются по всем ролям пользователя
/// и дедуплицируются по label.
class MenuItems {
  MenuItems._();

  /// Возвращает список пунктов меню для переданных ролей.
  static List<MenuItem> forRoles(List<String> roles, AppLocalizations l10n) {
    // Единый реестр: каждый пункт один раз со списком ролей
    final allTemplates = [
      _ItemTemplate(l10n.menuDashboard, Icons.dashboard, {
        'ROLE_ADMIN',
        'ROLE_METHODIST',
        'ROLE_CLUB_METHODIST',
      }),
      _ItemTemplate(l10n.menuClubs, Icons.business, {
        'ROLE_ADMIN',
        'ROLE_METHODIST',
      }),
      _ItemTemplate(l10n.menuMyClub, Icons.business, {
        'ROLE_CLUB',
      }),
      _ItemTemplate(l10n.menuUsers, Icons.people, {
        'ROLE_ADMIN',
        'ROLE_CLUB',
      }),
      _ItemTemplate(l10n.menuTeams, Icons.groups, {
        'ROLE_ADMIN',
        'ROLE_METHODIST',
        'ROLE_CLUB_METHODIST',
      }),
      _ItemTemplate(l10n.menuMyTeams, Icons.groups, {
        'ROLE_CLUB',
        'ROLE_COACH',
        'ROLE_MAIN_COACH',
      }),
      _ItemTemplate(l10n.menuChildren, Icons.child_care, {
        'ROLE_CLUB',
        'ROLE_CLUB_METHODIST',
        'ROLE_COACH',
        'ROLE_MAIN_COACH',
      }),
      _ItemTemplate(l10n.menuTrainings, Icons.calendar_month, {
        'ROLE_CLUB',
        'ROLE_CLUB_METHODIST',
        'ROLE_COACH',
        'ROLE_MAIN_COACH',
      }),
      _ItemTemplate(l10n.menuLocations, Icons.location_on, {
        'ROLE_CLUB',
        'ROLE_COACH',
        'ROLE_MAIN_COACH',
      }),
      _ItemTemplate(l10n.menuInventory, Icons.inventory, {
        'ROLE_ADMIN',
        'ROLE_CLUB',
        'ROLE_CLUB_METHODIST',
        'ROLE_COACH',
        'ROLE_MAIN_COACH',
      }),
      _ItemTemplate(l10n.menuExercises, Icons.fitness_center, {
        'ROLE_ADMIN',
        'ROLE_METHODIST',
        'ROLE_CLUB',
        'ROLE_CLUB_METHODIST',
        'ROLE_COACH',
        'ROLE_MAIN_COACH',
      }),
      _ItemTemplate(l10n.menuStandards, Icons.assessment, {
        'ROLE_ADMIN',
        'ROLE_METHODIST',
        'ROLE_CLUB_METHODIST',
        'ROLE_COACH',
        'ROLE_MAIN_COACH',
      }),
      _ItemTemplate(l10n.menuTemplates, Icons.description, {
        'ROLE_ADMIN',
        'ROLE_METHODIST',
      }),
      _ItemTemplate(l10n.menuPrograms, Icons.school, {
        'ROLE_ADMIN',
        'ROLE_METHODIST',
      }),
    ];

    final seen = <String>{};
    final items = <MenuItem>[];

    for (final template in allTemplates) {
      // Пункт добавляется, если хотя бы одна роль пользователя есть в template.roles
      if (template.roles.any(roles.contains)) {
        // Дедупликация по label (на случай, если роль указана дважды или роли пересекаются)
        if (seen.add(template.label)) {
          items.add(MenuItem(label: template.label, icon: template.icon));
        }
      }
    }

    return items;
  }
}