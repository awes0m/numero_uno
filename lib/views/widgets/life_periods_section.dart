import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../services/numerology_service.dart';

class LifePeriodsSection extends StatefulWidget {
  const LifePeriodsSection({
    super.key,
    required this.title,
    required this.periods,
    required this.icon,
    required this.color,
    this.isPinnacles = false,
    this.isChallenges = false,
    this.showMeanings = true,
    this.meaningProvider,
    this.labelProvider,
    this.enableYearNavigator = false,
    this.initialExpanded,
  });

  final String title;
  final Map<String, int> periods;
  final IconData icon;
  final Color color;
  final bool isPinnacles;
  final bool isChallenges;
  final bool showMeanings;
  final String Function(int number)? meaningProvider;
  final String Function(String key, int number)? labelProvider;
  final bool enableYearNavigator;
  final bool? initialExpanded;

  @override
  State<LifePeriodsSection> createState() => _LifePeriodsSectionState();
}

class _LifePeriodsSectionState extends State<LifePeriodsSection> {
  bool _expanded = true;
  String? _selectedYear;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initialExpanded ?? true;
    if (widget.enableYearNavigator && widget.periods.isNotEmpty) {
      final years = widget.periods.keys.toList()..sort();
      final currentYear = DateTime.now().year.toString();
      _selectedYear = years.contains(currentYear) ? currentYear : years.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;

    return Container(
      decoration: AppTheme.getCardDecoration(context),
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.icon, color: AppTheme.primaryPurple, size: 24),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              IconButton(
                tooltip: _expanded ? 'Collapse' : 'Expand',
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
            ],
          ),

