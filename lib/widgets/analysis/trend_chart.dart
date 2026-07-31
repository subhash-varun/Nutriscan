import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutriscan/config/app_colors.dart';
import 'package:nutriscan/config/app_localizations.dart';
import 'package:nutriscan/models/food.dart';
import 'package:nutriscan/providers/theme/language_provider.dart';
import 'package:nutriscan/providers/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ChartBucket {
  final String label;
  final double value;
  final DateTime date;

  ChartBucket({
    required this.label,
    required this.value,
    required this.date,
  });
}

class TrendChart extends StatelessWidget {
  final List<Food> foods;
  final String metric;
  final String period;
  final double height;
  final String? title;

  const TrendChart({
    super.key,
    required this.foods,
    required this.metric,
    this.period = 'week',
    this.height = 370,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;

        final buckets = _aggregateData(foods, metric, period);
        if (buckets.isEmpty) return const SizedBox.shrink();

        final spots = buckets
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.value))
            .toList();

        final maxValue = spots.fold(
          0.0,
          (max, spot) => spot.y > max ? spot.y : max,
        );
        final minValue = spots.fold(
          double.infinity,
          (min, spot) => spot.y < min ? spot.y : min,
        );

        final valueRange = maxValue - (minValue == double.infinity ? 0.0 : minValue);
        final safeMinValue = (minValue == double.infinity || valueRange == 0)
            ? (minValue == double.infinity ? 0.0 : minValue - 1)
            : minValue;
        final safeMaxValue = valueRange == 0 ? maxValue + 10 : maxValue;
        final safeRange = (safeMaxValue - safeMinValue) == 0 ? 10.0 : (safeMaxValue - safeMinValue);

        // X-axis label interval logic
        final int interval = period == 'month' ? 5 : 1;

        return Container(
          height: height,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
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
              Text(
                title ??
                    '${AppLocalizations.getString(metric, languageProvider.currentLanguage)} ${AppLocalizations.getString('trends', languageProvider.currentLanguage)}',
                style: themeProvider.getFontForCurrentLanguage(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: safeRange / 4 > 0 ? safeRange / 4 : 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: isDarkMode
                              ? AppColors.grey600.withValues(alpha: 0.3)
                              : AppColors.grey300.withValues(alpha: 0.3),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          interval: safeRange / 4 > 0 ? safeRange / 4 : 1,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: isDarkMode
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: interval.toDouble(),
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx >= 0 && idx < buckets.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  buckets[idx].label,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDarkMode
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (spots.length - 1).toDouble(),
                    minY: safeMinValue * 0.9,
                    maxY: safeMaxValue * 1.1,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: spots.length <= 12,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: AppColors.primary,
                              strokeWidth: 2,
                              strokeColor: isDarkMode
                                  ? AppColors.surfaceDark
                                  : AppColors.surfaceLight,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<ChartBucket> _aggregateData(
    List<Food> foods,
    String metric,
    String period,
  ) {
    final now = DateTime.now();

    if (period == 'week') {
      // Past 7 Days
      final Map<String, double> dayTotals = {};
      final List<ChartBucket> result = [];

      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final key = DateFormat('yyyy-MM-dd').format(date);
        dayTotals[key] = 0.0;
      }

      for (final food in foods) {
        final key = DateFormat('yyyy-MM-dd').format(food.analyzedAt);
        if (dayTotals.containsKey(key)) {
          dayTotals[key] = (dayTotals[key] ?? 0.0) + _getMetricValue(food, metric);
        }
      }

      dayTotals.forEach((keyStr, val) {
        final date = DateFormat('yyyy-MM-dd').parse(keyStr);
        final label = DateFormat('E').format(date); // Mon, Tue...
        result.add(ChartBucket(label: label, value: val, date: date));
      });

      return result;
    } else if (period == 'month') {
      // Past 30 Days
      final Map<String, double> dayTotals = {};
      final List<ChartBucket> result = [];

      for (int i = 29; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final key = DateFormat('yyyy-MM-dd').format(date);
        dayTotals[key] = 0.0;
      }

      for (final food in foods) {
        final key = DateFormat('yyyy-MM-dd').format(food.analyzedAt);
        if (dayTotals.containsKey(key)) {
          dayTotals[key] = (dayTotals[key] ?? 0.0) + _getMetricValue(food, metric);
        }
      }

      dayTotals.forEach((keyStr, val) {
        final date = DateFormat('yyyy-MM-dd').parse(keyStr);
        final label = DateFormat('d/M').format(date); // e.g. 15/7
        result.add(ChartBucket(label: label, value: val, date: date));
      });

      return result;
    } else if (period == 'year') {
      // Past 12 Months
      final Map<String, double> monthTotals = {};
      final List<ChartBucket> result = [];

      for (int i = 11; i >= 0; i--) {
        final date = DateTime(now.year, now.month - i, 1);
        final key = DateFormat('yyyy-MM').format(date);
        monthTotals[key] = 0.0;
      }

      for (final food in foods) {
        final key = DateFormat('yyyy-MM').format(food.analyzedAt);
        if (monthTotals.containsKey(key)) {
          monthTotals[key] = (monthTotals[key] ?? 0.0) + _getMetricValue(food, metric);
        }
      }

      monthTotals.forEach((keyStr, val) {
        final date = DateFormat('yyyy-MM').parse(keyStr);
        final label = DateFormat('MMM').format(date); // Jan, Feb...
        result.add(ChartBucket(label: label, value: val, date: date));
      });

      return result;
    }

    return [];
  }

  double _getMetricValue(Food food, String metric) {
    switch (metric) {
      case 'calories':
        return food.calories;
      case 'protein':
        return food.protein;
      case 'carbs':
        return food.carbs;
      case 'fat':
        return food.fat;
      default:
        return food.calories;
    }
  }
}
