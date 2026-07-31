import 'package:flutter/material.dart';
import 'package:nutriscan/config/app_colors.dart';
import 'package:nutriscan/config/app_localizations.dart';
import 'package:nutriscan/providers/theme/language_provider.dart';
import 'package:nutriscan/providers/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;
  final List<String> periods;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.periods = const ['week', 'month', 'year'],
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        final periodLabels = [
          {
            'value': 'week',
            'label': AppLocalizations.getString(
              'week',
              languageProvider.currentLanguage,
            ),
          },
          {
            'value': 'month',
            'label': AppLocalizations.getString(
              'month',
              languageProvider.currentLanguage,
            ),
          },
          {
            'value': 'year',
            'label': AppLocalizations.getString(
              'year',
              languageProvider.currentLanguage,
            ),
          },
        ];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          child: Row(
            children: periodLabels.map((period) {
              final isSelected = selectedPeriod == period['value'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onPeriodChanged(period['value']!),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isDarkMode
                                ? AppColors.grey800.withValues(alpha: 0.5)
                                : AppColors.grey100),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDarkMode
                                  ? AppColors.grey700
                                  : AppColors.grey300),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      period['label']!,
                      textAlign: TextAlign.center,
                      style: themeProvider.getFontForCurrentLanguage(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white
                            : (isDarkMode
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
