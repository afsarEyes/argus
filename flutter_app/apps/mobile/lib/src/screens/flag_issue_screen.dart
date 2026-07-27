import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import 'package:go_router/go_router.dart';
import '../providers/local_providers.dart';
import '../routing/app_router.dart';

class FlagIssueScreen extends ConsumerStatefulWidget {
  const FlagIssueScreen({super.key});

  @override
  ConsumerState<FlagIssueScreen> createState() => _FlagIssueScreenState();
}

class _FlagIssueScreenState extends ConsumerState<FlagIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  Line? _selectedLine;
  Station? _selectedStation;
  DefectCategory? _selectedCategory;
  TicketSeverity _selectedSeverity = TicketSeverity.minor;
  final List<String> _capturedPhotoPaths = [];
  bool _isOffline = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (mounted) {
        setState(() {
          _isOffline = !hasConnection;
        });
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    final hasConnection = result.any((r) => r != ConnectivityResult.none);
    setState(() {
      _isOffline = !hasConnection;
    });
  }

  Future<void> _capturePhoto(bool fromCamera) async {
    HapticFeedback.lightImpact();
    try {
      final picker = ref.read(attachmentServiceProvider);
      final paths = await picker.capturePhotos(fromCamera: fromCamera);
      if (paths.isNotEmpty) {
        if (mounted) {
          setState(() {
            _capturedPhotoPaths.addAll(paths);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${paths.length} photo(s) saved to local storage.'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to attach image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removePhoto(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _capturedPhotoPaths.removeAt(index);
    });
  }

  void _showCategorySelector(List<DefectCategory> categories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) {
        return _CategorySearchSheet(
          categories: categories,
          onSelected: (cat) {
            setState(() {
              _selectedCategory = cat;
            });
          },
        );
      },
    );
  }

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate() ||
        _selectedLine == null ||
        _selectedStation == null ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();
    setState(() {
      _isSubmitting = true;
    });

    final userStream = ref.read(appUserStreamProvider);
    final activeUser = userStream.valueOrNull;

    if (activeUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User profile not authenticated.')),
      );
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    final ticket = Ticket(
      id: '',
      reporterId: activeUser.id,
      lineId: _selectedLine!.id,
      stationId: _selectedStation!.id,
      defectCategoryId: _selectedCategory!.id,
      severity: _selectedSeverity,
      photos: _capturedPhotoPaths,
      description: _descriptionController.text.trim(),
      status: TicketStatus.open,
      createdAt: DateTime.now().toUtc(),
    );

    try {
      debugPrint('================ FLAG ISSUE SUBMIT REQUEST ================');
      debugPrint('Ticket: $ticket');

      final ticketRepo = ref.read(ticketRepositoryProvider);
      final createdTicket = await ticketRepo.createTicket(ticket);

      debugPrint('================ FLAG ISSUE SUBMIT SUCCESS ================');
      debugPrint('Created Ticket ID: ${createdTicket.id}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isOffline
                ? 'Ticket saved offline. It will sync automatically when online.'
                : 'Ticket submitted successfully.'),
            backgroundColor: _isOffline ? Colors.orange : Colors.green,
          ),
        );

        // Reset form
        setState(() {
          _selectedLine = null;
          _selectedStation = null;
          _selectedCategory = null;
          _selectedSeverity = TicketSeverity.minor;
          _capturedPhotoPaths.clear();
          _descriptionController.clear();
        });
        if (mounted) {
          context.go('/queue');
        }
      }
    } catch (e, stack) {
      debugPrint('================ FLAG ISSUE SUBMIT EXCEPTION ================');
      debugPrint('Exception: $e');
      debugPrint('Stacktrace: $stack');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting ticket: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;

    final linesAsync = ref.watch(linesListProvider);
    final stationsAsync = ref.watch(stationsListProvider);
    final categoriesAsync = ref.watch(defectCategoriesListProvider);

    final lines = linesAsync.valueOrNull ?? [];
    final allStations = stationsAsync.valueOrNull ?? [];
    final categories = categoriesAsync.valueOrNull ?? [];

    final filteredStations = _selectedLine == null
        ? <Station>[]
        : allStations.where((s) => s.lineId == _selectedLine!.id).toList();

    // Safety checks to ensure selected references are updated to match the instances in the new list
    final selLine = _selectedLine;
    Line? selectedLine;
    if (selLine != null && lines.isNotEmpty) {
      final match = lines.firstWhere((l) => l.id == selLine.id, orElse: () => selLine);
      if (lines.contains(match)) {
        selectedLine = match;
      }
    }

    final selStation = _selectedStation;
    Station? selectedStation;
    if (selStation != null && filteredStations.isNotEmpty) {
      final match = filteredStations.firstWhere((s) => s.id == selStation.id, orElse: () => selStation);
      if (filteredStations.contains(match)) {
        selectedStation = match;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FLAG AN ISSUE',
          style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Offline Banner Warning
          if (_isOffline)
            Container(
              color: colors.brandAccent,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.wifi_off, color: Colors.black),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Offline Mode: Issue will be queued and synced automatically once connection is restored.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Line & Station Picker Layout
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<Line>(
                            value: selectedLine,
                            isExpanded: true,
                            hint: Text('Select Line', style: TextStyle(color: colors.textSecondary)),
                            dropdownColor: colors.panelBackground,
                            decoration: InputDecoration(
                              labelText: 'Line',
                              labelStyle: TextStyle(color: colors.textSecondary),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.panelBorder)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.brandAccent)),
                            ),
                            items: lines.map((l) {
                              return DropdownMenuItem(
                                value: l,
                                child: Text(
                                  l.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: colors.textPrimary),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedLine = val;
                                _selectedStation = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<Station>(
                            value: selectedStation,
                            isExpanded: true,
                            hint: Text('Select Station', style: TextStyle(color: colors.textSecondary)),
                            dropdownColor: colors.panelBackground,
                            decoration: InputDecoration(
                              labelText: 'Station',
                              labelStyle: TextStyle(color: colors.textSecondary),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.panelBorder)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.brandAccent)),
                            ),
                            items: filteredStations.map((s) {
                              return DropdownMenuItem(
                                value: s,
                                child: Text(
                                  s.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: colors.textPrimary),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedStation = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Searchable Defect Category Button
                    InkWell(
                      onTap: () => _showCategorySelector(categories),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Defect Category',
                          labelStyle: TextStyle(color: colors.textSecondary),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.panelBorder)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.brandAccent)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedCategory?.name ?? 'Search defect taxonomy...',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _selectedCategory == null ? colors.textSecondary : colors.textPrimary,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.search, color: colors.brandAccent),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Severity Selector Tabs
                    Text(
                      'SEVERITY',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: TicketSeverity.values.map((sev) {
                        final isSelected = _selectedSeverity == sev;
                        Color sevColor = colors.severityMinor;
                        if (sev == TicketSeverity.critical) sevColor = colors.severityCritical;
                        if (sev == TicketSeverity.major) sevColor = colors.severityMajor;

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: OutlinedButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _selectedSeverity = sev;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isSelected ? sevColor.withOpacity(0.15) : Colors.transparent,
                                side: BorderSide(color: isSelected ? sevColor : colors.panelBorder, width: isSelected ? 2 : 1),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                sev.name.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? sevColor : colors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Capture Photo Grid section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ATTACHMENTS (${_capturedPhotoPaths.length})',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.camera_alt, color: colors.brandAccent),
                              onPressed: () => _capturePhoto(true),
                            ),
                            IconButton(
                              icon: Icon(Icons.photo_library, color: colors.brandAccent),
                              onPressed: () => _capturePhoto(false),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_capturedPhotoPaths.isNotEmpty)
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _capturedPhotoPaths.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    child: Image.file(
                                      File(_capturedPhotoPaths[index]),
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: InkWell(
                                      onTap: () => _removePhoto(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, size: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.panelBorder),
                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'No attachments. Capture or attach defect photos.',
                          style: TextStyle(color: colors.textSecondary, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Description text input
                    TextFormField(
                      controller: _descriptionController,
                      style: TextStyle(color: colors.textPrimary, fontFamily: 'Inter'),
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Defect Description',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: colors.textSecondary),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.panelBorder)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.brandAccent)),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Please describe the defect.' : null,
                    ),
                    const SizedBox(height: 24),

                    // Submission trigger action button
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.brandAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : const Text(
                              'SUBMIT TICKET',
                              style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Dialog/Sheet for searchable taxonomy lookup
class _CategorySearchSheet extends StatefulWidget {
  const _CategorySearchSheet({
    required this.categories,
    required this.onSelected,
  });

  final List<DefectCategory> categories;
  final ValueChanged<DefectCategory> onSelected;

  @override
  State<_CategorySearchSheet> createState() => _CategorySearchSheetState();
}

class _CategorySearchSheetState extends State<_CategorySearchSheet> {
  final _searchController = TextEditingController();
  List<DefectCategory> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.categories;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = widget.categories
          .where((cat) => cat.name.toLowerCase().contains(query) || (cat.description?.toLowerCase().contains(query) ?? false))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      child: SizedBox(
        height: 450,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'SELECT DEFECT CATEGORY',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              style: TextStyle(color: colors.textPrimary),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: colors.brandAccent),
                hintText: 'Search categories (e.g. Welding, Electrical...)',
                hintStyle: TextStyle(color: colors.textSecondary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.panelBorder)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.brandAccent)),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final cat = _filtered[index];
                  return ListTile(
                    title: Text(cat.name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold)),
                    subtitle: cat.description != null ? Text(cat.description!, style: TextStyle(color: colors.textSecondary)) : null,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onSelected(cat);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
