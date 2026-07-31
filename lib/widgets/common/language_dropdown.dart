import 'package:flutter/material.dart';
import 'package:nutriscan/config/app_colors.dart';
import 'package:nutriscan/providers/theme/language_provider.dart';
import 'package:nutriscan/providers/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class LanguageDropdown extends StatelessWidget {
  final EdgeInsets? padding;
  final double? fontSize;
  final FontWeight? fontWeight;

  const LanguageDropdown({
    super.key,
    this.padding,
    this.fontSize,
    this.fontWeight,
  });

  static final List<Map<String, String>> _languages = [
    {'code': 'en', 'flag': '🇺🇸', 'name': 'English'},
    {'code': 'bn', 'flag': '🇧🇩', 'name': 'বাংলা'},
    {'code': 'hi', 'flag': '🇮🇳', 'name': 'हिन्दी'},
    {'code': 'es', 'flag': '🇪🇸', 'name': 'Español'},
    {'code': 'fr', 'flag': '🇫🇷', 'name': 'Français'},
    {'code': 'de', 'flag': '🇩🇪', 'name': 'Deutsch'},
    {'code': 'zh', 'flag': '🇨🇳', 'name': '中文'},
    {'code': 'tr', 'flag': '🇹🇷', 'name': 'Türkçe'},
    {'code': 'ko', 'flag': '🇰🇷', 'name': '한국어'},
    {'code': 'id', 'flag': '🇮🇩', 'name': 'Bahasa'},
    {'code': 'ja', 'flag': '🇯🇵', 'name': '日本語'},
    {'code': 'ru', 'flag': '🇷🇺', 'name': 'Русский'},
    {'code': 'ur', 'flag': '🇵🇰', 'name': 'اردو'},
    {'code': 'pt', 'flag': '🇵🇹', 'name': 'Português'},
    {'code': 'pt-BR', 'flag': '🇧🇷', 'name': 'Português (BR)'},
    {'code': 'ar', 'flag': '🇸🇦', 'name': 'العربية'},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        final currentLangCode = languageProvider.currentLanguage;

        // Ensure selected code exists in list, default to 'en'
        final validCode = _languages.any((l) => l['code'] == currentLangCode)
            ? currentLangCode
            : 'en';

        return Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.grey800.withValues(alpha: 0.6)
                : AppColors.grey100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? AppColors.grey700 : AppColors.grey300,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: validCode,
              isDense: true,
              isExpanded: false,
              alignment: Alignment.centerRight,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  languageProvider.setLanguage(newValue);
                }
              },
              dropdownColor: isDarkMode
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: isDarkMode
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                size: 18,
              ),
              selectedItemBuilder: (BuildContext context) {
                return _languages.map((lang) {
                  return Container(
                    constraints: const BoxConstraints(maxWidth: 85),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(lang['flag']!, style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            lang['name']!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: themeProvider.getFontForCurrentLanguage(
                              fontSize: fontSize ?? 12,
                              fontWeight: fontWeight ?? FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
              items: _languages.map((lang) {
                return DropdownMenuItem<String>(
                  value: lang['code'],
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(lang['flag']!, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          lang['name']!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: themeProvider.getFontForCurrentLanguage(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
