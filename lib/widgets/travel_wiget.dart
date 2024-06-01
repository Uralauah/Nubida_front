import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nubida_front/screens/travel_detail_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:nubida_front/services/service.dart';
import 'package:nubida_front/widgets/add_review.dart';
import 'package:nubida_front/widgets/view_review.dart';

class Travel extends StatefulWidget {
  final String name, moneyTerm;
  final int budgetWon, numTraveler, id, countryId, remainBudget, leader;
  final DateTime startdate, returndate;
  final bool review;
  const Travel({
    super.key,
    required this.name,
    required this.budgetWon,
    required this.numTraveler,
    required this.id,
    required this.countryId,
    required this.startdate,
    required this.leader,
    required this.returndate,
    required this.moneyTerm,
    required this.remainBudget,
    required this.review,
  });

  @override
  State<Travel> createState() => _TravelState();
}

class _TravelState extends State<Travel> {
  DateTime now = DateTime.now();
  String countryName = '';

  @override
  void initState() {
    super.initState();
    initCountryName();
  }

  Future<void> initCountryName() async {
    var name = await Service().getCountry(widget.countryId);
    setState(() {
      countryName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String travelStatus;

    if (now.isBefore(widget.startdate)) {
      travelStatus = 'D-${widget.startdate.difference(now).inDays + 1}';
    } else if (now.isAfter(widget.returndate)) {
      travelStatus = '여행 종료';
    } else {
      travelStatus = '여행 중';
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TravelDetail(
              name: widget.name,
              id: widget.id,
              leader: widget.leader,
              budgetWon: widget.budgetWon,
              startdate: widget.startdate,
              returndate: widget.returndate,
              countryName: countryName,
              moneyTerm: widget.moneyTerm,
              remainBudget: widget.remainBudget,
            ),
            settings: RouteSettings(
              arguments: {
                'name': widget.name,
                'budgetWon': widget.budgetWon,
                'id': widget.id,
                'countryName': countryName,
                'moneyTerm': widget.moneyTerm,
              },
            ),
          ),
        );
      },
      child: Container(
          width: screenWidth * 0.8,
          height: 200,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: const Offset(-5, 5),
                color: Colors.black.withOpacity(0.4),
              )
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AutoSizeText(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        minFontSize: 20,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.flight_takeoff_outlined, size: 45),
                          const SizedBox(width: 18),
                          Text(
                            countryName,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: VerticalDivider(thickness: 1, color: Colors.black),
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.29,
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "예산",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          AutoSizeText(
                            '${widget.budgetWon}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.29,
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 15),
                              Text(
                                "동행자 수",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${widget.numTraveler}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.29,
                      child: Center(
                        child: (travelStatus == '여행 종료')
                            ? (widget.review)
                                ? TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: const Text(
                                              "리뷰 정보",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
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
                                            content: SingleChildScrollView(
                                              child: SizedBox(
                                                width: screenWidth * 0.8,
                                                height: 300,
                                                child: ViewReview(
                                                  id: widget.id,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const AutoSizeText(
                                      "리뷰 작성 완료",
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                      minFontSize: 15,
                                      maxLines: 1,
                                    ),
                                  )
                                : TextButton(
                                    onPressed: () async {
                                      var result = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: const Text(
                                              "리뷰 등록",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
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
                                            content: SingleChildScrollView(
                                              child: SizedBox(
                                                width: screenWidth * 0.8,
                                                height: 450,
                                                child: AddReview(
                                                  id: widget.id,
                                                  subject: "",
                                                  content: "",
                                                  rate: 3,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      if (result == 'success') {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/bab');
                                      }
                                    },
                                    child: AutoSizeText(
                                      travelStatus,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                      minFontSize: 20,
                                      maxLines: 1,
                                    ),
                                  )
                            : AutoSizeText(
                                travelStatus,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                                minFontSize: 20,
                                maxLines: 1,
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       name,
          //       style: const TextStyle(
          //         fontSize: 30,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     const Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 20),
          //       child: Divider(
          //         thickness: 1,
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 25),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             "남은 예산 : $budgetWon",
          //             style: const TextStyle(
          //               fontSize: 17,
          //               fontWeight: FontWeight.w400,
          //             ),
          //           ),
          //           Text(
          //             "현재 동행자 : $numTraveler",
          //             style: const TextStyle(
          //               fontSize: 15,
          //               fontWeight: FontWeight.w300,
          //             ),
          //           ),
          //         ],
          //       ),
          //     )
          //   ],
          // ),
          ),
    );
  }
}
