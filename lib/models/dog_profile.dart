class DogProfile {
  DogProfile({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    required this.activityLevel,
    required this.healthConditions,
  });

  final String id;
  final String name;
  final String breed;
  final String age;
  final String weight;
  final String activityLevel;
  final String healthConditions;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'breed': breed,
        'age': age,
        'weight': weight,
        'activityLevel': activityLevel,
        'healthConditions': healthConditions,
      };

  factory DogProfile.fromJson(Map<String, dynamic> json) {
    return DogProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String,
      age: json['age'] as String,
      weight: json['weight'] as String,
      activityLevel: json['activityLevel'] as String,
      healthConditions: json['healthConditions'] as String,
    );
  }
}
