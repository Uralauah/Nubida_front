import 'package:flutter/material.dart';
import 'package:nubida_front/main.dart';
import 'package:nubida_front/widgets/custom_text_field.dart';
import 'package:nubida_front/widgets/validate_email.dart';
import 'package:nubida_front/widgets/validate_password.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  static const storage = FlutterSecureStorage();
  String nickname = '';
  String role = '';

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> sendData() async {
    var uri = Uri.parse('$serverUrl/login');
    var request = http.MultipartRequest('POST', uri)
      ..fields['username'] = email.text
      ..fields['password'] = password.text;

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var token = response.headers['authorization'];

        if (token != null) {
          Map<String, dynamic> payload = Jwt.parseJwt(token);
          nickname = payload['nickname'];
          role = payload['role'];
          await storage.write(key: 'jwt_token', value: token);
          await storage.write(key: 'username', value: nickname);
          await storage.write(key: 'role', value: role);

          Navigator.pushNamed(context, "/bab");
        }
      } else {
        print("실패 ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("로그인 실패"),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      print("오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("서버와 통신할 수 없습니다"), duration: Duration(seconds: 4)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.2),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Image.asset("image/nubida_logo.png",
                      width: screenWidth * 0.7, height: screenHeight * 0.25),
                  const SizedBox(height: 50),
                  CustomTextFormField(
                    controller: email,
                    type: "이메일",
                    validator: validateEmail,
                  ),
                  CustomTextFormField(
                    controller: password,
                    type: "비밀번호",
                    validator: validatePassword,
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
                          "로그인",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/register");
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
