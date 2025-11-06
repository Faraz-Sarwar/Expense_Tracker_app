import 'package:expense_tracker/model/expense_model.dart';
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
          return const Center(child: Text('No expense found'));
        }
        final barGroups = expenses.asMap().entries.map((entry) {
          final index = entry.key;
          final expense = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: expense.amount,
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).primaryColor,
                backDrawRodData: BackgroundBarChartRodData(
                  fromY: expense.amount,
                  toY: expense.amount * 2,
                  color: const Color.fromARGB(255, 105, 104, 104),
                  show: true,
                ),
              ),
            ],
          );
        }).toList();
        return Padding(
          padding: const EdgeInsets.only(right: 40.0, top: 8, left: 13),
          child: BarChart(
            BarChartData(
              groupsSpace: 63,
              alignment: BarChartAlignment.center,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 && index >= expenses.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        expenses[index].category.toString(),
                        style: TextStyle(fontSize: 14),
                      );
                    },
                  ),
                ),

                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 30,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= expenses.length) {
                        return SizedBox.shrink();
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
                    reservedSize: 70,
                    getTitlesWidget: (value, meta) {
                      if (value % 50 != 0) return const SizedBox();
                      return Text(
                        '\$${value.toInt()}',
                        style: TextStyle(fontSize: 16),
                      );
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
