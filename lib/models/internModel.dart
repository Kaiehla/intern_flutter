class internModel {
  String pronouns;
  String name;
  DateTime birthday;
  String school;
  String company;
  String position;
  DateTime startDate;
  int hoursRequired;

  internModel({
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
}