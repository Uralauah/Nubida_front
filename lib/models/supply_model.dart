class SupplyModel {
  final String name;
  final int count;
  final bool check;
  SupplyModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        count = json['count'],
        check = json['check'];
}
