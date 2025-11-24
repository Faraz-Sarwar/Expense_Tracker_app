import 'package:expense_tracker/view_model/expense_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyBarchart extends StatefulWidget {
  const MyBarchart({super.key});

  @override
  State<MyBarchart> createState() => _MyBarchartState();
}

class _MyBarchartState extends State<MyBarchart> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context, listen: false);

    return StreamBuilder(
      stream: viewModel.getExpense(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return Center(child: Text('An Error occured ${snapshot.error}'));
        }
        final expenses = snapshot.data ?? [];
        if (expenses.isEmpty) {
          return const Center(child: Text('No weekly expenses found'));
        }
        final barGroups = expenses.asMap().entries.map((entry) {
          final index = entry.key;
          final expense = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                width: 10,
                toY: expense.amount,
                borderRadius: BorderRadius.circular(40),
                color: Theme.of(context).primaryColor,
              ),
            ],
          );
        }).toList();
        return Padding(
          padding: const EdgeInsets.only(right: 40.0, top: 8, left: 0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              groupsSpace: 40,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 30,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= expenses.length) {
                        return const SizedBox.shrink();
                      }
                      final date = expenses[index].date;
                      final formattedDate = DateFormat('MM/dd').format(date);
                      return Text(
                        formattedDate,
                        style: TextStyle(fontSize: 14),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 90,
                    getTitlesWidget: (value, meta) {
                      final maxY = expenses
                          .map((e) => e.amount)
                          .fold<double>(0, (a, b) => a > b ? a : b);
                      int interval = 0;
                      if (maxY <= 20) {
                        interval = 5;
                      } else if (maxY <= 100) {
                        interval = 20;
                      } else if (maxY <= 300) {
                        interval = 50;
                      } else {
                        interval = 100;
                      }
                      if (value % interval != 0) return const SizedBox();
                      return Text(value.toString());
                    },
                  ),
                ),
              ),
              barGroups: barGroups,
            ),
          ),
        );
      },
    );
  }
}
