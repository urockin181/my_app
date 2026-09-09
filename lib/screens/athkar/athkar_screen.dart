import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/athkar_item.dart';
import '../../services/athkar_service.dart';

class AthkarScreen extends StatefulWidget {
  const AthkarScreen({super.key});

  @override
  State<AthkarScreen> createState() => _AthkarScreenState();
}

class _AthkarScreenState extends State<AthkarScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _athkarService = AthkarService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.athkarSabah),
            Tab(text: l10n.athkarMasaa),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _AthkarList(target: AthkarTarget.morning, service: _athkarService),
              _AthkarList(target: AthkarTarget.evening, service: _athkarService),
            ],
          ),
        ),
      ],
    );
  }
}

class _AthkarList extends StatefulWidget {
  const _AthkarList({required this.target, required this.service});

  final AthkarTarget target;
  final AthkarService service;

  @override
  State<_AthkarList> createState() => _AthkarListState();
}

class _AthkarListState extends State<_AthkarList> {
  Future<List<AthkarItem>>? _future;
  String? _loadedLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (_loadedLanguage != languageCode) {
      _loadedLanguage = languageCode;
      _load(languageCode);
    }
  }

  void _load(String languageCode) {
    setState(() {
      _future = widget.service.fetch(widget.target, languageCode: languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<List<AthkarItem>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(l10n.athkarLoading),
              ],
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(l10n.athkarError, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => _load(_loadedLanguage!),
                    child: Text(l10n.athkarRetry),
                  ),
                ],
              ),
            ),
          );
        }

        final items = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) => _AthkarCard(item: items[index]),
        );
      },
    );
  }
}

class _AthkarCard extends StatefulWidget {
  const _AthkarCard({required this.item});

  final AthkarItem item;

  @override
  State<_AthkarCard> createState() => _AthkarCardState();
}

class _AthkarCardState extends State<_AthkarCard> {
  late int _remaining = widget.item.repeatCount;

  void _tap() {
    if (_remaining <= 0) return;
    setState(() => _remaining--);
  }

  void _reset() => setState(() => _remaining = widget.item.repeatCount);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final done = _remaining <= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _tap,
        child: Opacity(
          opacity: done ? 0.55 : 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.item.text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6)),
                if (widget.item.reference.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.item.reference,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.outline),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Chip(
                      label: Text(
                        done ? l10n.athkarCompleted : l10n.athkarCount('$_remaining'),
                      ),
                      backgroundColor: done ? scheme.primaryContainer : null,
                    ),
                    const Spacer(),
                    if (_remaining != widget.item.repeatCount)
                      TextButton(onPressed: _reset, child: Text(l10n.athkarReset)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
