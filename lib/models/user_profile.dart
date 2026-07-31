import 'dart:convert';

enum Gender { male, female }

enum ActivityLevel {
  sedentary, // 1.2
  lightlyActive, // 1.375
  moderatelyActive, // 1.55
  veryActive, // 1.725
  extraActive, // 1.9
}

enum FitnessGoal {
  fatLoss, // -500 kcal
  maintain, // 0 kcal
  muscleGain, // +350 kcal
}

class UserProfile {
  final Gender gender;
  final int age;
  final double weightKg;
  final double heightCm;
  final ActivityLevel activityLevel;
  final FitnessGoal fitnessGoal;

  const UserProfile({
    this.gender = Gender.male,
    this.age = 25,
    this.weightKg = 70.0,
    this.heightCm = 175.0,
    this.activityLevel = ActivityLevel.moderatelyActive,
    this.fitnessGoal = FitnessGoal.fatLoss,
  });

  /// Mifflin-St Jeor Equation for BMR calculation
  double get bmr {
    double baseBmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    if (gender == Gender.male) {
      return baseBmr + 5;
    } else {
      return baseBmr - 161;
    }
  }

  /// Multiplier for Total Daily Energy Expenditure
  double get activityMultiplier {
    switch (activityLevel) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extraActive:
        return 1.9;
    }
  }

  /// Total Daily Energy Expenditure (TDEE)
  double get tdee => bmr * activityMultiplier;

  /// Target Daily Calories based on Fitness Goal
  double get targetCalories {
    switch (fitnessGoal) {
      case FitnessGoal.fatLoss:
        return (tdee - 500).clamp(1200.0, 4500.0);
      case FitnessGoal.maintain:
        return tdee;
      case FitnessGoal.muscleGain:
        return tdee + 350;
    }
  }

  /// Target Protein in grams (~2g per kg body weight)
  double get targetProteinGrams => (weightKg * 2.0).clamp(50.0, 250.0);

  /// Target Fat in grams (~25% of total calories)
  double get targetFatGrams => (targetCalories * 0.25 / 9.0).clamp(30.0, 150.0);

  /// Target Carbs in grams (Remaining calories)
  double get targetCarbsGrams {
    double proteinCalories = targetProteinGrams * 4.0;
    double fatCalories = targetFatGrams * 9.0;
    double remainingCalories = targetCalories - (proteinCalories + fatCalories);
    return (remainingCalories / 4.0).clamp(50.0, 500.0);
  }

  UserProfile copyWith({
    Gender? gender,
    int? age,
    double? weightKg,
    double? heightCm,
    ActivityLevel? activityLevel,
    FitnessGoal? fitnessGoal,
  }) {
    return UserProfile(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      activityLevel: activityLevel ?? this.activityLevel,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gender': gender.name,
      'age': age,
      'weightKg': weightKg,
      'heightCm': heightCm,
      'activityLevel': activityLevel.name,
      'fitnessGoal': fitnessGoal.name,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      gender: Gender.values.firstWhere(
        (e) => e.name == map['gender'],
        orElse: () => Gender.male,
      ),
      age: map['age']?.toInt() ?? 25,
      weightKg: (map['weightKg'] as num?)?.toDouble() ?? 70.0,
      heightCm: (map['heightCm'] as num?)?.toDouble() ?? 175.0,
      activityLevel: ActivityLevel.values.firstWhere(
        (e) => e.name == map['activityLevel'],
        orElse: () => ActivityLevel.moderatelyActive,
      ),
      fitnessGoal: FitnessGoal.values.firstWhere(
        (e) => e.name == map['fitnessGoal'],
        orElse: () => FitnessGoal.fatLoss,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source));
}
