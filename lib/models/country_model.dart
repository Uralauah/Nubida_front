class CountryModel {
  final String name, moneyTerm;
  final double rate;
  CountryModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        moneyTerm = json['money_term'],
        rate = json['rate'];
}
