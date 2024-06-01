import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nubida_front/main.dart';
import 'package:nubida_front/services/service.dart';
import 'package:http/http.dart' as http;

class AdminTraveler extends StatefulWidget {
  final String name, email, role;
  const AdminTraveler({
    super.key,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  State<AdminTraveler> createState() => _AdminTravelerState();
}

class _AdminTravelerState extends State<AdminTraveler> {
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
        //       budgetWon: widget.budgetWon,
        //       startdate: widget.startdate,
        //       returndate: widget.returndate,
        //       countryName: countryName,
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
      child: SizedBox(
        width: screenWidth * 0.8,
        child: Column(
          children: [
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 2, child: Center(child: Text(widget.name))),
                Expanded(flex: 4, child: Center(child: Text(widget.email))),
                (widget.role == 'ROLE_ADMIN')
                    ? const Expanded(flex: 2, child: Center(child: Text('관리자')))
                    : const Expanded(
                        flex: 2, child: Center(child: Text("사용자"))),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () async {
                      var result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text(
                              "사용자 삭제",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      sendData();
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
                              height: 110,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "정말 삭제하시겠습니까?",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "해당 사용자와 관련된 모든 정보가 삭제됩니다.",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      if (result == 'deleted') {
                        Navigator.of(context).pushReplacementNamed('/bab');
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendData() async {
    var uri = Uri.parse('$serverUrl/traveler/delete');
    var token = Service().getCurrentUserToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': await token,
    };

    var body = jsonEncode({
      'nickname': widget.name,
      'username': widget.email,
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
