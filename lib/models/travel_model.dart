class TravelModel {
  final String name, startdate, returndate, moneyTerm;
  final int budgetWon, travelerNum, id, countryId, remainBudget, leader;
  final bool review;

  TravelModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        budgetWon = json['budget_won'],
        remainBudget = json['remain_budget'],
        travelerNum = json['num_traveler'],
        id = json['id'],
        countryId = json['destination']['id'],
        startdate = json['start_date'],
        returndate = json['return_date'],
        moneyTerm = json['destination']['money_term'],
        review = json['isReview'],
        leader = json['leader'];
}
