class ReviewModel {
  final int? id;
  final String? subject;
  final String? content;
  final double rate;

  ReviewModel.fromJson(Map<String, dynamic> json)
      : subject = json['subject'] as String?,
        content = json['content'] as String?,
        id = json['id'] as int?,
        rate = (json['rate'] as num).toDouble();
}
