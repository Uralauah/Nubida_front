import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nubida_front/main.dart';
import 'package:nubida_front/widgets/custom_text_field.dart';
import 'package:nubida_front/services/service.dart';

class AddSupply extends StatefulWidget {
  final int travel_id;
  const AddSupply({
    super.key,
    required this.travel_id,
  });

  @override
  State<AddSupply> createState() => _AddSupplyState();
}

class _AddSupplyState extends State<AddSupply> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController count = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendData() async {
    var uri = Uri.parse('$serverUrl/supply/create?id=${widget.travel_id}');
    final token = await Service().getCurrentUserToken();

    var body = jsonEncode({
      'name': name.text,
      'count': count.text,
      'check': 'false',
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
              title: const Text("준비물 추가 실패"),
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

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "준비물 이름은 공백이 될 수 없습니다.";
    } else if (value.length > 10) {
      return "준비물 이름은 10자 이내로 작성해야 합니다.";
    }
    return null;
  }

  String? validateCount(String? value) {
    if (value == null || value.isEmpty) {
      return "개수는 공백이 될 수 없습니다.";
    } else if (int.parse(value) < 0) {
      return "개수는 음수가 될 수 없습니다.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomTextFormField(
            controller: name,
            type: "준비물 이름",
            validator: validateName,
          ),
          CustomTextFormField(
            controller: count,
            type: "개수",
            validator: validateCount,
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                sendData();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.grey[350]),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: const Text(
              "준비물 추가",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
