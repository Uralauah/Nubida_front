import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nubida_front/models/travel_model.dart';
import 'package:nubida_front/services/service.dart';
import 'package:nubida_front/widgets/travel_wiget.dart';

class AllTravel extends StatefulWidget {
  const AllTravel({super.key});

  @override
  State<AllTravel> createState() => _AllTravelState();
}

class _AllTravelState extends State<AllTravel> {
  Future<List<TravelModel>> travels = Service().getMyTravel();

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
            appBar: AppBar(
              title: const Text("모든 여행 목록"),
            ),
            body: FutureBuilder(
              future: travels,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "아직 여행이 없네요..",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return ShaderMask(
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
                        stops: [0.0, 0.03, 0.97, 1.0],
                      ).createShader(rect);
                    },
                    child: makeList(snapshot),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }
              },
            )),
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
