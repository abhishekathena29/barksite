class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.city = '',
    this.bio = '',
    this.photoUrl = '',
    this.selectedDogId,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String createdAt;
  final String city;
  final String bio;
  final String photoUrl;
  final String? selectedDogId;
  final String? updatedAt;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? createdAt,
    String? city,
    String? bio,
    String? photoUrl,
    String? selectedDogId,
    bool clearSelectedDogId = false,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      selectedDogId: clearSelectedDogId
          ? null
          : (selectedDogId ?? this.selectedDogId),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'createdAt': createdAt,
        'city': city,
        'bio': bio,
        'photoUrl': photoUrl,
        'selectedDogId': selectedDogId,
        'updatedAt': updatedAt,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      createdAt: (json['createdAt'] ?? DateTime.now().toIso8601String()) as String,
      city: (json['city'] ?? '') as String,
      bio: (json['bio'] ?? '') as String,
      photoUrl: (json['photoUrl'] ?? '') as String,
      selectedDogId: json['selectedDogId'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
