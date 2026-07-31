import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:nutriscan/config/app_colors.dart';
import 'package:nutriscan/config/app_localizations.dart';
import 'package:nutriscan/models/food.dart';
import 'package:nutriscan/providers/food/food_provider.dart';
import 'package:nutriscan/providers/theme/language_provider.dart';
import 'package:nutriscan/providers/theme/theme_provider.dart';
import 'package:nutriscan/utils/image_helper.dart';
import 'package:provider/provider.dart';

class FoodDetailCard extends StatefulWidget {
  final Food food;
  final VoidCallback? onFoodDeleted;

  const FoodDetailCard({
    super.key,
    required this.food,
    this.onFoodDeleted,
  });

  @override
  State<FoodDetailCard> createState() => _FoodDetailCardState();
}

class _FoodDetailCardState extends State<FoodDetailCard> {
  // Helper method to get styled text with current language font
  TextStyle _getStyledText({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return context.read<ThemeProvider>().getFontForCurrentLanguage(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final currentLanguage = languageProvider.currentLanguage;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image and Basic Info
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              image: widget.food.effectiveImageUrl.isNotEmpty
                  ? ImageHelper.getDecorationImage(
                      widget.food.effectiveImageUrl,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                // Fallback widget when no image
                if (widget.food.effectiveImageUrl.isEmpty)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        IconlyLight.image,
                        color: Colors.grey,
                        size: 48,
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getHealthScoreColor(widget.food.healthScore),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${AppLocalizations.getString('score', currentLanguage)}: ${widget.food.healthScore}',
                      style: _getStyledText(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.black.withValues(alpha: 0.75)
                          : Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.food.name,
                      style: _getStyledText(
                        color: isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Builder(
                  builder: (_) {
                    final isEmpty = widget.food.description.trim().isEmpty ||
                        widget.food.description == 'No description available';
                    final text = isEmpty
                        ? AppLocalizations.getString(
                            'no_description_available', currentLanguage)
                        : widget.food.description;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.getString(
                              'description', currentLanguage),
                          style: _getStyledText(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          text,
                          style: _getStyledText(
                            fontSize: 13,
                            color: isDarkMode
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),

                // Nutrition Grid
                Text(
                  AppLocalizations.getString('nutrition', currentLanguage),
                  style: _getStyledText(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 3.4,
                  children: [
                    _buildNutritionChip(
                      AppLocalizations.getString('calories', currentLanguage),
                      '${widget.food.calories.toStringAsFixed(0)} kcal',
                      Colors.orange,
                    ),
                    _buildNutritionChip(
                      AppLocalizations.getString('protein', currentLanguage),
                      '${widget.food.protein.toStringAsFixed(1)}g',
                      Colors.blue,
                    ),
                    _buildNutritionChip(
                      AppLocalizations.getString('carbs', currentLanguage),
                      '${widget.food.carbs.toStringAsFixed(1)}g',
                      Colors.green,
                    ),
                    _buildNutritionChip(
                      AppLocalizations.getString('fat', currentLanguage),
                      '${widget.food.fat.toStringAsFixed(1)}g',
                      Colors.red,
                    ),
                    _buildNutritionChip(
                      AppLocalizations.getString('fiber', currentLanguage),
                      '${widget.food.fiber.toStringAsFixed(1)}g',
                      Colors.purple,
                    ),
                    _buildNutritionChip(
                      AppLocalizations.getString('sugar', currentLanguage),
                      '${widget.food.sugar.toStringAsFixed(1)}g',
                      Colors.pink,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Health Benefits
                if (widget.food.healthBenefits.isNotEmpty) ...[
                  Text(
                    AppLocalizations.getString(
                      'health_benefits',
                      currentLanguage,
                    ),
                    style: _getStyledText(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.food.healthBenefits.join('\n'),
                    style: _getStyledText(
                      fontSize: 14,
                      color: isDarkMode
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Health Warnings
                if (widget.food.healthWarnings.isNotEmpty) ...[
                  Text(
                    AppLocalizations.getString(
                      'health_warnings',
                      currentLanguage,
                    ),
                    style: _getStyledText(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.food.healthWarnings.join('\n'),
                    style: _getStyledText(
                      fontSize: 14,
                      color: isDarkMode
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Serving Size and Date
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.getString(
                              'serving_size',
                              currentLanguage,
                            ),
                            style: _getStyledText(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.food.servingSize,
                            style: _getStyledText(
                              fontSize: 14,
                              color: isDarkMode
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.getString('date', currentLanguage),
                            style: _getStyledText(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat(
                              'dd MMM yyyy',
                            ).format(widget.food.analyzedAt),
                            style: _getStyledText(
                              fontSize: 12,
                              color: isDarkMode
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Delete Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showDeleteDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(IconlyBold.delete, size: 20),
                    label: Text(
                      AppLocalizations.getString('delete', currentLanguage),
                      style: _getStyledText(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: _getStyledText(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: context.read<ThemeProvider>().getFontForCurrentLanguage(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Color _getHealthScoreColor(int score) {
    if (score >= 8) return Colors.green;
    if (score >= 6) return Colors.orange;
    if (score >= 4) return Colors.yellow[700]!;
    return Colors.red;
  }

  void _showDeleteDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final isDarkMode = themeProvider.isDarkMode;
    final currentLanguage = languageProvider.currentLanguage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withValues(alpha: 0.5)
                      : Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    IconlyBold.delete,
                    size: 48,
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  AppLocalizations.getString('delete_food', currentLanguage),
                  style: context
                      .read<ThemeProvider>()
                      .getFontForCurrentLanguage(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  '${AppLocalizations.getString('delete_confirmation', currentLanguage)} "${widget.food.name}"?',
                  style: context
                      .read<ThemeProvider>()
                      .getFontForCurrentLanguage(
                        fontSize: 15,
                        color: isDarkMode
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        height: 1.4,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.grey800
                              : AppColors.grey100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.getString(
                              'cancel',
                              currentLanguage,
                            ),
                            style: context
                                .read<ThemeProvider>()
                                .getFontForCurrentLanguage(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Delete Button
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.red[500],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            await context.read<FoodProvider>().deleteFood(
                              widget.food.id,
                            );
                            if (!mounted) return;
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                            // Notify parent screen to refresh
                            if (widget.onFoodDeleted != null) {
                              widget.onFoodDeleted!();
                            }
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.getString(
                              'delete',
                              currentLanguage,
                            ),
                            style: context
                                .read<ThemeProvider>()
                                .getFontForCurrentLanguage(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
