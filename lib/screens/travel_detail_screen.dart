import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:nubida_front/main.dart';

import 'package:nubida_front/models/plan_model.dart';
import 'package:nubida_front/widgets/add_plan.dart';
import 'package:nubida_front/services/service.dart';
import 'package:nubida_front/widgets/add_transportation_widget.dart';
import 'package:nubida_front/widgets/currency.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nubida_front/widgets/view_budget_info.dart';
import 'package:nubida_front/widgets/view_supply.dart';
import 'package:nubida_front/widgets/view_travel_traveler.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class TravelDetail extends StatefulWidget {
  final String name, countryName, moneyTerm;
  final int id, budgetWon, remainBudget, leader;
  final DateTime startdate, returndate;
  const TravelDetail({
    Key? key,
    required this.remainBudget,
    required this.name,
    required this.id,
    required this.budgetWon,
    required this.returndate,
    required this.startdate,
    required this.countryName,
    required this.moneyTerm,
    required this.leader,
  }) : super(key: key);

  @override
  State<TravelDetail> createState() => _TravelDetailState();
}

class _TravelDetailState extends State<TravelDetail> {
  String code = '';
  String budget = '0';
  String currencyCode = '';
  double currencyPrice = 0.0;
  int currencyUnit = 0, numTraveler = 0, curBudget = 0;

  BigInt userId = BigInt.from(-1);

  @override
  void initState() {
    super.initState();
    getInfo(widget.id);
    getCurrencyPrice();
    getId();
    loadPlans();
  }

  void refreshTravelDetails() {
    getInfo(widget.id);
    getCurrencyPrice();
    getId();
    loadPlans();
  }

  void loadPlans() async {
    plans = await Service().getPlan(widget.id);
  }

  List<PlanModel> plans = [];

  List<PlanModel> getPlansForDate(DateTime date) {
    return plans.where((plan) {
      return plan.start_date.day == date.day &&
          plan.start_date.month == date.month &&
          plan.start_date.year == date.year;
    }).toList();
  }

