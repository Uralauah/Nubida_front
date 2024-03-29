import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nubida_front/widgets/custom_text_field.dart';
import 'package:nubida_front/widgets/validate_email.dart';
import 'package:nubida_front/widgets/validate_password.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  Future<void> sendData() async {
    var uri = Uri.parse('http://localhost:8080/login');
    var request = http.MultipartRequest('POST', uri)
      ..fields['username'] = email.text
      ..fields['password'] = password.text;

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/bab");
      } else {
        print("실패 ${response.statusCode}");
      }
    } catch (e) {
      print("오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Image.asset("image/nubida_logo.png", width: 250, height: 250),
                  const SizedBox(height: 50),
                  CustomTextFormField(
                    controller: email,
                    type: "Email",
                    validator: validateEmail,
                  ),
                  CustomTextFormField(
                    controller: password,
                    type: "Password",
                    validator: validatePassword,
                  ),
                  TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        sendData();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
