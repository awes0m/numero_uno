import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
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
        
        // Text Field
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppTheme.textLight,
                    size: 20,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      suffixIcon,
                      color: AppTheme.textLight,
                      size: 20,
                    ),
                    onPressed: onSuffixIconPressed,
                  )
                : null,
            errorText: errorText,
            counterText: maxLength != null ? null : '',
          ),
        ),
      ],
    );
  }
}

// Specialized text field for names
class NameTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const NameTextField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: 'Full Name',
      hint: 'Enter your full name',
      prefixIcon: Icons.person_outline,
      errorText: errorText,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
        LengthLimitingTextInputFormatter(50),
      ],
      onChanged: onChanged,
    );
  }
}

// Specialized text field for search
class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchTextField({
    super.key,
    required this.controller,
    this.hint,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint ?? 'Search...',
        prefixIcon: const Icon(
          Icons.search,
          color: AppTheme.textLight,
          size: 20,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: AppTheme.textLight,
                  size: 20,
                ),
                onPressed: () {
                  controller.clear();
                  onClear?.call();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppTheme.softGray,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          vertical: AppTheme.spacing12,
        ),
      ),
    );
  }
}