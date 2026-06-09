import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../l10n/app_localizations.dart';
import '../models/club_response.dart';
import '../services/auth_service.dart';
import '../services/auth_service_config.dart';
import '../services/club_service.dart';

/// Виджет управления клубами — встраивается в HomePage.
class ClubsPage extends StatefulWidget {
  final AuthService? authService;

  const ClubsPage({super.key, this.authService});

  @override
  State<ClubsPage> createState() => ClubsPageState();
}

class ClubsPageState extends State<ClubsPage> {
  late final ClubService _clubService;

  List<ClubResponse> _clubs = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final auth = widget.authService ?? authService;
    _clubService = ClubService(auth);
    _loadClubs();
  }

  /// Вызывается из HomePage при переключении на вкладку клубов.
  void refresh() {
    _clubs.clear();
    _currentPage = 0;
    _hasMore = true;
    _error = null;
    _loadClubs();
  }

  Future<void> _loadClubs() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final page = await _clubService.getClubs(page: _currentPage);
      if (!mounted) return;
      setState(() {
        _clubs.addAll(page.content);
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
    final addressCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();
    PlatformFile? logoFile;
    Uint8List? logoBytes;
    String? logoError;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(l10n.clubCreateDialogTitle),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.clubNameLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: addressCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.clubAddressLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: l10n.clubDescriptionLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Превью лого
                    if (logoBytes != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            logoBytes!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            logoFile != null
                                ? logoFile!.name
                                : l10n.clubNoLogo,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () async {
                            final picked = await FilePicker.pickFiles(
                              type: FileType.image,
                              withData: true,
                              allowMultiple: false,
                            );
                            if (picked == null || picked.files.isEmpty) return;

                            final file = picked.files.first;

                            if (file.bytes != null &&
                                file.bytes!.length > 200 * 1024) {
                              setDialogState(() {
                                logoFile = null;
                                logoBytes = null;
                                logoError = l10n.clubLogoErrorSize;
                              });
                              return;
                            }

                            if (file.bytes != null) {
                              final decoded = img.decodeImage(file.bytes!);
                              if (decoded != null &&
                                  (decoded.width > 200 ||
                                      decoded.height > 200)) {
                                setDialogState(() {
                                  logoFile = null;
                                  logoBytes = null;
                                  logoError = l10n.clubLogoErrorDimensions;
                                });
                                return;
                              }
                            }

                            setDialogState(() {
                              logoFile = file;
                              logoBytes = file.bytes;
                              logoError = null;
                            });
                          },
                          icon: const Icon(Icons.upload_file),
                          label: Text(l10n.clubLogoSelectFile),
                        ),
                      ],
                    ),
                    if (logoError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          logoError!,
                          style: TextStyle(
                            color: Theme.of(ctx).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
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
                  if (name.isEmpty) return;

                  try {
                    // Создаём клуб
                    final club = await _clubService.createClub(
                      name: name,
                      address: addressCtrl.text.trim(),
                      description: descriptionCtrl.text.trim(),
                    );

                    // Загружаем лого, если выбран
                    if (logoFile != null && logoFile!.bytes != null) {
                      try {
                        await _clubService.uploadLogo(
                          club.id,
                          logoFile!.bytes!,
                          logoFile!.name,
                        );
                      } catch (_) {
                        // Лого не загрузилось, но клуб создан
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content:
                                  Text(l10n.clubLogoUploadError),
                            ),
                          );
                        }
                      }
                    }

                    if (ctx.mounted) Navigator.pop(ctx, true);
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
              label: Text(l10n.clubsCreateButton),
            ),
          ),
        ),
        const Divider(),
        Expanded(child: _buildBody(l10n)),
      ],
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_error != null && _clubs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _error = null;
                _loadClubs();
              },
              child: Text(l10n.clubRetry),
            ),
          ],
        ),
      );
    }

    if (_clubs.isEmpty && !_isLoading) {
      return const Center(
        child: Text('Список клубов пуст', style: TextStyle(fontSize: 16)),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 50) {
          _loadClubs();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _clubs.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _clubs.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final club = _clubs[index];
          return _ClubCard(
            club: club,
            logoUrl: _clubService.getLogoUrl(club.id),
            token: _clubService.token,
          );
        },
      ),
    );
  }
}

class _ClubCard extends StatelessWidget {
  final ClubResponse club;
  final String logoUrl;
  final String? token;

  const _ClubCard({
    required this.club,
    required this.logoUrl,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: club.logoUrl != null
              ? Image.network(
                  logoUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  headers: token != null
                      ? {'Authorization': 'Bearer $token'}
                      : null,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.business, size: 48),
                )
              : const Icon(Icons.business, size: 48),
        ),
        title: Text(club.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (club.address.isNotEmpty) Text(club.address),
            if (club.description.isNotEmpty) Text(club.description),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}