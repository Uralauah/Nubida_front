import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nubida_front/models/country_model.dart';
import 'package:nubida_front/services/service.dart';
import 'package:nubida_front/widgets/add_country.dart';
import 'package:nubida_front/widgets/admin_view_country_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AdminViewCountry extends StatefulWidget {
  const AdminViewCountry({super.key});

  @override
  State<AdminViewCountry> createState() => _AdminViewCountryState();
}

class _AdminViewCountryState extends State<AdminViewCountry> {
  Future<List<CountryModel>> travelers = Service().getAllCountry();

  void refresh() {
    setState(() {
      travelers = Service().getAllCountry();
    });
  }

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
              "전체 국가 목록",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '전체 국가 수 : ${snapshot.data!.length}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[200],
                              borderRadius: BorderRadius.circular(25)),
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              var result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      "국가 추가",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    content: SizedBox(
                                      height: 280,
                                      width: 240,
                                      child: AddCountry(),
                                    ),
                                  );
                                },
                              );
                              if (result == "success") {
                                refresh();
                              }
                            },
                            child: const AutoSizeText(
                              "국가 추가",
                              maxLines: 1,
                              minFontSize: 10,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(flex: 3, child: Center(child: Text("이름"))),
                        Expanded(flex: 2, child: Center(child: Text("화폐 단위"))),
                        Expanded(flex: 2, child: Center(child: Text("평점"))),
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

  ListView makeList(AsyncSnapshot<List<CountryModel>> snapshot) {
    return ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var country = snapshot.data![index];
          return AdminCountry(
            name: country.name,
            moneyTerm: country.moneyTerm,
            rate: country.rate,
          );
        },
        separatorBuilder: ((context, index) => const SizedBox(
              height: 10,
            )),
        itemCount: snapshot.data!.length);
  }
}
