import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:nutriscan/config/app_colors.dart';
import 'package:nutriscan/config/app_localizations.dart';
import 'package:nutriscan/providers/theme/language_provider.dart';
import 'package:nutriscan/providers/theme/theme_provider.dart';
import 'package:nutriscan/providers/user/user_profile_provider.dart';
import 'package:nutriscan/widgets/profile/edit_goals_dialog.dart';
import 'package:provider/provider.dart';

class NutritionSummaryCard extends StatelessWidget {
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final String? title;
  final Color? backgroundColor;
  final Color? textColor;

  const NutritionSummaryCard({
    super.key,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    this.title,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, LanguageProvider, UserProfileProvider>(
      builder: (context, themeProvider, languageProvider, userProfileProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        final bgColor = backgroundColor ?? AppColors.primary;
        final txtColor = textColor ?? Colors.white;
        final profile = userProfileProvider.profile;

        final targetCal = profile.targetCalories;
        final remainingCal = (targetCal - totalCalories).clamp(0.0, targetCal);
        final calProgress = (totalCalories / targetCal).clamp(0.0, 1.0);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title ??
                        AppLocalizations.getString(
                          'nutrition_summary',
                          languageProvider.currentLanguage,
                        ),
                    style: themeProvider.getFontForCurrentLanguage(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: txtColor,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(Icons.edit_note, color: txtColor, size: 24),
                        onPressed: () => EditGoalsDialog.show(context),
                      ),
                      Icon(IconlyBold.chart, color: txtColor, size: 22),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Calorie Progress Ring / Summary Box
              Row(
                children: [
                  // Circular Indicator
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: calProgress,
                          strokeWidth: 7,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        Text(
                          '${(calProgress * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${totalCalories.toStringAsFixed(0)} / ${targetCal.round()} kcal',
                          style: themeProvider.getFontForCurrentLanguage(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: txtColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${remainingCal.round()} kcal remaining',
                          style: themeProvider.getFontForCurrentLanguage(
                            fontSize: 13,
                            color: txtColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Macro Progress Bars
              _buildMacroProgress(
                context,
                'Protein',
                totalProtein,
                profile.targetProteinGrams,
                'g',
                txtColor,
                themeProvider,
              ),
              const SizedBox(height: 10),
              _buildMacroProgress(
                context,
                'Carbs',
                totalCarbs,
                profile.targetCarbsGrams,
                'g',
                txtColor,
                themeProvider,
              ),
              const SizedBox(height: 10),
              _buildMacroProgress(
                context,
                'Fat',
                totalFat,
                profile.targetFatGrams,
                'g',
                txtColor,
                themeProvider,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMacroProgress(
    BuildContext context,
    String label,
    double current,
    double target,
    String unit,
    Color textColor,
    ThemeProvider themeProvider,
  ) {
    final progress = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: themeProvider.getFontForCurrentLanguage(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: textColor.withValues(alpha: 0.9),
              ),
            ),
            Text(
              '${current.toStringAsFixed(1)} / ${target.round()} $unit',
              style: themeProvider.getFontForCurrentLanguage(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    );
  }
}
