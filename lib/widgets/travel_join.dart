import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nubida_front/main.dart';
import 'package:nubida_front/widgets/custom_text_field.dart';
import 'package:nubida_front/services/service.dart';

class TravelJoin extends StatefulWidget {
  const TravelJoin({super.key});

  @override
  State<TravelJoin> createState() => _TravelJoinState();
}

class _TravelJoinState extends State<TravelJoin> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController code = TextEditingController();

  Future<void> sendData() async {
    var uri = Uri.parse('$serverUrl/travel/join');
    final token = await Service().getCurrentUserToken();

    var body = jsonEncode({
      'code': code.text,
    });

    try {
      var response = await http.post(uri,
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/bab");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("정상적으로 참가 되었습니다."),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        final errorMessage = response.body;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("여행 참가 실패"),
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

  String? validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return "코드는 공백이 들어갈 수 없습니다.";
    } else if (value.length != 6) {
      return "코드는 6자 입니다.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextFormField(
            controller: code,
            type: "Code",
            validator: validateCode,
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                sendData();
              }
            },
            child: const Text(
              "참가",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
