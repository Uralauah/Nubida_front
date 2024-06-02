import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:nubida_front/main.dart';
import 'package:nubida_front/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReview extends StatefulWidget {
  final int id;
  final String subject, content;
  final double rate;
  const AddReview({
    super.key,
    required this.id,
    required this.subject,
    required this.content,
    required this.rate,
  });

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController reviewSubject = TextEditingController();
  final TextEditingController reviewContent = TextEditingController();
  var rate = 0.0;

  @override
  void initState() {
    super.initState();
    reviewSubject.text = widget.subject;
    reviewContent.text = widget.content;
    rate = widget.rate;
  }

  Future<void> sendData() async {
    var uri = Uri.parse('$serverUrl/review/addReview?id=${widget.id}');
    final token = await Service().getCurrentUserToken();

    var body = jsonEncode({
      'subject': reviewSubject.text,
      'content': reviewContent.text,
      'rate': rate,
    });

    try {
      var response = await http.post(uri,
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('reviewed_${widget.id}', true);
        Navigator.pop(context, 'success');
      } else {
        final errorMessage = response.body;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("리뷰 등록 실패"),
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

  Future<void> sendChange() async {
    var uri = Uri.parse('$serverUrl/review/change');
    final token = await Service().getCurrentUserToken();

    var body = jsonEncode({
      'id': widget.id,
      'subject': reviewSubject.text,
      'content': reviewContent.text,
      'rate': rate,
    });

    try {
      var response = await http.post(uri,
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('reviewed_${widget.id}', true);
        Navigator.pop(context, 'success');
      } else {
        final errorMessage = response.body;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("리뷰 등록 실패"),
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

  String? validateSubject(String? value) {
    if (value == null || value.isEmpty) {
      return "리뷰 제목은 공백이 될 수 없습니다.";
    } else if (value.length > 20) {
      return "리뷰 제목은 20자 이내로 작성해야 합니다.";
    }
    return null;
  }

  String? validateContent(String? value) {
    if (value == null || value.isEmpty) {
      return "내용은 공백이 될 수 없습니다.";
    } else if (value.length > 500) {
      return "내용은 500자 이내로 작성해야 합니다.";
    } else if (value.length < 10) {
      return "내용은 10자 이상 작성해야 합니다.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            validator: validateSubject,
            controller: reviewSubject,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: '리뷰 제목 입력',
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            validator: validateContent,
            controller: reviewContent,
            maxLines: 8,
            decoration: InputDecoration(
              labelText: '리뷰 내용 입력',
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          RatingBar.builder(
            initialRating: rate,
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
              print(rating);
              setState(() {
                rate = rating;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                (widget.subject != "" && widget.content != "")
                    ? sendChange()
                    : sendData();
              }
            },
            child: (widget.subject != "" && widget.content != "")
                ? const Text("리뷰 수정")
                : const Text('리뷰 추가'),
          ),
        ],
      ),
    );
  }
}
