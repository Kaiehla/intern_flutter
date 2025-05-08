  class LogModel {
    String task;
    DateTime date;
    int hours;
    String description;
    String wprId;

    LogModel({
      required this.task,
      required this.date,
      required this.hours,
      required this.description,
      required this.wprId,
    });

    Map<String, dynamic> toJson() => {
      'task': task,
      'date': date.toIso8601String(),
      'hours': hours,
      'description': description,
      'wprId': wprId,
    };

    factory LogModel.fromJson(Map<String, dynamic> json) {
      return LogModel(
        task: json['task'],
        date: DateTime.parse(json['date']),
        hours: json['hours'],
        description: json['description'],
        wprId: json['wprId']
      );
    }
  }
