import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final String? hint;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? errorText;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePicker({
    super.key,
    required this.label,
    this.hint,
    this.selectedDate,
    required this.onDateSelected,
    this.errorText,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),

        // Date Picker Field
        InkWell(
          key: const Key('date_picker_button'),
          onTap: () => _showDatePicker(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing16,
            ),
            decoration: BoxDecoration(
              color: AppTheme.softGray,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: errorText != null
                  ? Border.all(color: AppTheme.errorRed, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppTheme.textLight,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? dateFormat.format(selectedDate!)
                        : hint ?? 'Select date',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: selectedDate != null
                          ? AppTheme.textDark
                          : AppTheme.textLight,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppTheme.textLight,
                  size: 24,
                ),
              ],
            ),
          ),
        ),

        // Error Text
        if (errorText != null) ...[
          const SizedBox(height: AppTheme.spacing8),
          Text(
            errorText!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.errorRed),
          ),
        ],
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final initialDate =
        selectedDate ?? DateTime(now.year - 25, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryPurple,
              onPrimary: Colors.white,
              surface: AppTheme.mysticalWhite,
              onSurface: AppTheme.textDark,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppTheme.mysticalWhite,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }
}

// Segmented Date Picker (alternative implementation)
class SegmentedDatePicker extends StatefulWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? errorText;

  const SegmentedDatePicker({
    super.key,
    required this.label,
    this.selectedDate,
    required this.onDateSelected,
    this.errorText,
  });

  @override
  State<SegmentedDatePicker> createState() => _SegmentedDatePickerState();
}

class _SegmentedDatePickerState extends State<SegmentedDatePicker> {
  late TextEditingController _dayController;
  late TextEditingController _monthController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _dayController = TextEditingController();
    _monthController = TextEditingController();
    _yearController = TextEditingController();

    if (widget.selectedDate != null) {
      _updateControllers(widget.selectedDate!);
    }
  }

  @override
  void didUpdateWidget(SegmentedDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate &&
        widget.selectedDate != null) {
      _updateControllers(widget.selectedDate!);
    }
  }

  void _updateControllers(DateTime date) {
    _dayController.text = date.day.toString().padLeft(2, '0');
    _monthController.text = date.month.toString().padLeft(2, '0');
    _yearController.text = date.year.toString();
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),

        // Date Input Fields
        Row(
          children: [
            // Day
            Expanded(
              flex: 2,
              child: _buildDateField(
                controller: _dayController,
                hint: 'DD',
                maxLength: 2,
              ),
            ),
            const SizedBox(width: AppTheme.spacing8),
            Text(
              '/',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: AppTheme.textLight),
            ),
            const SizedBox(width: AppTheme.spacing8),

            // Month
            Expanded(
              flex: 2,
              child: _buildDateField(
                controller: _monthController,
                hint: 'MM',
                maxLength: 2,
              ),
            ),
            const SizedBox(width: AppTheme.spacing8),
            Text(
              '/',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: AppTheme.textLight),
            ),
            const SizedBox(width: AppTheme.spacing8),

            // Year
            Expanded(
              flex: 3,
              child: _buildDateField(
                controller: _yearController,
                hint: 'YYYY',
                maxLength: 4,
              ),
            ),
          ],
        ),

        // Error Text
        if (widget.errorText != null) ...[
          const SizedBox(height: AppTheme.spacing8),
          Text(
            widget.errorText!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.errorRed),
          ),
        ],
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String hint,
    required int maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: maxLength,
      onChanged: _onDateFieldChanged,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing8,
          vertical: AppTheme.spacing12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppTheme.softGray,
      ),
    );
  }

  void _onDateFieldChanged(String value) {
    final day = int.tryParse(_dayController.text);
    final month = int.tryParse(_monthController.text);
    final year = int.tryParse(_yearController.text);

    if (day != null && month != null && year != null) {
      try {
        final date = DateTime(year, month, day);
        if (date.day == day && date.month == month && date.year == year) {
          widget.onDateSelected(date);
        }
      } catch (e) {
        // Invalid date, ignore
      }
    }
  }
}
