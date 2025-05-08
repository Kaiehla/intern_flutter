class wprModel {
  String id;
  int wprNum;
  DateTime startDate;
  DateTime endDate;

  wprModel({
    required this.id,
    required this.wprNum,
    required this.startDate,
    required this.endDate,
  });

   // Convert the model to JSON
   Map<String, dynamic> toJson() => {
     'id': id,
     'wprNum': wprNum,
     'startDate': startDate.toIso8601String(),
     'endDate': endDate.toIso8601String(),
   };

   // Create a model from JSON
   factory wprModel.fromJson(Map<String, dynamic> json) {
     return wprModel(
       id: json['id'],
       wprNum: json['wprNum'],
       startDate: DateTime.parse(json['startDate']),
       endDate: DateTime.parse(json['endDate']),
     );
   }
}