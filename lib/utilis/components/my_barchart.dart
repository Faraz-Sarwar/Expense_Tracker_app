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
    final viewModel = Provider.of<ExpenseViewModel>(context, listen: true);

    return StreamBuilder(
      stream: viewModel.getExpense(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasError) {
          return Center(child: Text('An Error occurred ${snapshot.error}'));
        }

        final expenses = snapshot.data ?? [];

        if (expenses.isEmpty) {
          return const Center(child: Text('No weekly expenses found'));
        }

        final maxY = expenses
            .map((e) => e.amount)
            .fold<double>(0, (max, value) => value > max ? value : max);

        return Padding(
          padding: const EdgeInsets.only(right: 40.0, top: 8),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (expenses.length - 1).toDouble(),
              minY: 0,
              maxY: maxY,

              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),

                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();

                      if (index < 0 || index >= expenses.length) {
                        return const SizedBox.shrink();
                      }

                      // hide labels except interval
                      if (index % viewModel.interval != 0) {
                        return const SizedBox.shrink();
                      }

                      final date = expenses[index].date;
                      final formatted = DateFormat('MM/dd').format(date);

                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          formatted,
                          style: const TextStyle(fontSize: 11),
                        ),
                      );
                    },
                  ),
                ),

                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),

                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.black.withOpacity(0.7),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final index = spot.x.toInt();
                      final expense = expenses[index];

                      return LineTooltipItem(
                        "${DateFormat('MM/dd').format(expense.date)}\n"
                        "Rs ${expense.amount.toStringAsFixed(0)}",
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,

                  // GRADIENT LINE
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Colors.orange],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),

                  barWidth: 4,
                  dotData: FlDotData(show: false),

                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.3),
                        Colors.orange.withOpacity(0.15),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  spots: expenses.asMap().entries.map((entry) {
                    final index = entry.key;
                    final expense = entry.value;

                    return FlSpot(index.toDouble(), expense.amount.toDouble());
                  }).toList(),
                ),
              ],
              showingTooltipIndicators: [],
            ),
          ),
        );
      },
    );
  }
}
