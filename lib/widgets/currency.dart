import 'package:flutter/material.dart';
import 'package:nubida_front/services/service.dart';

class Currency extends StatefulWidget {
  final String currencyCode;
  const Currency({super.key, required this.currencyCode});

  @override
  State<Currency> createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  String date = '', time = '', change = '';
  double changePrice = 0.0, highPrice = 0.0;

  Future<Map<String, dynamic>>? Currency;

  @override
  void initState() {
    super.initState();
    Currency = Service().getCurrency(widget.currencyCode);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Currency,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${snapshot.data!['country']}',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    '${snapshot.data!['currencyCode']}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Text(
                '${snapshot.data!['date']}',
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
              Text('${snapshot.data!['time']}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${snapshot.data!['highPrice']}',
                    style: TextStyle(
                      color: (snapshot.data!['change'] == 'RISE')
                          ? Colors.red
                          : Colors.blue,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${snapshot.data!['changePrice']}',
                    style: TextStyle(
                      color: (snapshot.data!['change'] == 'RISE')
                          ? Colors.red
                          : Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                    (snapshot.data!['change'] == 'RISE')
                        ? Icons.arrow_drop_up_rounded
                        : Icons.arrow_drop_down_rounded,
                    color: (snapshot.data!['change'] == 'RISE')
                        ? Colors.red
                        : Colors.blue,
                    size: 27,
                  )
                ],
              )
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
    );
  }
}
