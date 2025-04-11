class wprModel {
   int wprNum;
  DateTime startDate;
  DateTime endDate;

  wprModel({
    required this.wprNum,
    required this.startDate,
    required this.endDate,
  });

   // Convert the model to JSON
   Map<String, dynamic> toJson() => {
     'wprNum': wprNum,
     'startDate': startDate,
     'endDate': endDate,
   };

   // Create a model from JSON
   factory wprModel.fromJson(Map<String, dynamic> json) {
     return wprModel(
       wprNum: json['pronouns'],
       startDate: json['startDate'],
       endDate: json['endDate'],
     );
   }
}