import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nubida_front/models/review_model.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Country extends StatefulWidget {
  final String name;
  final double rate;
  final int review_cnt;
  final List<ReviewModel> reviews;
  const Country({
    super.key,
    required this.name,
    required this.rate,
    required this.review_cnt,
    required this.reviews,
  });

  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {},
      child: Container(
          width: screenWidth * 0.8,
          height: 200,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: const Offset(-5, 5),
                color: Colors.black.withOpacity(0.4),
              )
            ],
          ),
          child: Column(
            children: [
              AutoSizeText(
                widget.name,
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                minFontSize: 20,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              RatingBar.builder(
                initialRating: widget.rate,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
                updateOnDrag: false,
                ignoreGestures: true,
              ),
              Text("총 ${widget.review_cnt}개의 리뷰"),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.reviews.length,
                  itemBuilder: (context, index) {
                    final review = widget.reviews[index];
                    return ListTile(
                      title: Text(
                        review.subject ?? "제목 없음",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        review.content ?? "내용 없음",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      trailing: RatingBar.builder(
                        initialRating: review.rate,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20.0,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                        ignoreGestures: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
