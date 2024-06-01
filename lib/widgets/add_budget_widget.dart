import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nubida_front/main.dart';
import 'package:nubida_front/widgets/custom_text_field.dart';
import 'package:nubida_front/services/service.dart';

class AddBudget extends StatefulWidget {
  final int id;
  const AddBudget({
    super.key,
    required this.id,
  });

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController budget = TextEditingController();
  var rate = 0.0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendData() async {
    var uri = Uri.parse('$serverUrl/travel/budget?id=${widget.id}');

    final token = await Service().getCurrentUserToken();

    var body = jsonEncode({
      'budget': budget.text,
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
        Navigator.pop(context, 'success');
      } else {
        final errorMessage = response.body;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("예산 추가 실패"),
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

  String? validateBudget(String? value) {
    if (value == null || value.isEmpty) {
      return "예산은 공백이 될 수 없습니다.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: budget,
            type: "예산 입력",
            validator: validateBudget,
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                sendData();
              }
            },
            child: const Text('예산 추가'),
          ),
        ],
      ),
    );
  }
}
