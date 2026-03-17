class ScheduleItem {
  ScheduleItem({
    required this.id,
    required this.title,
    required this.type,
    required this.dateTime,
    this.notes = '',
    this.durationMinutes = 30,
    this.isCompleted = false,
    this.createdAt = '',
  });

  final String id;
  final String title;
  final String type;
  final String dateTime;
  final String notes;
  final int durationMinutes;
  final bool isCompleted;
  final String createdAt;

  DateTime get startsAt => DateTime.tryParse(dateTime) ?? DateTime.now();

  ScheduleItem copyWith({
    String? id,
    String? title,
    String? type,
    String? dateTime,
    String? notes,
    int? durationMinutes,
    bool? isCompleted,
    String? createdAt,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type,
    'dateTime': dateTime,
    'notes': notes,
    'durationMinutes': durationMinutes,
    'isCompleted': isCompleted,
    'createdAt': createdAt,
  };

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'] as String,
      title: (json['title'] ?? '') as String,
      type: (json['type'] ?? 'meal') as String,
      dateTime:
          (json['dateTime'] ?? DateTime.now().toIso8601String()) as String,
      notes: (json['notes'] ?? '') as String,
      durationMinutes: (json['durationMinutes'] ?? 30) as int,
      isCompleted: (json['isCompleted'] ?? false) as bool,
      createdAt: (json['createdAt'] ?? '') as String,
    );
  }
}
