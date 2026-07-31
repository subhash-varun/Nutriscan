import 'package:flutter/material.dart';
import 'package:nutriscan/config/app_colors.dart';
import 'package:nutriscan/models/user_profile.dart';
import 'package:nutriscan/providers/theme/theme_provider.dart';
import 'package:nutriscan/providers/user/user_profile_provider.dart';
import 'package:provider/provider.dart';

class EditGoalsDialog extends StatefulWidget {
  const EditGoalsDialog({super.key});

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const EditGoalsDialog(),
    );
  }

  @override
  State<EditGoalsDialog> createState() => _EditGoalsDialogState();
}

class _EditGoalsDialogState extends State<EditGoalsDialog> {
  late Gender _gender;
  late int _age;
  late double _weightKg;
  late double _heightCm;
  late ActivityLevel _activityLevel;
  late FitnessGoal _fitnessGoal;

  @override
  void initState() {
    super.initState();
    final profile = context.read<UserProfileProvider>().profile;
    _gender = profile.gender;
    _age = profile.age;
    _weightKg = profile.weightKg;
    _heightCm = profile.heightCm;
    _activityLevel = profile.activityLevel;
    _fitnessGoal = profile.fitnessGoal;
  }

  String _formatGoal(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.fatLoss:
        return 'Fat Loss (-500 kcal)';
      case FitnessGoal.maintain:
        return 'Maintenance';
      case FitnessGoal.muscleGain:
        return 'Muscle Gain (+350 kcal)';
    }
  }

  String _formatActivity(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary (Little/no exercise)';
      case ActivityLevel.lightlyActive:
        return 'Light (1-3 days/week)';
      case ActivityLevel.moderatelyActive:
        return 'Moderate (3-5 days/week)';
      case ActivityLevel.veryActive:
        return 'Active (6-7 days/week)';
      case ActivityLevel.extraActive:
        return 'Athlete (Very intense)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final tempProfile = UserProfile(
      gender: _gender,
      age: _age,
      weightKg: _weightKg,
      heightCm: _heightCm,
      activityLevel: _activityLevel,
      fitnessGoal: _fitnessGoal,
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Personal Goals & TDEE',
                    style: themeProvider.getFontForCurrentLanguage(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // TDEE Preview Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Target Daily Intake',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${tempProfile.targetCalories.round()} kcal/day',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMacroBadge('Protein', '${tempProfile.targetProteinGrams.round()}g'),
                      _buildMacroBadge('Carbs', '${tempProfile.targetCarbsGrams.round()}g'),
                      _buildMacroBadge('Fat', '${tempProfile.targetFatGrams.round()}g'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Gender Selector
            Text(
              'Gender',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<Gender>(
              segments: const [
                ButtonSegment(value: Gender.male, label: Text('Male'), icon: Icon(Icons.male)),
                ButtonSegment(value: Gender.female, label: Text('Female'), icon: Icon(Icons.female)),
              ],
              selected: {_gender},
              onSelectionChanged: (val) => setState(() => _gender = val.first),
            ),
            const SizedBox(height: 16),

            // Weight Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Weight', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('${_weightKg.toStringAsFixed(1)} kg', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: _weightKg,
              min: 40.0,
              max: 180.0,
              divisions: 280,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _weightKg = val),
            ),

            // Height Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Height', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('${_heightCm.round()} cm', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: _heightCm,
              min: 120.0,
              max: 220.0,
              divisions: 100,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _heightCm = val),
            ),

            // Age Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Age', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('$_age years', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: _age.toDouble(),
              min: 15.0,
              max: 90.0,
              divisions: 75,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _age = val.round()),
            ),

            // Goal Dropdown
            const Text('Goal', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            DropdownButtonFormField<FitnessGoal>(
              initialValue: _fitnessGoal,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: FitnessGoal.values
                  .map((g) => DropdownMenuItem(value: g, child: Text(_formatGoal(g))))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _fitnessGoal = val);
              },
            ),
            const SizedBox(height: 16),

            // Activity Dropdown
            const Text('Activity Level', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            DropdownButtonFormField<ActivityLevel>(
              initialValue: _activityLevel,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: ActivityLevel.values
                  .map((a) => DropdownMenuItem(value: a, child: Text(_formatActivity(a), overflow: TextOverflow.ellipsis)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _activityLevel = val);
              },
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  context.read<UserProfileProvider>().updateProfile(tempProfile);
                  Navigator.pop(context);
                },
                child: const Text('Save Goals', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBadge(String label, String val) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}
