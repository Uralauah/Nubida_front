import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nubida_front/models/supply_model.dart';
import 'package:nubida_front/services/service.dart';
import 'package:nubida_front/widgets/add_supply.dart';
import 'package:nubida_front/widgets/supply_widget.dart';

class ViewSupplies extends StatefulWidget {
  final int id;
  const ViewSupplies({
    super.key,
    required this.id,
  });

  @override
  State<ViewSupplies> createState() => _ViewSuppliesState();
}

class _ViewSuppliesState extends State<ViewSupplies> {
  late Future<List<SupplyModel>> supplies;

  void refreshSupplies() {
    setState(() {
      supplies = Service().getSupplies(widget.id);
    });
  }

  @override
  void initState() {
    super.initState();
    supplies = Service().getSupplies(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SupplyModel>>(
        future: supplies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 110,
                      child: TextButton(
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text(
                                  "준비물 추가",
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
                                  height: 300,
                                  child: AddSupply(travel_id: widget.id),
                                ),
                              );
                            },
                          );
                          if (result == 'success') {
                            refreshSupplies();
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
                        child: const Center(
                          child: Text(
                            '준비물 추가',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(child: Text("이름")),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(child: Text("수량")),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(child: Text("상태")),
                    ),
                  ],
                ),
                Expanded(child: makeList(snapshot)),
              ],
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        });
  }

  ListView makeList(AsyncSnapshot<List<SupplyModel>> snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return ListView(
        children: const [Center(child: Text('준비물이 없어요'))],
      );
    }

    return ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var supply = snapshot.data![index];
          return Supply(
            id: widget.id,
            check: supply.check,
            count: supply.count,
            name: supply.name,
          ); // Ensure SupplyWidget is the correct widget
        },
        separatorBuilder: ((context, index) => const SizedBox(
              height: 10,
            )),
        itemCount: snapshot.data!.length);
  }
}
