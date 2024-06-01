import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nubida_front/main.dart';
import 'package:nubida_front/services/service.dart';
import 'package:nubida_front/widgets/add_review.dart';
import 'package:http/http.dart' as http;

class Review extends StatefulWidget {
  final int? id;
  final String? subject, content;
  final double rate;
  const Review({
    super.key,
    required this.id,
    required this.subject,
    required this.content,
    required this.rate,
  });

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => TravelDetail(
        //       name: widget.name,
        //       id: widget.id,
        //       leader: widget.leader,
        //       budgetWon: widget.budgetWon,
        //       startdate: widget.startdate,
        //       returndate: widget.returndate,
        //       countryName: countryName,
        //       moneyTerm: widget.moneyTerm,
        //       remainBudget: widget.remainBudget,
        //     ),
        //     settings: RouteSettings(
        //       arguments: {
        //         'name': widget.name,
        //         'budgetWon': widget.budgetWon,
        //         'id': widget.id,
        //         'countryName': countryName,
        //         'moneyTerm': widget.moneyTerm,
        //       },
        //     ),
        //   ),
        // );
      },
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.subject!,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      var result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text(
                              "리뷰 등록",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.grey[350]),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '닫기',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            content: SizedBox(
                              width: screenWidth * 0.8,
                              height: 450,
                              child: AddReview(
                                id: widget.id!,
                                subject: widget.subject!,
                                content: widget.content!,
                                rate: widget.rate,
                              ),
                            ),
                          );
                        },
                      );
                      if (result == 'success') {
                        Navigator.of(context).pushReplacementNamed('/bab');
                      }
                    },
                    child: const Text(
                      "수정",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text(
                              "리뷰 삭제",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      sendData(widget.id!);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.grey[350]),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '확인',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.grey[350]),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '닫기',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            content: const SizedBox(
                              width: 200,
                              height: 70,
                              child: Center(
                                child: Text(
                                  "정말 삭제하시겠습니까?",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      "삭제",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                widget.content!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              RatingBar.builder(
                initialRating: widget.rate,
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
          ),
        ),
      ),
    );
  }

  Future<void> sendData(int reviewId) async {
    var uri = Uri.parse('$serverUrl/review/delete');
    var token = Service().getCurrentUserToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': await token,
    };

    var body = jsonEncode({
      'id': reviewId,
    });

    try {
      var response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Navigator.pushNamed(context, "/bab");
        Navigator.pop(context, 'deleted');
        // Navigator.pop(context, 'deleted');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("정상적으로 삭제되었습니다."),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        final errorMessage = response.body;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("삭제 실패"),
              content: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    "닫기",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("오류: $e");
    }
  }
}
