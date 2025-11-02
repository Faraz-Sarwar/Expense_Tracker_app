import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/view_model/expense_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

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
              ),
            ],
          );
        }).toList();
        return BarChart(
          BarChartData(
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
                    return Text(expenses[index].category.toString());
                  },
                ),
              ),
            ),
            barGroups: barGroups,
          ),
        );
      },
    );
  }
}
