import 'package:nubida_front/models/review_model.dart';

class RecommendCountryModel {
  final String name;
  final double rate;
  final int review_cnt;
  final List<ReviewModel> reviewmodels;

  RecommendCountryModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        rate = json['rate'],
        review_cnt = json['review_cnt'],
        reviewmodels = (json['reviewDTOS'] as List<dynamic>?)
                ?.map((reviewJson) => ReviewModel.fromJson(reviewJson))
                .toList() ??
            [];
}
