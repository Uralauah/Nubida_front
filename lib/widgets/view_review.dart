import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:nubida_front/services/service.dart';

class ViewReview extends StatefulWidget {
  final int id;
  const ViewReview({
    super.key,
    required this.id,
  });

  @override
  State<ViewReview> createState() => _ViewReviewState();
}

class _ViewReviewState extends State<ViewReview> {
  late Future<Map<String, dynamic>> review;

  @override
  void initState() {
    super.initState();
    review = Service().getReview(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: review,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${snapshot.data!['subject']}",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 180,
                child: TextFormField(
                  initialValue: "${snapshot.data!['content']}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  readOnly: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
              const Spacer(),
              RatingBar.builder(
                initialRating: snapshot.data!['rate'],
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  // No action needed as we want to prevent rating changes
                },
                ignoreGestures: true,
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
      }),
    );
  }
}
