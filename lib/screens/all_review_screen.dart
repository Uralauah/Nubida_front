import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nubida_front/models/review_model.dart';
import 'package:nubida_front/services/service.dart';
import 'package:nubida_front/widgets/review_widget.dart';

class AllReview extends StatefulWidget {
  const AllReview({super.key});

  @override
  State<AllReview> createState() => _AllReviewState();
}

class _AllReviewState extends State<AllReview> {
  Future<List<ReviewModel>> reviews = Service().getAllReview();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed('/bab');
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text("모든 리뷰 목록"),
            ),
            body: FutureBuilder(
              future: reviews,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "작성된 리뷰가 없어요..",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return ShaderMask(
                    shaderCallback: (Rect rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white,
                          Colors.white,
                          Colors.transparent
                        ],
                        stops: [0.0, 0.03, 0.97, 1.0],
                      ).createShader(rect);
                    },
                    child: makeList(snapshot),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }
              },
            )),
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<ReviewModel>> snapshot) {
    return ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var review = snapshot.data![index];
          return Review(
            id: review.id,
            subject: review.subject,
            content: review.content,
            rate: review.rate,
          );
        },
        separatorBuilder: ((context, index) => const SizedBox(
              height: 10,
            )),
        itemCount: snapshot.data!.length);
  }
}