  Future<void> getCurrencyPrice() async {
    Uri url = Uri.parse(
        'https://quotation-api-cdn.dunamu.com/v1/forex/recent?codes=FRX.KRW${widget.moneyTerm}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        currencyPrice = result[0]['highPrice'];
        currencyUnit = result[0]['currencyUnit'];
      });
    }
  }

  Future<void> getId() async {
    var result = await Service().getTravelerId();
    setState(() {
      userId = result;
    });
  }

  Future<void> getInfo(id) async {
    var result = await Service().getTravelInfo(id);
    print(result);
    setState(() {
      code = result['code'];
      curBudget = result['remain_budget'];
      budget = NumberFormat('#,##0', 'en_US').format(curBudget);
      currencyCode = 'KRW';
      numTraveler = result['num_traveler'];
    });
  }

  void changeBudget() {
    setState(
      () {
        if (budget != NumberFormat('#,##0', 'en_US').format(curBudget)) {
          budget = NumberFormat('#,##0', 'en_US').format(curBudget);
          currencyCode = 'KRW';
        } else {
          var temp = (curBudget / currencyPrice * currencyUnit);
          budget = NumberFormat('#,##0.00', 'en_US').format(temp);
          currencyCode = widget.moneyTerm;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    int daysBetween =
        widget.returndate.difference(widget.startdate).inDays + 1; // 종료일 포함 계산
    List<DateTime> daysList = List.generate(daysBetween, (index) {
      return widget.startdate.add(Duration(days: index));
    });

    return DefaultTabController(
      length: 1,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed('/bab');
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 30,
            ),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "목적지 :",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        widget.countryName,
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      (userId != BigInt.from(widget.leader))
                          ? TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: const Text(
                                        "여행 탈퇴",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                travelQuit(widget.id);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.grey[350]),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                                    MaterialStatePropertyAll(
                                                        Colors.grey[350]),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                            "정말 탈퇴하시겠습니까?",
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
                              child: const Text(
                                "여행 탈퇴",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: const Text(
                                        "여행 삭제",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                sendData(widget.id);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.grey[350]),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                                    MaterialStatePropertyAll(
                                                        Colors.grey[350]),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                              child: const Text(
                                "여행 삭제",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        (widget.startdate).toString().split(" ").first,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                      ('${widget.startdate.difference(widget.returndate).inDays.toString().substring(1)}일'),
                      style: const TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        (widget.returndate).toString().split(" ").first,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "동행자 :",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "여행자 조회",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                actions: <Widget>[
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
                                content: SizedBox(
                                  height: 308,
                                  width: 400,
                                  child: ViewTravelTraveler(
                                    travelId: widget.id,
                                    userId: userId,
                                  ),
                                ),
                              );
                            },
                          );
                          if (result == 'deleted') {
                            refreshTravelDetails();
                          }
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
                        child: Text(
                          '$numTraveler명',
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "초대 코드",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                actions: <Widget>[
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
                                content: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          code,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Clipboard.setData(
                                                ClipboardData(text: code));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text("코드가 복사되었습니다."),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.copy),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
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
                        child: const Text(
                          "초대 코드",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        const Text(
                          '예산 : ',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        TextButton(
                          onPressed: changeBudget,
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth * 0.3,
                                child: AutoSizeText(
                                  budget,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                  ),
                                  minFontSize: 10,
                                  maxLines: 1,
                                ),
                              ),
                              Text(
                                currencyCode,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text(
                                    "환율 조회",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
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
                                  content: SizedBox(
                                    height: 180,
                                    width: 200,
                                    child: Currency(
                                      currencyCode: widget.moneyTerm,
                                    ),
                                  ),
                                );
                              },
                            );
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
                          child: const Text(
                            "환율 확인",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.grey[350]),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "예산 정보",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                actions: <Widget>[
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
                                content: SizedBox(
                                  width: screenWidth * 0.9,
                                  height: screenHeight * 0.45,
                                  child: ViewBudgetInfo(
                                    budgetWon: widget.budgetWon,
                                    remainBudget: curBudget,
                                    id: widget.id,
                                  ),
                                ),
                              );
                            },
                          );
                          if (result == 'success') {
                            refreshTravelDetails();
                          }
                        },
                        child: const Text(
                          "예산 정보",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.grey[350]),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "준비물 정보",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                actions: <Widget>[
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
                                content: SizedBox(
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.45,
                                  child: ViewSupplies(id: widget.id),
                                ),
                              );
                            },
                          );
                          if (result == 'success') {
                            refreshTravelDetails();
                          }
                        },
                        child: const Text(
                          "준비물 정보",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.grey[350]),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "계획 추가",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                actions: <Widget>[
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
                                content: SizedBox(
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.45,
                                  child: AddPlan(
                                    start_date: widget.startdate,
                                    return_date: widget.returndate,
                                    travel_id: widget.id,
                                  ),
                                ),
                              );
                            },
                          );
                          if (result == 'success') {
                            refreshTravelDetails();
                          }
                        },
                        child: const Text(
                          "계획 추가",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.grey[350]),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "이동수단 추가",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                actions: <Widget>[
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
                                content: SizedBox(
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.45,
                                  child: AddTransport(
                                    start_date: widget.startdate,
                                    return_date: widget.returndate,
                                    travel_id: widget.id,
                                  ),
                                ),
                              );
                            },
                          );
                          if (result == 'success') {
                            refreshTravelDetails();
                          }
                        },
                        child: const Text(
                          "이동수단 추가",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: daysList.length,
                      itemBuilder: ((context, index) {
                        var day = daysList[index];
                        var dailyPlans = getPlansForDate(day);
                        return ExpansionTile(
                          title: Text(
                            DateFormat('yyyy-MM-dd').format(day),
                          ),
                          children: dailyPlans
                              .map(
                                (plan) => ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(plan.name),
                                      TextButton(
                                        onPressed: () async {
                                          var result = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                title: const Text(
                                                  "계획 삭제",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          deletePlan(plan.id);
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors.grey[
                                                                      350]),
                                                          shape:
                                                              MaterialStateProperty
                                                                  .all(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            '확인',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors.grey[
                                                                      350]),
                                                          shape:
                                                              MaterialStateProperty
                                                                  .all(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            '닫기',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          if (result == 'deleted') {
                                            refreshTravelDetails();
                                          }
                                        },
                                        child: const Text(
                                          "계획 삭제",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Cost: ${plan.cost}'),
                                      Text(
                                          '${plan.start_date.hour}:${plan.start_date.minute} - ${plan.finish_date.hour}:${plan.finish_date.minute}')
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }),
                    ),
                  ),
                  // Text('${widget.numTraveler}'),
                  // Text('${widget.startdate}-${widget.returndate}'),
                  // Text(code),
                  // Text('${widget.budgetWon}'),
                  // Text('${widget.id}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> travelQuit(int travelId) async {
    var uri = Uri.parse('$serverUrl/travel/quit?id=$travelId');
    var token = Service().getCurrentUserToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': await token,
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/bab");
        // Navigator.pop(context, 'deleted');
        // Navigator.pop(context, 'deleted');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("정상적으로 탈퇴되었습니다."),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        final errorMessage = response.body;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("탈퇴 실패"),
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

  Future<void> sendData(int travelId) async {
    var uri = Uri.parse('$serverUrl/travel/delete?id=$travelId');
    var token = Service().getCurrentUserToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': await token,
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/bab");
        // Navigator.pop(context, 'deleted');
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

  Future<void> deletePlan(int planId) async {
    var uri = Uri.parse('$serverUrl/plan/delete?plan_id=$planId');
    var token = Service().getCurrentUserToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': await token,
    };

    try {
      var response = await http.post(uri, headers: headers);

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
