import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nubida_front/models/travel_model.dart';
import 'package:nubida_front/services/service.dart';
import 'package:nubida_front/widgets/travel_join.dart';
import 'package:nubida_front/widgets/travel_wiget.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  String username = "";
  String userrole = '';

  Future<String> getCurrentUser() async {
    const storage = FlutterSecureStorage();
    String? nickname = await storage.read(key: 'username');
    if (nickname != null) {
      return nickname;
    } else {
      return '';
    }
  }

  Future<String> getCurrentUserRole() async {
    const storage = FlutterSecureStorage();
    String? role = await storage.read(key: 'role');
    if (role != null) {
      return role;
    } else {
      return '';
    }
  }

  Future<void> logout(BuildContext context) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'page');
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void initState() {
    super.initState();
    initUser();
  }

  Future<List<TravelModel>>? travels = Service().getTravel();

  Future<void> initUser() async {
    String curUser = await getCurrentUser();
    String curRole = await getCurrentUserRole();

    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: 'page');
    await storage.write(key: 'page', value: '1');

    setState(() {
      username = curUser;
      userrole = curRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 1,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed('/bab');
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(
              top: 80,
              left: 20,
              right: 20,
            ),
            child: FutureBuilder(
              future: travels,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.66,
                            child: TextButton(
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.transparent;
                                    }
                                    return Colors.transparent;
                                  },
                                ),
                              ),
                              onPressed: userrole != 'ROLE_ADMIN'
                                  ? () {}
                                  : () {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/adminpage');
                                    },
                              child: AutoSizeText(
                                "$username님, 어디로 떠날까요?",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                minFontSize: 10,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await logout(context);
                            },
                            child: const Text(
                              'logout',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Color.fromARGB(44, 0, 0, 0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/createTravel');
                            },
                            child: const Text(
                              "새로운 여행을 시작하세요",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      "여행 참가",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    content: SizedBox(
                                      height: 180,
                                      width: 240,
                                      child: TravelJoin(),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              '여행 참가',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, "/allReview");
                            },
                            child: const Text(
                              "리뷰 목록",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, "/allTravel");
                            },
                            child: const Text(
                              "모든 여행 목록",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: snapshot.data!.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.luggage_outlined,
                                      size: 90,
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "여행이 없어요",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                '/createTravel');
                                      },
                                      child: const Text(
                                        "새로운 여행을 시작하세요",
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 60, 60, 60),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ShaderMask(
                                shaderCallback: (Rect rect) {
                                  return const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.white,
                                      Colors.white,
                                      Colors.transparent
                                    ],
                                    stops: [0.0, 0.05, 0.95, 1.0],
                                  ).createShader(rect);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: makeList(snapshot),
                                ),
                              ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<TravelModel>> snapshot) {
    return ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var travel = snapshot.data![index];
          return Travel(
            name: travel.name,
            budgetWon: travel.budgetWon,
            numTraveler: travel.travelerNum,
            id: travel.id,
            leader: travel.leader,
            countryId: travel.countryId,
            startdate: DateTime.parse(travel.startdate),
            returndate: DateTime.parse(travel.returndate),
            moneyTerm: travel.moneyTerm,
            remainBudget: travel.remainBudget,
            review: travel.review,
          );
        },
        separatorBuilder: ((context, index) => const SizedBox(
              height: 10,
            )),
        itemCount: snapshot.data!.length);
  }
}
