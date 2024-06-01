import 'package:flutter/material.dart';
import 'package:nubida_front/main.dart';
import 'package:nubida_front/widgets/custom_text_field.dart';
import 'package:nubida_front/widgets/validate_email.dart';
import 'package:nubida_front/widgets/validate_password.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordConfirm = TextEditingController();

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "패스워드 확인은 공백이 들어갈 수 없습니다.";
    } else if (value != password.text) {
      return "패스워드가 일치하지 않습니다.";
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "유저네임은 공백이 들어갈 수 없습니다.";
    }
    return null;
  }

  Future<void> sendData() async {
    var uri = Uri.parse('$serverUrl/traveler/register');
    var headers = {
      'Content-Type': 'application/json',
    };

    var body = jsonEncode({
      'username': email.text,
      'nickname': username.text,
      'password': password.text,
    });

    try {
      var response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/login");
      } else {
        final errorMessage = response.body;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("회원가입 실패"),
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("회원가입")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
          ),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: username,
                    type: "닉네임",
                    validator: validateUsername,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  CustomTextFormField(
                    controller: email,
                    type: "이메일",
                    validator: validateEmail,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  CustomTextFormField(
                    controller: password,
                    type: "비밀번호",
                    validator: validatePassword,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  CustomTextFormField(
                    controller: passwordConfirm,
                    type: "비밀번호 확인",
                    validator: validateConfirmPassword,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            sendData();
                          }
                        },
                        child: const Text(
                          "회원가입",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
