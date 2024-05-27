import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdminTraveler extends StatefulWidget {
  final String name, email, role;
  const AdminTraveler({
    super.key,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  State<AdminTraveler> createState() => _AdminTravelerState();
}

class _AdminTravelerState extends State<AdminTraveler> {
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
      child: SizedBox(
          width: screenWidth * 0.8,
          child: Column(
            children: [
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 2, child: Center(child: Text(widget.name))),
                  Expanded(flex: 4, child: Center(child: Text(widget.email))),
                  (widget.role == 'ROLE_ADMIN')
                      ? const Expanded(
                          flex: 2, child: Center(child: Text('관리자')))
                      : const Expanded(
                          flex: 2, child: Center(child: Text("사용자"))),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete))),
                ],
              )
            ],
          )),
    );
  }
}
