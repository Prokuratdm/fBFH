import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../core/config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/exercise_response.dart';
import '../services/auth_service.dart';
import '../services/auth_service_config.dart';
import '../services/club_service.dart';
import '../services/exercise_service.dart';
import '../services/inventory_service.dart';

/// Виджет управления упражнениями — встраивается в HomePage.
///
/// [defaultClubId] — clubId текущего пользователя (из UserInfo).
/// Если `null` (админ/методист), при создании показывается дропдаун выбора клуба.
class ExercisesPage extends StatefulWidget {
  final String? defaultClubId;
  final AuthService? authService;

  const ExercisesPage({super.key, this.defaultClubId, this.authService});

  @override
  State<ExercisesPage> createState() => ExercisesPageState();
}

class ExercisesPageState extends State<ExercisesPage> {
  late final ExerciseService _exerciseService;
  late final ClubService _clubService;
  late final InventoryService _inventoryService;

  List<ExerciseResponse> _items = [];
  int _currentPage = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  String? _typeFilter; // null = все типы
  static const int _pageSize = 100;

  ExerciseResponse? _selectedExercise;
  final Map<String, String> _inventoryNames = {}; // id → name

  @override
  void initState() {
    super.initState();
    final auth = widget.authService ?? authService;
    _exerciseService = ExerciseService(auth);
    _clubService = ClubService(auth);
    _inventoryService = InventoryService(auth);
    _loadExercises();
  }

