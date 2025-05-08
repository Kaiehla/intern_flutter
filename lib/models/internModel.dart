class internModel {
  String id;
  String pronouns;
  String name;
  DateTime birthday;
  String school;
  String company;
  String position;
  DateTime startDate;
  int hoursRequired;

  internModel({
    required this.id,
    required this.pronouns,
    required this.name,
    required this.birthday,
    required this.school,
    required this.company,
    required this.position,
    required this.startDate,
    required this.hoursRequired,
  });

  // Convert the model to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'pronouns': pronouns,
    'name': name,
    'birthday': birthday,
    'school': school,
    'company': company,
    'position': position,
    'startDate': startDate,
    'hoursRequired': hoursRequired,
  };

  // Create a model from JSON
  factory internModel.fromJson(Map<String, dynamic> json) {
    return internModel(
      id: json['id'],
      pronouns: json['pronouns'],
      name: json['name'],
      birthday: json['birthday'],
      school: json['school'],
      company: json['company'],
      position: json['position'],
      startDate: json['startDate'],
      hoursRequired: json['hoursRequired'],
    );
  }

  internModel copyWith({
    String? id,
    String? pronouns,
    String? name,
    DateTime? birthday,
    String? school,
    String? company,
    String? position,
    DateTime? startDate,
    int? hoursRequired,
  }) {
    return internModel(
      id: id ?? this.id,
      pronouns: pronouns ?? this.pronouns,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      school: school ?? this.school,
      company: company ?? this.company,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      hoursRequired: hoursRequired ?? this.hoursRequired,
    );
  }
}