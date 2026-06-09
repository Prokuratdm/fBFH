import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/location_response.dart';
import '../services/auth_service.dart';
import '../services/auth_service_config.dart';
import '../services/location_service.dart';

/// Виджет управления локациями клуба — встраивается в HomePage.
///
/// [clubId] — идентификатор клуба текущего пользователя.
/// Если `null`, локации недоступны (показывается заглушка).
class LocationsPage extends StatefulWidget {
  final String? clubId;
  final AuthService? authService;

  const LocationsPage({super.key, required this.clubId, this.authService});

  @override
  State<LocationsPage> createState() => LocationsPageState();
}

class LocationsPageState extends State<LocationsPage> {
  late final LocationService _locationService;

  List<LocationResponse> _locations = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final auth = widget.authService ?? authService;
    _locationService = LocationService(auth);
    if (widget.clubId != null) {
      _loadLocations();
    }
  }

  /// Вызывается из HomePage при переключении на вкладку локаций.
  void refresh() {
    if (widget.clubId != null) {
      _locations = [];
      _error = null;
      _loadLocations();
    }
  }

  Future<void> _loadLocations() async {
    final clubId = widget.clubId;
    if (clubId == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final list = await _locationService.getLocations(clubId);
      if (!mounted) return;
      setState(() {
        _locations = list;
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
        title: Text(l10n.locationCreateDialogTitle),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: nameCtrl,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.locationNameLabel,
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
                await _locationService.createLocation(
                  clubId: widget.clubId!,
                  name: name,
                );
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(l10n.locationCreated)),
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
            child: Text(l10n.locationCreate),
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

    if (widget.clubId == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.locationsNoClub,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: _showCreateDialog,
              icon: const Icon(Icons.add),
              label: Text(l10n.locationsCreateButton),
            ),
          ),
        ),
        const Divider(),
        Expanded(child: _buildBody(l10n)),
      ],
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading && _locations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _locations.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _error = null;
                _loadLocations();
              },
              child: Text(l10n.clubRetry),
            ),
          ],
        ),
      );
    }

    if (_locations.isEmpty) {
      return Center(
        child: Text(
          l10n.locationsEmpty,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: _locations.length,
      itemBuilder: (context, index) {
        final location = _locations[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(location.name),
          ),
        );
      },
    );
  }
}
