import 'package:flutter/material.dart';

import '../core/config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/club_response.dart';
import '../models/user_response.dart';
import '../services/auth_service.dart';
import '../services/auth_service_config.dart';
import '../services/club_service.dart';
import '../services/user_service.dart';

/// Возвращает локализованное название роли.
String roleDisplayName(String role, AppLocalizations l10n) {
  switch (role) {
    case 'ROLE_ADMIN':
      return l10n.roleAdmin;
    case 'ROLE_METHODIST':
      return l10n.roleMethodist;
    case 'ROLE_COACH':
      return l10n.roleCoach;
    case 'ROLE_MAIN_COACH':
      return l10n.roleMainCoach;
    case 'ROLE_CLUB':
      return l10n.roleClub;
    case 'ROLE_CLUB_METHODIST':
      return l10n.roleClubMethodist;
    default:
      return role;
  }
}

/// Виджет управления пользователями — встраивается в HomePage.
class UsersPage extends StatefulWidget {
  final AuthService? authService;

  const UsersPage({super.key, this.authService});

  @override
  State<UsersPage> createState() => UsersPageState();
}

class UsersPageState extends State<UsersPage> {
  late final UserService _userService;
  late final ClubService _clubService;

  List<UserResponse> _users = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  // Фильтры
  String? _filterRole;
  String? _filterClubId;
  final _usernameCtrl = TextEditingController();

  // Список клубов для дропбоксов
  List<ClubResponse> _allClubs = [];

  @override
  void initState() {
    super.initState();
    final auth = widget.authService ?? authService;
    _userService = UserService(auth);
    _clubService = ClubService(auth);
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadClubs();
    await _loadUsers();
  }

  Future<void> _loadClubs() async {
    try {
      final page = await _clubService.getClubs(page: 0, size: 100);
      if (!mounted) return;
      setState(() => _allClubs = page.content);
    } catch (_) {}
  }

  Future<void> _loadUsers() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final page = await _userService.getUsers(
        page: _currentPage,
        role: _filterRole,
        clubId: _filterClubId,
        username: _usernameCtrl.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _users.addAll(page.content);
        _hasMore = !page.last;
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void refresh() {
    _users.clear();
    _currentPage = 0;
    _hasMore = true;
    _error = null;
    _loadUsers();
  }

  void _applyFilters() {
    _users.clear();
    _currentPage = 0;
    _hasMore = true;
    _error = null;
    _loadUsers();
  }

  Future<void> _showCreateDialog() async {
    final l10n = AppLocalizations.of(context);
    final nameCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String? selectedRole;
    String? selectedClubId;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(l10n.usersCreateButton),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.userUsernameLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.userPasswordLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.userEmailLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(
                        labelText: l10n.userRolesLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: AppConfig.adminCreatableRoles
                          .map((r) => DropdownMenuItem(
                                value: r,
                                child: Text(roleDisplayName(r, l10n)),
                              ))
                          .toList(),
                      onChanged: (v) => setDialogState(() {
                        selectedRole = v;
                        if (v != 'ROLE_CLUB') selectedClubId = null;
                      }),
                    ),
                    if (selectedRole == 'ROLE_CLUB') ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedClubId,
                        decoration: InputDecoration(
                          labelText: l10n.userClubLabel,
                          border: const OutlineInputBorder(),
                        ),
                        items: _allClubs
                            .map((c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setDialogState(() => selectedClubId = v),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  final pass = passCtrl.text;
                  final email = emailCtrl.text.trim();
                  if (name.isEmpty || pass.isEmpty || email.isEmpty) return;

                  try {
                    await _userService.createUser(
                      username: name,
                      password: pass,
                      email: email,
                      roles: selectedRole != null ? [selectedRole!] : [],
                      clubId: selectedClubId,
                    );
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(content: Text(l10n.userCreated)),
                      );
                      Navigator.pop(ctx, true);
                    }
                  } catch (e) {
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor:
                              Theme.of(ctx).colorScheme.error,
                        ),
                      );
                    }
                  }
                },
                child: Text(l10n.clubCreate),
              ),
            ],
          );
        },
      ),
    );

    if (result == true) refresh();
  }

  Future<void> _showDetailDialog(UserResponse user) async {
    final l10n = AppLocalizations.of(context);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.userDetailTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(l10n.userUsernameLabel, user.username),
            _detailRow(l10n.userEmailLabel, user.email),
            _detailRow(
              l10n.userRolesLabel,
              user.roles.map((r) => roleDisplayName(r, l10n)).join(', '),
            ),
            if (user.clubName != null)
              _detailRow(l10n.userClubLabel, user.clubName!),
            _detailRow('Enabled', user.enabled.toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showChangePasswordDialog(user.id);
            },
            child: Text(l10n.userChangePassword),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Future<void> _showChangePasswordDialog(String userId) async {
    final l10n = AppLocalizations.of(context);
    final passCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.userChangePassword),
        content: TextField(
          controller: passCtrl,
          obscureText: true,
          decoration: InputDecoration(
            labelText: l10n.newPasswordLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          ElevatedButton(
            onPressed: () async {
              final pass = passCtrl.text;
              if (pass.isEmpty) return;
              try {
                await _userService.changePassword(userId, pass);
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(l10n.passwordChanged)),
                  );
                  Navigator.pop(ctx);
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Theme.of(ctx).colorScheme.error,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.userChangePassword),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        // Кнопка создания + фильтры сверху
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Wrap(
            spacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _showCreateDialog,
                icon: const Icon(Icons.add),
                label: Text(l10n.usersCreateButton),
              ),
              SizedBox(
                width: 140,
                child: DropdownButtonFormField<String?>(
                  value: _filterRole,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.filterRole,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.allRoles)),
                    ...AppConfig.allRoles.map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(roleDisplayName(r, l10n)),
                        )),
                  ],
                  onChanged: (v) {
                    setState(() => _filterRole = v);
                    _applyFilters();
                  },
                ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String?>(
                  value: _filterClubId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.filterClub,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.allClubs)),
                    ..._allClubs.map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name),
                        )),
                  ],
                  onChanged: (v) {
                    setState(() => _filterClubId = v);
                    _applyFilters();
                  },
                ),
              ),
              SizedBox(
                width: 140,
                child: TextField(
                  controller: _usernameCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.filterUsername,
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                  onSubmitted: (_) => _applyFilters(),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(child: _buildBody(l10n)),
      ],
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_error != null && _users.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: refresh, child: Text(l10n.clubRetry)),
          ],
        ),
      );
    }

    if (_users.isEmpty && !_isLoading) {
      return const Center(
        child: Text('Список пользователей пуст',
            style: TextStyle(fontSize: 16)),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 50) {
          _loadUsers();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _users.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _users.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final user = _users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(user.username[0].toUpperCase()),
              ),
              title: Text(user.username),
              subtitle: Text(
                user.roles.map((r) => roleDisplayName(r, l10n)).join(', '),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showDetailDialog(user),
            ),
          );
        },
      ),
    );
  }
}