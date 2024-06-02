import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nubida_front/main.dart';
import 'package:nubida_front/services/service.dart';
import 'package:http/http.dart' as http;

class Supply extends StatefulWidget {
  final String name;
  final int count, id;
  final bool check;
  const Supply({
    super.key,
    required this.check,
    required this.count,
    required this.id,
    required this.name,
  });

  @override
  State<Supply> createState() => _SupplyState();
}

class _SupplyState extends State<Supply> {
  var checked = false;
  var count = 0;

  @override
  void initState() {
    super.initState();
    checked = widget.check;
    count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text(
                        "준비물 삭제",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                deleteSupply(widget.id, widget.name);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.grey[350]),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.grey[350]),
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
              icon: const Icon(Icons.delete)),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(widget.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    sendCountData(widget.id, -1, widget.name);
                    setState(() {
                      count -= 1;
                    });
                  },
                  child: const Icon(
                    Icons.remove,
                    size: 15,
                  ),
                ),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    sendCountData(widget.id, 1, widget.name);
                    setState(() {
                      count += 1;
                    });
                  },
                  child: const Icon(
                    Icons.add,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Checkbox(
                value: (checked == false) ? false : true,
                activeColor: Colors.black,
                onChanged: (value) {
                  setState(() {
                    checked = !checked;
                    sendData(checked, widget.name);
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> sendData(bool check, String supplyName) async {
    var uri = Uri.parse('$serverUrl/supply/check');
    var token = Service().getCurrentUserToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': await token,
    };

    var body = jsonEncode({
      // 'travel_id': travelId,
      'name': supplyName,
      'check': check,
    });

    try {
      var response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
      } else {
        final errorMessage = response.body;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("수정 실패"),
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

  Future<void> deleteSupply(int travelId, String supplyName) async {
    var uri = Uri.parse('$serverUrl/supply/delete?id=$travelId');
    var token = Service().getCurrentUserToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': await token,
    };

    var body = jsonEncode({
      'name': supplyName,
    });

    try {
      var response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        Navigator.pop(context, 'deleted');
        Navigator.pop(context, 'deleted');
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

  Future<void> sendCountData(
      int travelId, int countChange, String supplyName) async {
    var uri = Uri.parse('$serverUrl/supply/count');
    var token = Service().getCurrentUserToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': await token,
    };

    var body = jsonEncode({
      // 'travel_id': travelId,
      'name': supplyName,
      'count': countChange,
    });

    try {
      var response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
      } else {
        final errorMessage = response.body;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("수정 실패"),
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