  /// Вызывается из HomePage при переключении на вкладку упражнений.
  void refresh() {
    _items = [];
    _currentPage = 0;
    _hasMore = true;
    _error = null;
    _selectedExercise = null;
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final page = await _exerciseService.getAll(
        page: _currentPage,
        size: _pageSize,
        type: _typeFilter,
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
    final descriptionCtrl = TextEditingController();
    final urlCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String selectedType = 'ICE';
    String? selectedClubId = widget.defaultClubId;
    final selectedInventoryIds = <String>{};
    PlatformFile? pictureFile;
    Uint8List? pictureBytes;

    // Подгружаем справочники каждый раз заново
    List<String> types = [];
    List<Map<String, String>> clubs = [];
    List<Map<String, String>> inventory = [];

    bool isLoadingDicts = true;
    String? dictError;

    try {
      types = await _exerciseService.getTypes();
      if (types.isNotEmpty) {
        selectedType = types.first;
      }

      if (widget.defaultClubId == null) {
        final clubPage = await _clubService.getClubs(size: 100);
        clubs = clubPage.content
            .map((c) => {'id': c.id, 'name': c.name})
            .toList();
      }

      final invPage = await _inventoryService.getInventory(size: 100);
      inventory = invPage.content
          .map((i) => {
                'id': i.id,
                'name':
                    i.clubName != null ? '${i.name} (${i.clubName})' : i.name,
              })
          .toList();
    } catch (e) {
      dictError = e.toString();
    }
    isLoadingDicts = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          Widget content;

          if (isLoadingDicts) {
            content = const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (dictError != null) {
            content = SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  dictError!,
                  style: TextStyle(
                    color: Theme.of(ctx).colorScheme.error,
                  ),
                ),
              ),
            );
          } else {
            content = SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: l10n.exerciseNameLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: l10n.exerciseDescriptionLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: l10n.exerciseTypeLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: types.map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(t),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => selectedType = v);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: urlCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.exerciseUrlLabel,
                        hintText: 'https://youtube.com/...',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: l10n.exerciseContentLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.defaultClubId == null) ...[
                      DropdownButtonFormField<String>(
                        value: selectedClubId,
                        decoration: InputDecoration(
                          labelText: l10n.inventoryClubLabel,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('—'),
                          ),
                          // создание
                          ...clubs.map((c) {
                            return DropdownMenuItem<String>(
                              value: c['id'],
                              child: Text(c['name'] ?? ''),
                            );
                          }),
                        ],
                        onChanged: (v) {
                          setDialogState(() => selectedClubId = v);
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.exerciseInventoryLabel,
                        border: const OutlineInputBorder(),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: inventory.map((inv) {
                          final id = inv['id']!;
                          final selected = selectedInventoryIds.contains(id);
                          return FilterChip(
                            label: Text(inv['name']!),
                            selected: selected,
                            onSelected: (v) {
                              setDialogState(() {
                                if (v) {
                                  selectedInventoryIds.add(id);
                                } else {
                                  selectedInventoryIds.remove(id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pictureFile != null
                                ? pictureFile!.name
                                : l10n.exercisePictureEmpty,
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
                            setDialogState(() {
                              pictureFile = picked.files.first;
                              pictureBytes = picked.files.first.bytes;
                            });
                          },
                          icon: const Icon(Icons.upload_file),
                          label: Text(l10n.exerciseUploadPicture),
                        ),
                      ],
                    ),
                    if (pictureBytes != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            pictureBytes!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          return AlertDialog(
            title: Text(l10n.exerciseCreateDialogTitle),
            content: content,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
              ),
              ElevatedButton(
                onPressed: (dictError != null)
                    ? null
                    : () async {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) return;

                        try {
                          final request = ExerciseRequest(
                            name: name,
                            description: descriptionCtrl.text.trim(),
                            type: selectedType,
                            url: urlCtrl.text.trim().isEmpty
                                ? null
                                : urlCtrl.text.trim(),
                            content: contentCtrl.text.trim(),
                            inventoryIds: selectedInventoryIds.toList(),
                          );

                          final exercise = await _exerciseService.create(
                            request: request,
                            clubId: selectedClubId,
                          );

                          if (pictureFile != null &&
                              pictureFile!.bytes != null) {
                            try {
                              await _exerciseService.uploadPicture(
                                exercise.id,
                                pictureFile!.bytes!,
                                pictureFile!.name,
                              );
                            } catch (_) {}
                          }

                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text(l10n.exerciseCreated),
                              ),
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
                child: Text(l10n.exerciseCreate),
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

  Future<void> _showEditDialog() async {
    if (_selectedExercise == null) return;

    final l10n = AppLocalizations.of(context);
    final exercise = _selectedExercise!;
    final nameCtrl = TextEditingController(text: exercise.name);
    final descriptionCtrl = TextEditingController(text: exercise.description);
    final urlCtrl = TextEditingController(text: exercise.url ?? '');
    final contentCtrl = TextEditingController(text: exercise.content);
    String selectedType = exercise.type;
    final selectedInventoryIds = exercise.inventoryIds.toSet();
    PlatformFile? pictureFile;
    Uint8List? pictureBytes;

    List<String> types = [];
    List<Map<String, String>> inventory = [];
    bool isLoadingDicts = true;
    String? dictError;

    try {
      types = await _exerciseService.getTypes();
      final invPage = await _inventoryService.getInventory(size: 100);
      inventory = invPage.content
          .map((i) => {
                'id': i.id,
                'name':
                    i.clubName != null ? '${i.name} (${i.clubName})' : i.name,
              })
          .toList();
    } catch (e) {
      dictError = e.toString();
    }
    isLoadingDicts = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          Widget content;

          if (isLoadingDicts) {
            content = const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (dictError != null) {
            content = SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  dictError!,
                  style: TextStyle(
                    color: Theme.of(ctx).colorScheme.error,
                  ),
                ),
              ),
            );
          } else {
            content = SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: l10n.exerciseNameLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: l10n.exerciseDescriptionLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: l10n.exerciseTypeLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: types.map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(t),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => selectedType = v);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: urlCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.exerciseUrlLabel,
                        hintText: 'https://youtube.com/...',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: l10n.exerciseContentLabel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.exerciseInventoryLabel,
                        border: const OutlineInputBorder(),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: inventory.map((inv) {
                          final id = inv['id']!;
                          final selected = selectedInventoryIds.contains(id);
                          return FilterChip(
                            label: Text(inv['name']!),
                            selected: selected,
                            onSelected: (v) {
                              setDialogState(() {
                                if (v) {
                                  selectedInventoryIds.add(id);
                                } else {
                                  selectedInventoryIds.remove(id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pictureFile != null
                                ? pictureFile!.name
                                : l10n.exerciseReplacePicture,
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
                            setDialogState(() {
                              pictureFile = picked.files.first;
                              pictureBytes = picked.files.first.bytes;
                            });
                          },
                          icon: const Icon(Icons.upload_file),
                          label: Text(l10n.exerciseReplacePicture),
                        ),
                      ],
                    ),
                    if (pictureBytes != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            pictureBytes!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          return AlertDialog(
            title: Text(l10n.exerciseEditDialogTitle),
            content: content,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
              ),
              ElevatedButton(
                onPressed: (dictError != null)
                    ? null
                    : () async {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) return;

                        try {
                          final request = ExerciseRequest(
                            name: name,
                            description: descriptionCtrl.text.trim(),
                            type: selectedType,
                            url: urlCtrl.text.trim().isEmpty
                                ? null
                                : urlCtrl.text.trim(),
                            content: contentCtrl.text.trim(),
                            inventoryIds: selectedInventoryIds.toList(),
                          );

                          final updated = await _exerciseService.update(
                            exercise.id,
                            request,
                          );

                          if (pictureFile != null &&
                              pictureFile!.bytes != null) {
                            try {
                              await _exerciseService.uploadPicture(
                                updated.id,
                                pictureFile!.bytes!,
                                pictureFile!.name,
                              );
                            } catch (_) {}
                          }

                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text(l10n.exerciseUpdated),
                              ),
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
                child: Text(l10n.exerciseSave),
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

  /// Подгружает Map id → name инвентаря (один раз заполняет кэш).
  Future<void> _loadInventoryMap() async {
    if (_inventoryNames.isNotEmpty) return; // уже загружен
    try {
      final page = await _inventoryService.getInventory(size: 100);
      for (final inv in page.content) {
        _inventoryNames[inv.id] = inv.name;
      }
    } catch (_) {
      // если не загрузилось — покажем ID как fallback
    }
  }

  Future<void> _selectExercise(ExerciseResponse exercise) async {
    try {
      // Загружаем детали упражнения и список инвентаря параллельно
      final results = await Future.wait([
        _exerciseService.getById(exercise.id),
        _loadInventoryMap(),
      ]);
      if (!mounted) return;
      final detail = results[0] as ExerciseResponse;
      setState(() {
        _selectedExercise = detail;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final token = _exerciseService.token;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: _showCreateDialog,
                icon: const Icon(Icons.add),
                label: Text(l10n.exercisesCreateButton),
              ),
              const SizedBox(width: 16),
              Text('${l10n.exerciseTypeLabel}:'),
              const SizedBox(width: 8),
              DropdownButton<String?>(
                value: _typeFilter,
                hint: Text(l10n.exerciseTypeAll),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.exerciseTypeAll),
                  ),
                  const DropdownMenuItem(value: 'ICE', child: Text('ICE')),
                  const DropdownMenuItem(value: 'LAND', child: Text('LAND')),
                ],
                onChanged: (v) {
                  setState(() {
                    _typeFilter = v;
                  });
                  _items = [];
                  _currentPage = 0;
                  _hasMore = true;
                  _error = null;
                  _selectedExercise = null;
                  _loadExercises();
                },
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildList(l10n),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 1,
                child: _buildDetail(l10n, token),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList(AppLocalizations l10n) {
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
                _loadExercises();
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
          l10n.exercisesEmpty,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 50) {
          _loadExercises();
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
          final exercise = _items[index];
          final isSelected = _selectedExercise != null &&
              _selectedExercise!.id == exercise.id;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            child: ListTile(
              leading: const Icon(Icons.fitness_center),
              title: Text(exercise.name),
              subtitle: Text(exercise.type),
              onTap: () => _selectExercise(exercise),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetail(AppLocalizations l10n, String? token) {
    final exercise = _selectedExercise;

    if (exercise == null) {
      return Center(
        child: Text(
          l10n.exerciseDetailSelect,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final pictureUrl = exercise.pictureUrl != null
        ? '${AppConfig.baseUrl}${AppConfig.exercisePicturePath(exercise.id)}'
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              IconButton(
                onPressed: _showEditDialog,
                icon: const Icon(Icons.edit),
                tooltip: l10n.exerciseEditButton,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Chip(label: Text(exercise.type)),
          const SizedBox(height: 12),
          if (pictureUrl != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  pictureUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  headers: token != null
                      ? {'Authorization': 'Bearer $token'}
                      : null,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, size: 64, color: Colors.grey),
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Icon(Icons.image, size: 64, color: Colors.grey),
            ),
          if (exercise.description.isNotEmpty) ...[
            Text(
              l10n.exerciseDescriptionLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(exercise.description),
            const SizedBox(height: 12),
          ],
          if (exercise.url != null && exercise.url!.isNotEmpty) ...[
            Text(
              l10n.exerciseUrlLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            SelectableText(
              exercise.url!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (exercise.content.isNotEmpty) ...[
            Text(
              l10n.exerciseContentLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(exercise.content),
            const SizedBox(height: 12),
          ],
          if (exercise.clubName != null && exercise.clubName!.isNotEmpty) ...[
            Text(
              l10n.inventoryClubLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(exercise.clubName!),
            const SizedBox(height: 12),
          ],
          if (exercise.inventoryIds.isNotEmpty) ...[
            Text(
              l10n.exerciseInventoryLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: exercise.inventoryIds
                  .map((id) => Chip(label: Text(_inventoryNames[id] ?? id)))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            '${l10n.exerciseCreated}: ${exercise.createdAt}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (exercise.updatedAt != null)
            Text(
              '${l10n.exerciseUpdated}: ${exercise.updatedAt}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}