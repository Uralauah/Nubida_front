import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nubida_front/models/travel_model.dart';
import 'package:nubida_front/services/service.dart';
import 'package:nubida_front/widgets/admin_view_travel_widget.dart';

class AdminViewTravel extends StatefulWidget {
  const AdminViewTravel({super.key});

  @override
  State<AdminViewTravel> createState() => _AdminViewTravelState();
}

class _AdminViewTravelState extends State<AdminViewTravel> {
  Future<List<TravelModel>> travels = Service().getAllTravel();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed('/adminpage');
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "전체 여행 목록",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: FutureBuilder(
              future: travels,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(
                        '전체 여행 개수 : ${snapshot.data!.length}',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: makeList(snapshot)),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator(
                    color: Colors.black,
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
          return AdminTravel(
            name: travel.name,
            budgetWon: travel.budgetWon,
            numTraveler: travel.travelerNum,
            id: travel.id,
            countryId: travel.countryId,
            startdate: DateTime.parse(travel.startdate),
            returndate: DateTime.parse(travel.returndate),
            remainBudget: travel.remainBudget,
          );
        },
        separatorBuilder: ((context, index) => const SizedBox(
              height: 10,
            )),
        itemCount: snapshot.data!.length);
  }
}
