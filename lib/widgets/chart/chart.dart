import '/models/bucket_model.dart';
import 'chart_bar.dart';
import 'package:flutter/material.dart';
import '/models/expense_model.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  // Create a list of buckets to hold the total expenses for each category
  List<ExpenseBucket> get buckets {
    final Map<String, double> categoryMap = {};

    for (final expense in expenses) {
      if (categoryMap.containsKey(expense.category)) {
        categoryMap[expense.category] = categoryMap[expense.category]! + expense.amount;
      } else {
        categoryMap[expense.category] = expense.amount;
      }
    }

    return categoryMap.entries
        .map(
          (entry) => ExpenseBucket(
            category: entry.key,
            amount: entry.value,
          ),
        )
        .toList();
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.amount > maxTotalExpense) {
        maxTotalExpense = bucket.amount;
      }
    }

    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: size.width * 0.9,
      height: size.height * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary.withOpacity(0.3), Theme.of(context).colorScheme.primary.withOpacity(0.0)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets)
                  ChartBar(
                    fill: bucket.amount == 0 ? 0 : bucket.amount / maxTotalExpense,
                  )
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        textAlign: TextAlign.center,
                        bucket.category,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
