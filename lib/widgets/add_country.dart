import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nubida_front/main.dart';
import 'package:nubida_front/widgets/custom_text_field.dart';
import 'package:nubida_front/services/service.dart';

class AddCountry extends StatefulWidget {
  const AddCountry({
    super.key,
  });

  @override
  State<AddCountry> createState() => _AddCountryState();
}

class _AddCountryState extends State<AddCountry> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController countryName = TextEditingController();
  final TextEditingController moneyTerm = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendData() async {
    var uri = Uri.parse('$serverUrl/country/admin/create');
    final token = await Service().getCurrentUserToken();
    var body = jsonEncode({
      'name': countryName.text,
      'money_term': moneyTerm.text,
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("정상적으로 추가되었습니다."),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        final errorMessage = response.body;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("국가 추가 실패"),
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
      return "국가 이름은 공백이 될 수 없습니다.";
    }
    return null;
  }

  String? validateMoneyTerm(String? value) {
    if (value == null || value.isEmpty) {
      return "화폐단위는 공백이 될 수 없습니다.";
    } else if (value.length != 3) {
      return "화폐단위는 3자리 입니다.";
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
            controller: countryName,
            type: "국가 이름",
            validator: validateName,
          ),
          CustomTextFormField(
            controller: moneyTerm,
            type: "화폐 단위 ISO 4217코드",
            validator: validateMoneyTerm,
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
              "국가 추가",
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
