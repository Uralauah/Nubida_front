import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:nubida_front/services/service.dart';

import 'package:nubida_front/widgets/custom_text_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TravelCreate extends StatefulWidget {
  const TravelCreate({super.key});

  @override
  State<TravelCreate> createState() => _TravelCreateState();
}

class _TravelCreateState extends State<TravelCreate> {
  final formKey = GlobalKey<FormState>();
  Future<List<String>> countries = Service().getCountryNames();
  String? selectedCountry;
  DateTime startdate = DateTime.now(), returndate = DateTime.now();
  final TextEditingController travelName = TextEditingController();
  final TextEditingController budget = TextEditingController();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "이름은 공백이 될 수 없습니다.";
    } else if (value.length >= 15) {
      return "이름은 15자 이하로 작성해야 합니다.";
    }
    return null;
  }

  String? validateBudget(String? value) {
    if (value == null || value.isEmpty) {
      return "예산은 공백이 될 수 없습니다.";
    } else if (int.parse(value) < 0) {
      return "예산은 양수로 입력해야 합니다.";
    }
    return null;
  }

  Future<void> sendData() async {
    var uri = Uri.parse('http://localhost:8080/travel/create');
    final token = Service().getCurrentUserToken();

    var body = jsonEncode({
      'name': travelName.text,
      'startDate': startdate.toIso8601String(),
      'returnDate': returndate.toIso8601String(),
      'budget_won': budget.text,
      'country': selectedCountry,
    });

    try {
      var response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': await token
          },
          body: body);
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/bab");
      } else {
        final errorMessage = response.body;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("여행 생성 실패"),
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
    return DefaultTabController(
      length: 1,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed('/bab');
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              '여행 생성',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              right: 40,
              left: 40,
              bottom: 300,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomTextFormField(
                    type: "이름",
                    validator: validateName,
                    controller: travelName,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        '목적지 ',
                        style: TextStyle(fontSize: 20),
                      ),
                      FutureBuilder<List<String>>(
                        future: Service().getCountryNames(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                                color: Colors.black);
                          } else if (snapshot.hasData) {
                            return SizedBox(
                              width: 170,
                              child: DropdownButton(
                                isExpanded: true,
                                value: selectedCountry,
                                hint: const Text('Select Country'),
                                items: snapshot.data!
                                    .map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
                                onChanged: (String? newValue) {
                                  setState(
                                    () {
                                      selectedCountry = newValue;
                                    },
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Text('No data');
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        '출발일 ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => startdatePicker(context),
                        child: Text(
                          '${startdate.year.toString()}-${startdate.month.toString().padLeft(2, '0')}-${startdate.day.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        '도착일 ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => returndatePicker(context),
                        child: Text(
                          '${returndate.year.toString()}-${returndate.month.toString().padLeft(2, '0')}-${(returndate.day).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomTextFormField(
                    type: "예산",
                    validator: validateBudget,
                    controller: budget,
                  ),
                  TextButton(
                    child: const Text(
                      '여행 생성',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        sendData();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> startdatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: DatePickerDialog(
            helpText: '출발일 선택',
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
          ),
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        startdate = pickedDate;
        if (returndate.isBefore(startdate)) {
          returndate = startdate;
        }
      });
    }
  }

  Future<void> returndatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: DatePickerDialog(
            helpText: '도착일 선택',
            initialDate:
                returndate.isBefore(startdate) ? startdate : returndate,
            firstDate: startdate,
            lastDate: DateTime(2100),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
          ),
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        returndate = pickedDate;
      });
    }
  }
}
