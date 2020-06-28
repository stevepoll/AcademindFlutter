import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  var totalSpent = 0.0;

  List<Map<String, Object>> get groupedTransactionValues {
    final dayAmounts = {
      'Mon': 0.0,
      'Tue': 0.0,
      'Wed': 0.0,
      'Thu': 0.0,
      'Fri': 0.0,
      'Sat': 0.0,
      'Sun': 0.0
    };

    for (var txn in recentTransactions) {
      totalSpent += txn.amount;

      final day = DateFormat.E().format(txn.date);
      if (dayAmounts.containsKey(day)) {
        dayAmounts[day] += txn.amount;
      }
    }

    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      final shortDay = DateFormat.E().format(weekDay);

      return {'day': shortDay, 'amount': dayAmounts[shortDay]};
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            final singleCharDay = data['day'].toString().substring(0, 1);
//          return Text('$singleCharDay: ${data['amount']}');
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                singleCharDay,
                data['amount'],
                totalSpent == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpent,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
