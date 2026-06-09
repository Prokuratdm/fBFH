import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/inventory_response.dart';
import '../services/auth_service.dart';
import '../services/auth_service_config.dart';
import '../services/inventory_service.dart';

/// Виджет управления инвентарём — встраивается в HomePage.
///
/// [defaultClubId] — clubId текущего пользователя (из UserInfo).
/// Используется как `clubId` при создании. Если `null` — `clubId` в API не отправляется
/// (например, для клубных методистов, у которых нет привязки).
class InventoryPage extends StatefulWidget {
  final String? defaultClubId;
  final AuthService? authService;

  const InventoryPage({super.key, this.defaultClubId, this.authService});

  @override
  State<InventoryPage> createState() => InventoryPageState();
}

class InventoryPageState extends State<InventoryPage> {
  late final InventoryService _inventoryService;

  List<InventoryResponse> _items = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  static const int _pageSize = 100;

  @override
  void initState() {
    super.initState();
    final auth = widget.authService ?? authService;
    _inventoryService = InventoryService(auth);
    _loadInventory();
  }

  /// Вызывается из HomePage при переключении на вкладку инвентаря.
  void refresh() {
    _items = [];
    _currentPage = 0;
    _hasMore = true;
    _error = null;
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final page = await _inventoryService.getInventory(
        page: _currentPage,
        size: _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(page.content);
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

  Future<void> _showCreateDialog() async {
    final l10n = AppLocalizations.of(context);
    final nameCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.inventoryCreateDialogTitle),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: nameCtrl,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.inventoryNameLabel,
              border: const OutlineInputBorder(),
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
              if (name.isEmpty) return;
              try {
                await _inventoryService.createInventory(
                  name: name,
                  clubId: widget.defaultClubId,
                );
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(l10n.inventoryCreated)),
                  );
                  Navigator.pop(ctx, true);
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
            child: Text(l10n.inventoryCreate),
          ),
        ],
      ),
    );

    if (result == true) {
      refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: _showCreateDialog,
              icon: const Icon(Icons.add),
              label: Text(l10n.inventoryCreateButton),
            ),
          ),
        ),
        const Divider(),
        Expanded(child: _buildBody(l10n)),
      ],
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _error = null;
                _loadInventory();
              },
              child: Text(l10n.clubRetry),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Text(
          l10n.inventoryEmpty,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    // Для клубных работников (есть defaultClubId) clubName не показываем —
    // они и так знают, к какому клубу относятся.
    final showClubName = widget.defaultClubId == null;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 50) {
          _loadInventory();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _items.length + (_isLoading && _hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final item = _items[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.inventory),
              title: Text(item.name),
              subtitle: (showClubName && item.clubName != null)
                  ? Text(item.clubName!)
                  : null,
            ),
          );
        },
      ),
    );
  }
}
