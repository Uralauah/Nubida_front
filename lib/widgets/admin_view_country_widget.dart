import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdminCountry extends StatefulWidget {
  final String name, moneyTerm;
  final double rate;
  const AdminCountry({
    super.key,
    required this.name,
    required this.moneyTerm,
    required this.rate,
  });

  @override
  State<AdminCountry> createState() => _AdminCountryState();
}

class _AdminCountryState extends State<AdminCountry> {
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
                Expanded(flex: 3, child: Center(child: Text(widget.name))),
                Expanded(flex: 2, child: Center(child: Text(widget.moneyTerm))),
                Expanded(flex: 2, child: Center(child: Text('${widget.rate}'))),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
