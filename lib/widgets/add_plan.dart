import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nubida_front/class/time_picker_spinner_pop_up.dart';
import 'package:nubida_front/widgets/custom_text_field.dart';
import 'package:nubida_front/services/service.dart';

class AddPlan extends StatefulWidget {
  final DateTime start_date, return_date;
  final int travel_id;
  const AddPlan({
    super.key,
    required this.travel_id,
    required this.start_date,
    required this.return_date,
  });

  @override
  State<AddPlan> createState() => _AddPlanState();
}

class _AddPlanState extends State<AddPlan> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController planName = TextEditingController();
  final TextEditingController planCost = TextEditingController();

  DateTime planStartDate = DateTime.now(),
      planFinDate = DateTime.now(),
      planStartTime = DateTime.now(),
      planFinTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    planStartDate = widget.start_date;
    planFinDate = widget.return_date;
  }

  Future<void> sendData() async {
    var uri = Uri.parse(
        'http://localhost:8080/plan/addPlan?travel_id=${widget.travel_id}');
    final token = await Service().getCurrentUserToken();
    planStartDate = DateTime(planStartDate.year, planStartDate.month,
        planStartDate.day, planStartTime.hour, planStartTime.minute);
    planFinDate = DateTime(planFinDate.year, planFinDate.month, planFinDate.day,
        planFinTime.hour, planFinTime.minute);

    var body = jsonEncode({
      'plan_name': planName.text,
      'plan_cost': planCost.text,
      'start_date': planStartDate.toIso8601String(),
      'finish_date': planFinDate.toIso8601String(),
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
              title: const Text("계획 추가 실패"),
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
      return "계획 이름은 공백이 될 수 없습니다.";
    } else if (value.length > 10) {
      return "계획 이름은 10자 이내로 작성해야 합니다.";
    }
    return null;
  }

  String? validateCost(String? value) {
    if (value == null || value.isEmpty) {
      return "비용은 공백이 될 수 없습니다.";
    } else if (int.parse(value) < 0) {
      return "비용은 음수가 될 수 없습니다.";
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
            controller: planName,
            type: "계획 이름",
            validator: validateName,
          ),
          CustomTextFormField(
            controller: planCost,
            type: "비용",
            validator: validateCost,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "시작",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TimePickerSpinnerPopUp(
                mode: CupertinoDatePickerMode.date,
                initTime: planStartDate,
                minTime: widget.start_date,
                maxTime: widget.return_date,
                barrierColor: Colors.black12, //Barrier Color when pop up show
                minuteInterval: 1,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                cancelText: '취소',
                confirmText: '확인',
                pressType: PressType.singlePress,
                timeFormat: 'yyyy/MM/dd',
                onChange: (dateTime) {
                  setState(() {
                    planStartDate = dateTime;
                  });
                },
              ),
              TimePickerSpinnerPopUp(
                mode: CupertinoDatePickerMode.time,
                initTime: DateTime.now(),
                onChange: (dateTime) {
                  planStartTime = dateTime;
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "종료",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TimePickerSpinnerPopUp(
                mode: CupertinoDatePickerMode.date,
                initTime: planStartDate,
                minTime: planStartDate,
                maxTime: widget.return_date,
                barrierColor: Colors.black12, //Barrier Color when pop up show
                minuteInterval: 1,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                cancelText: '취소',
                confirmText: '확인',
                pressType: PressType.singlePress,
                timeFormat: 'yyyy/MM/dd',
                onChange: (dateTime) {
                  planFinDate = dateTime;
                },
              ),
              TimePickerSpinnerPopUp(
                mode: CupertinoDatePickerMode.time,
                initTime: DateTime.now(),
                onChange: (dateTime) {
                  planFinTime = dateTime;
                },
              ),
            ],
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
              "계획 추가",
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
