class LogModel {
  String task;
  DateTime date;
  int hours;
  String description;

  LogModel({
    required this.task,
    required this.date,
    required this.hours,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'task': task,
    'date': date.toIso8601String(),
    'hours': hours,
    'description': description,
  };

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      task: json['task'],
      date: DateTime.parse(json['date']),
      hours: json['hours'],
      description: json['description'],
    );
  }
}
