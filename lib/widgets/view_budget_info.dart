import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nubida_front/models/plan_model.dart';
import 'package:nubida_front/widgets/add_budget_widget.dart';
import 'package:nubida_front/services/service.dart';
import 'package:intl/intl.dart';

class ViewBudgetInfo extends StatefulWidget {
  final int budgetWon, remainBudget, id;
  const ViewBudgetInfo({
    super.key,
    required this.budgetWon,
    required this.remainBudget,
    required this.id,
  });

  @override
  State<ViewBudgetInfo> createState() => _ViewBudgetInfoState();
}

class _ViewBudgetInfoState extends State<ViewBudgetInfo> {
  late Future<List<PlanModel>> plans;

  @override
  void initState() {
    super.initState();
    plans = Service().getPlan(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "전체 예산 : ${NumberFormat('#,##0', 'en_US').format(widget.budgetWon)}",
            style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "잔여 예산 : ${NumberFormat('#,##0', 'en_US').format(widget.remainBudget)}",
            style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextButton(
            onPressed: () async {
              var result = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text(
                      "예산 추가",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    content: SizedBox(
                      height: 180,
                      width: 240,
                      child: AddBudget(id: widget.id),
                    ),
                  );
                },
              );
              if (result == "success") {
                Navigator.pop(context, 'success');
              }
            },
            child: const Text(
              '예산 추가',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
          ),
          // TextButton(
          //   onPressed: () {},
          //   child: const Text(
          //     "예산 추가",
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 20,
          //     ),
          //   ),
          // ),
          const Divider(),
          const Text(
            "예산 사용 내역",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "사용일",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "사용처",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "비용",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: plans,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: makeList(snapshot),
                );
              } else {
                return const CircularProgressIndicator(
                  color: Colors.black,
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<PlanModel>> snapshot) {
    return ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var plan = snapshot.data![index];
          return SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${plan.start_date.month}-${plan.start_date.day} ${plan.start_date.hour}시',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  plan.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  NumberFormat('#,##0', 'en_US').format(plan.cost),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: ((context, index) => const SizedBox(
              height: 10,
            )),
        itemCount: snapshot.data!.length);
  }
}
