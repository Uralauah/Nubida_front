import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nubida_front/models/traveler_model.dart';
import 'package:nubida_front/services/service.dart';
import 'package:nubida_front/widgets/admin_view_traveler_widget.dart';

class AdminViewTraveler extends StatefulWidget {
  const AdminViewTraveler({super.key});

  @override
  State<AdminViewTraveler> createState() => _AdminViewTravelerState();
}

class _AdminViewTravelerState extends State<AdminViewTraveler> {
  Future<List<TravelerModel>> travelers = Service().getAllTraveler();

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
              "전체 사용자 목록",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: FutureBuilder(
            future: travelers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(
                      '전체 사용자 수 : ${snapshot.data!.length}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(flex: 2, child: Center(child: Text("닉네임"))),
                        Expanded(flex: 4, child: Center(child: Text("이메일"))),
                        Expanded(flex: 2, child: Center(child: Text("권한"))),
                        Expanded(flex: 1, child: Text("")),
                      ],
                    ),
                    Expanded(child: makeList(snapshot)),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<TravelerModel>> snapshot) {
    return ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var traveler = snapshot.data![index];
          return AdminTraveler(
            name: traveler.name,
            email: traveler.email,
            role: traveler.role,
          );
        },
        separatorBuilder: ((context, index) => const SizedBox(
              height: 10,
            )),
        itemCount: snapshot.data!.length);
  }
}