          if (widget.enableYearNavigator && widget.periods.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacing8),
            _buildYearNavigator(context),
          ],

          const SizedBox(height: AppTheme.spacing8),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState:
                _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: _buildContent(context, color),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildYearNavigator(BuildContext context) {
    final years = widget.periods.keys.toList()..sort();
    if (_selectedYear == null && years.isNotEmpty) {
      _selectedYear = years.first;
    }

    final idx = years.indexOf(_selectedYear ?? '');

    void selectIdx(int newIdx) {
      if (newIdx >= 0 && newIdx < years.length) {
        setState(() => _selectedYear = years[newIdx]);
      }
    }

    final selectedNumber = _selectedYear != null
        ? widget.periods[_selectedYear!]
        : null;

    final meaning = (widget.meaningProvider != null && selectedNumber != null)
        ? widget.meaningProvider!(selectedNumber)
        : (widget.title == 'Essences' && selectedNumber != null)
            ? NumerologyService.getEssenceMeaning(selectedNumber)
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Previous year',
              onPressed: idx > 0 ? () => selectIdx(idx - 1) : null,
              icon: const Icon(Icons.chevron_left),
            ),
            const SizedBox(width: AppTheme.spacing8),
            DropdownButton<String>(
              value: _selectedYear,
              items: years
                  .map(
                    (y) => DropdownMenuItem(
                      value: y,
                      child: Text(y),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedYear = v),
            ),
            const SizedBox(width: AppTheme.spacing8),
            IconButton(
              tooltip: 'Next year',
              onPressed: idx >= 0 && idx < years.length - 1
                  ? () => selectIdx(idx + 1)
                  : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        if (selectedNumber != null) ...[
          const SizedBox(height: AppTheme.spacing8),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color:
                    Theme.of(context).colorScheme.primary.withOpacity(0.15),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected ${widget.title.substring(0, widget.title.length)}: $_selectedYear',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        selectedNumber.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (meaning != null && meaning.isNotEmpty) ...[
                        const SizedBox(height: AppTheme.spacing4),
                        Text(
                          meaning,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContent(BuildContext context, Color color) {
    if (widget.periods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(widget.icon, size: 20, color: color),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Text(
                'No ${widget.title} data available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color.withOpacity(0.8),
                    ),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: AppTheme.spacing8,
      runSpacing: AppTheme.spacing8,
      children: widget.periods.entries.map((entry) {
        final key = entry.key;
        final number = entry.value;
        final label = widget.labelProvider?.call(key, number) ??
            _defaultLabel(key, widget.isPinnacles, widget.isChallenges);
        final meaning = widget.showMeanings
            ? _resolveMeaning(number)
            : null;

        return Semantics(
          label: '${widget.title}: $label, number $number' +
              (meaning != null && meaning.isNotEmpty
                  ? ', meaning $meaning'
                  : ''),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(color: widget.color.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: widget.color,
                      ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  number.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                ),
                if (meaning != null && meaning.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    meaning,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: widget.color.withOpacity(0.8),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _defaultLabel(String key, bool isPinnacles, bool isChallenges) {
    if (isPinnacles) {
      switch (key) {
        case 'p1':
          return 'First Pinnacle';
        case 'p2':
          return 'Second Pinnacle';
        case 'p3':
          return 'Third Pinnacle';
        case 'p4':
          return 'Fourth Pinnacle';
      }
    }
    if (isChallenges) {
      switch (key) {
        case 'c1':
          return 'First Challenge';
        case 'c2':
          return 'Second Challenge';
        case 'c3':
          return 'Third Challenge';
        case 'c4':
          return 'Fourth Challenge';
      }
    }
    return key.toUpperCase();
  }

  String? _resolveMeaning(int number) {
    if (widget.isPinnacles) return _getPinnacleMeaning(number);
    if (widget.isChallenges) return _getChallengeMeaning(number);
    if (widget.meaningProvider != null) return widget.meaningProvider!(number);
    if (widget.title == 'Essences') {
      return NumerologyService.getEssenceMeaning(number);
    }
    if (widget.title == 'Personal Years') {
      return _getPersonalYearMeaning(number);
    }
    return null;
  }

  String _getPinnacleMeaning(int number) {
    switch (number) {
      case 1:
        return 'Leadership and independence';
      case 2:
        return 'Partnership and cooperation';
      case 3:
        return 'Creativity and expression';
      case 4:
        return 'Stability and foundation';
      case 5:
        return 'Adventure and change';
      case 6:
        return 'Harmony and responsibility';
      case 7:
        return 'Spiritual growth and wisdom';
      case 8:
        return 'Material success and power';
      case 9:
        return 'Completion and compassion';
      case 11:
        return 'Spiritual inspiration';
      case 22:
        return 'Master building';
      case 33:
        return 'Master healing';
      default:
        return 'Unique pinnacle energy';
    }
  }

  String _getChallengeMeaning(int number) {
    switch (number) {
      case 1:
        return 'Overcoming self-doubt';
      case 2:
        return 'Building confidence';
      case 3:
        return 'Finding focus and discipline';
      case 4:
        return 'Embracing change';
      case 5:
        return 'Finding stability';
      case 6:
        return 'Balancing responsibilities';
      case 7:
        return 'Trusting intuition';
      case 8:
        return 'Developing patience';
      case 9:
        return 'Letting go of the past';
      case 11:
        return 'Managing sensitivity';
      case 22:
        return 'Balancing vision with practicality';
      case 33:
        return 'Channeling healing energy';
      default:
        return 'Unique challenge to overcome';
    }
  }

  String _getPersonalYearMeaning(int number) {
    switch (number) {
      case 1:
        return 'A year of new beginnings and initiative.';
      case 2:
        return 'A year of partnerships, diplomacy, and patience.';
      case 3:
        return 'A year of creativity, expression, and social joy.';
      case 4:
        return 'A year of structure, discipline, and steady work.';
      case 5:
        return 'A year of change, freedom, and exploration.';
      case 6:
        return 'A year of responsibility, care, and harmony.';
      case 7:
        return 'A year of introspection, learning, and inner growth.';
      case 8:
        return 'A year of ambition, results, and material progress.';
      case 9:
        return 'A year of completion, compassion, and release.';
      default:
        return 'Unique personal year focus.';
    }
  }
}
