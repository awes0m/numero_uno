// ---------------------------- ai_share_widget.dart ----------------------------
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/app_theme.dart';
import '../../models/numerology_result.dart';
import '../../models/dual_numerology_result.dart';
import '../../services/ai_share_service.dart';
import '../../utils/responsive_utils.dart';

class AiShareWidget extends StatefulWidget {
  final NumerologyResult result;
  final DualNumerologyResult? dualResult;

  const AiShareWidget({super.key, required this.result, this.dualResult});

  @override
  State<AiShareWidget> createState() => _AiShareWidgetState();
}

class _AiShareWidgetState extends State<AiShareWidget> {
  String _selectedPromptType = 'comprehensive';
  final TextEditingController _partnerNameController = TextEditingController();
  DateTime? _partnerBirthDate;

  @override
  void dispose() {
    _partnerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.getCardDecoration(context),
      padding: EdgeInsets.all(
        ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing8),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share to AI Assistant',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Get deeper insights from any AI assistant',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacing20),

          // Prompt Type Selection
          Text(
            'Choose Analysis Type:',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppTheme.spacing12),

          _buildPromptTypeSelector(),

          const SizedBox(height: AppTheme.spacing20),

          // Additional inputs for compatibility analysis
          if (_selectedPromptType == 'compatibility') ...[
            _buildCompatibilityInputs(),
            const SizedBox(height: AppTheme.spacing20),
          ],

          // Action Buttons
          _buildActionButtons(),

          const SizedBox(height: AppTheme.spacing16),

          // Info Text
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.lightPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(color: AppTheme.lightPurple.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: AppTheme.primaryPurple,
                ),
                const SizedBox(width: AppTheme.spacing8),
                Expanded(
                  child: Text(
                    'Copy the generated text and paste it into ChatGPT, Claude, Gemini, or any AI assistant for detailed analysis and predictions.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.textLight),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptTypeSelector() {
    final options = [
      {
        'value': 'comprehensive',
        'title': 'Complete Analysis',
        'subtitle': 'Full numerology report with predictions',
        'icon': Icons.analytics,
      },
      {
        'value': 'quick',
        'title': 'Quick Insights',
        'subtitle': 'Today\'s energy and key guidance',
        'icon': Icons.flash_on,
      },
      {
        'value': 'compatibility',
        'title': 'Relationship Match',
        'subtitle': 'Compatibility with partner',
        'icon': Icons.favorite,
      },
      {
        'value': 'career',
        'title': 'Career Guidance',
        'subtitle': 'Professional path and opportunities',
        'icon': Icons.work,
      },
    ];

    return Column(
      children: options.map((option) {
        final isSelected = _selectedPromptType == option['value'];
        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedPromptType = option['value'] as String;
                });
              },
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryPurple.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryPurple
                        : AppTheme.lightPurple.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      option['icon'] as IconData,
                      color: isSelected
                          ? AppTheme.primaryPurple
                          : AppTheme.textLight,
                      size: 24,
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option['title'] as String,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppTheme.primaryPurple
                                      : null,
                                ),
                          ),
                          Text(
                            option['subtitle'] as String,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.textLight),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.primaryPurple,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompatibilityInputs() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.lightPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.lightPurple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Partner Information (Optional):',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppTheme.spacing12),

          // Partner Name Input
          TextField(
            controller: _partnerNameController,
            decoration: InputDecoration(
              labelText: 'Partner\'s Name',
              hintText: 'Enter partner\'s full name',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing16,
                vertical: AppTheme.spacing12,
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacing12),

          // Partner Birth Date Input
          InkWell(
            onTap: _selectPartnerBirthDate,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing16,
                vertical: AppTheme.spacing12,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: Text(
                      _partnerBirthDate != null
                          ? 'Birth Date: ${_partnerBirthDate!.day}/${_partnerBirthDate!.month}/${_partnerBirthDate!.year}'
                          : 'Select Partner\'s Birth Date (Optional)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _partnerBirthDate != null
                            ? null
                            : AppTheme.textLight,
                      ),
                    ),
                  ),
                  if (_partnerBirthDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _partnerBirthDate = null;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _copyToClipboard,
            icon: const Icon(Icons.copy),
            label: const Text('Copy Prompt'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _sharePrompt,
            icon: const Icon(Icons.share),
            label: const Text('Share Prompt'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectPartnerBirthDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppTheme.primaryPurple),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _partnerBirthDate = date;
      });
    }
  }

  String _generatePromptText() {
    switch (_selectedPromptType) {
      case 'comprehensive':
        return AiShareService.generateAiPrompt(
          widget.result,
          widget.dualResult,
        );
      case 'quick':
        return AiShareService.generateQuickAiPrompt(widget.result);
      case 'compatibility':
        return AiShareService.generateCompatibilityPrompt(
          widget.result,
          _partnerNameController.text.trim().isEmpty
              ? 'Partner'
              : _partnerNameController.text.trim(),
          _partnerBirthDate,
        );
      case 'career':
        return AiShareService.generateCareerPrompt(widget.result);
      default:
        return AiShareService.generateAiPrompt(
          widget.result,
          widget.dualResult,
        );
    }
  }

  Future<void> _copyToClipboard() async {
    final promptText = _generatePromptText();
    await Clipboard.setData(ClipboardData(text: promptText));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: AppTheme.spacing8),
              const Text('AI prompt copied to clipboard!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _sharePrompt() async {
    final promptText = _generatePromptText();
    await Share.share(
      promptText,
      subject: 'Numerology Analysis Request - ${widget.result.fullName}',
    );
  }
}
