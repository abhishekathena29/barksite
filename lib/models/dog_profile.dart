class DogProfile {
  DogProfile({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    required this.activityLevel,
    required this.healthConditions,
    this.gender = '',
    this.birthday = '',
    this.allergies = '',
    this.foodPreference = '',
    this.notes = '',
    this.createdAt = '',
  });

  final String id;
  final String name;
  final String breed;
  final String age;
  final String weight;
  final String activityLevel;
  final String healthConditions;
  final String gender;
  final String birthday;
  final String allergies;
  final String foodPreference;
  final String notes;
  final String createdAt;

  DogProfile copyWith({
    String? id,
    String? name,
    String? breed,
    String? age,
    String? weight,
    String? activityLevel,
    String? healthConditions,
    String? gender,
    String? birthday,
    String? allergies,
    String? foodPreference,
    String? notes,
    String? createdAt,
  }) {
    return DogProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      healthConditions: healthConditions ?? this.healthConditions,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      allergies: allergies ?? this.allergies,
      foodPreference: foodPreference ?? this.foodPreference,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'breed': breed,
    'age': age,
    'weight': weight,
    'activityLevel': activityLevel,
    'healthConditions': healthConditions,
    'gender': gender,
    'birthday': birthday,
    'allergies': allergies,
    'foodPreference': foodPreference,
    'notes': notes,
    'createdAt': createdAt,
  };

  factory DogProfile.fromJson(Map<String, dynamic> json) {
    return DogProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String,
      age: json['age'] as String,
      weight: json['weight'] as String,
      activityLevel: json['activityLevel'] as String,
      healthConditions: (json['healthConditions'] ?? '') as String,
      gender: (json['gender'] ?? '') as String,
      birthday: (json['birthday'] ?? '') as String,
      allergies: (json['allergies'] ?? '') as String,
      foodPreference: (json['foodPreference'] ?? '') as String,
      notes: (json['notes'] ?? '') as String,
      createdAt: (json['createdAt'] ?? '') as String,
    );
  }
}
