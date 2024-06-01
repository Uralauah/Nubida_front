import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nubida_front/main.dart';
import 'package:nubida_front/services/service.dart';

class ViewTravelTraveler extends StatefulWidget {
  final int travelId;
  final BigInt userId;
  const ViewTravelTraveler({
    super.key,
    required this.travelId,
    required this.userId,
  });

  @override
  State<ViewTravelTraveler> createState() => _ViewTravelTravelerState();
}

class _ViewTravelTravelerState extends State<ViewTravelTraveler> {
  Future<List<Map<String, dynamic>>>? travelerInfo;
  BigInt leader = BigInt.from(-1);

  @override
  void initState() {
    super.initState();
    travelerInfo = Service().getTravelTravelerInfo(widget.travelId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: travelerInfo,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.black,
          );
        }
        if (snapshot.hasError) {
          print('${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return Column(
            children: [
              Row(
                children: [
                  const Text(
                    "리더 : ",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${snapshot.data![0]['nickname']}',
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: snapshot.data!.isEmpty
                    ? const Text("데이터가 없습니다.")
                    : makeList(snapshot),
              ),
            ],
          );
        } else {
          return const Text('No data');
        }
      }),
    );
  }

  ListView makeList(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    // 데이터가 유효한지 확인
    if (!snapshot.hasData || snapshot.data == null) {
      return ListView(children: const [Text('No data available')]);
    }

    // ListView 생성
    return ListView.separated(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const SizedBox.shrink();
        }
        print(snapshot.data!);
        String nickname = snapshot.data![index]['nickname'];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '$index : $nickname',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
            (BigInt.from(snapshot.data![0]['id']) == widget.userId)
                ? IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text(
                              "여행자 삭제",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      sendData(widget.travelId,
                                          snapshot.data![index]['id']);
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
                    icon: const Icon(Icons.delete),
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: snapshot.data!.length, // 여행자 리스트의 길이를 itemCount로 설정
    );
  }

  Future<void> sendData(int travelId, int travelTravelerId) async {
    var uri = Uri.parse('$serverUrl/travel/deleteTraveler');
    var token = Service().getCurrentUserToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': await token,
    };

    var body = jsonEncode({
      'travel_id': travelId,
      'travel_traveler_id': travelTravelerId,
    });

    try {
      var response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Navigator.pushNamed(context, "/bab");
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
}
