import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nubida_front/models/recommend_country_model.dart';
import 'package:nubida_front/models/travel_model.dart';
import 'package:nubida_front/services/check_token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nubida_front/services/service.dart';
import 'package:nubida_front/widgets/recommend_country_widget.dart';
import 'package:nubida_front/widgets/travel_wiget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    checkToken(context);
    initPage();
  }

  Future<void> initPage() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: 'page');
    await storage.write(key: 'page', value: '0');
  }

  Future<void> logout(BuildContext context) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'page');
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<TravelModel?> travel = Service().getNextTravel();
  Future<List<RecommendCountryModel>> countries =
      Service().getRecommendCountry();

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
          body: Padding(
            padding: const EdgeInsets.only(
              top: 80,
              right: 30,
              left: 30,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 280,
                  child: FutureBuilder<TravelModel?>(
                    future: travel,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                          "에러가 발생했습니다.",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        if (snapshot.data == null) {
                          return Column(
                            children: [
                              const Text(
                                "다음 여행이 없어요..",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text("새로운 여행을 시작하세요"),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              const Text(
                                "다음 여행은 여기네요!",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              makewidget(snapshot),
                            ],
                          );
                        }
                      } else {
                        return Column(
                          children: [
                            const Text(
                              "다음 여행이 없어요..",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/createTravel");
                                },
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.luggage_outlined,
                                      size: 85,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "새로운 여행을 계획해보세요!",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                const Divider(),
                const Text(
                  "다음은 여기 어때요?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: countries,
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return makeList(snapshot);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      }
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makewidget(AsyncSnapshot<TravelModel?> snapshot) {
    if (snapshot.data == null) {
      return const Text(
        "다음 여행이 없어요..",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      TravelModel travel = snapshot.data!;
      return Travel(
        name: travel.name,
        leader: travel.leader,
        budgetWon: travel.budgetWon,
        numTraveler: travel.travelerNum,
        id: travel.id,
        countryId: travel.countryId,
        startdate: DateTime.parse(travel.startdate),
        returndate: DateTime.parse(travel.returndate),
        moneyTerm: travel.moneyTerm,
        remainBudget: travel.remainBudget,
        review: travel.review,
      );
    }
  }

  ListView makeList(AsyncSnapshot<List<RecommendCountryModel>> snapshot) {
    return ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var country = snapshot.data![index];
          // return Travel(
          //   name: travel.name,
          //   budgetWon: travel.budgetWon,
          //   numTraveler: travel.travelerNum,
          //   id: travel.id,
          //   leader: travel.leader,
          //   countryId: travel.countryId,
          //   startdate: DateTime.parse(travel.startdate),
          //   returndate: DateTime.parse(travel.returndate),
          //   moneyTerm: travel.moneyTerm,
          //   remainBudget: travel.remainBudget,
          //   review: travel.review,
          // );
          return Country(
            name: country.name,
            rate: country.rate,
            review_cnt: country.review_cnt,
            reviews: country.reviewmodels,
          );
        },
        separatorBuilder: ((context, index) => const SizedBox(
              height: 10,
            )),
        itemCount: snapshot.data!.length);
  }
}
