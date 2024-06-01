import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:nubida_front/services/service.dart';

class AdminTravel extends StatefulWidget {
  final String name;
  final int budgetWon, numTraveler, id, countryId, remainBudget;
  final DateTime startdate, returndate;
  const AdminTravel({
    super.key,
    required this.name,
    required this.budgetWon,
    required this.numTraveler,
    required this.id,
    required this.countryId,
    required this.startdate,
    required this.returndate,
    required this.remainBudget,
  });

  @override
  State<AdminTravel> createState() => _AdminTravelState();
}

class _AdminTravelState extends State<AdminTravel> {
  DateTime now = DateTime.now();
  String countryName = '';
  String leader = '';

  @override
  void initState() {
    super.initState();
    initCountryName();
  }

  Future<void> initCountryName() async {
    var name = await Service().getCountry(widget.countryId);
    var result = await Service().getTravelTravelerInfo(widget.id);
    setState(() {
      countryName = name;
      leader = result[0]['nickname'];
    });
  }

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
      child: Container(
          width: screenWidth * 0.8,
          height: 200,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.4,
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AutoSizeText(
                        '이름 : ${widget.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        minFontSize: 10,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '리더 : $leader',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '목적지 : $countryName',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                      width: screenWidth * 0.4,
                      child: Column(
                        children: [
                          AutoSizeText(
                            '전체예산 : ${widget.budgetWon}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 10,
                            maxLines: 1,
                          ),
                          AutoSizeText(
                            '잔여예산 : ${widget.remainBudget}',
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
                      width: screenWidth * 0.4,
                      child: Column(
                        children: [
                          Text(
                            '참여인원 : ${widget.numTraveler}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                        '출발일 : ${widget.startdate.year}-${widget.startdate.month}-${widget.startdate.day}'),
                    Text(
                        '도착일 : ${widget.returndate.year}-${widget.returndate.month}-${widget.returndate.day}'),
                    (widget.startdate.isBefore(now))
                        ? (widget.returndate.isAfter(now))
                            ? const AutoSizeText(
                                '여행 중',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                                minFontSize: 10,
                                maxLines: 1,
                              )
                            : const AutoSizeText(
                                '여행 종료',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                                minFontSize: 10,
                                maxLines: 1,
                              )
                        : AutoSizeText(
                            'D-${now.difference(widget.startdate).inDays + 1}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 10,
                            maxLines: 1,
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
