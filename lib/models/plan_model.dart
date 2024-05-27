class PlanModel {
  final String name;
  final int cost;
  final int id;
  final DateTime start_date, finish_date;
  PlanModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['plan_name'],
        cost = json['plan_cost'],
        start_date = DateTime.parse(json['start_date']),
        finish_date = DateTime.parse(json['finish_date']);
}
