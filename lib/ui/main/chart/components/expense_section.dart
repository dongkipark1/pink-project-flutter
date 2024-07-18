import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseSection<T> extends StatelessWidget {
  final int touchedIndex;
  final ValueChanged<int> onTouch;
  final List<T> expenses;
  final DateTime selectedDate;

  ExpenseSection({
    required this.touchedIndex,
    required this.onTouch,
    required this.expenses,
    required this.selectedDate,
  });

  String getCategoryEmoji(String category) {
    switch (category) {
      case '식비':
        return '🍱';
      case '교통/차량':
        return '🚖';
      case '문화생활':
        return '🖼️';
      case '패션/미용':
        return '🧥';
      case '생활용품':
        return '🪑';
      case '주거/통신':
        return '🏠';
      case '건강':
        return '🧘';
      case '교육':
        return '📖';
      case '경조사/회비':
        return '🎁';
      case '부모님':
        return '👵';
      case '기타':
        return '🎸';
      default:
        return '❓';
    }
  }

  List<PieChartSectionData> showingExpenseSections(
      List<T> filteredExpenses, List<String> percentages) {
    if (filteredExpenses.isEmpty) {
      print("No expense data available.");
      return [];
    }

    double totalAmount = filteredExpenses.fold(
        0,
            (sum, item) => sum + int.parse((item as dynamic).amount.replaceAll(',', '')));

    return List.generate(filteredExpenses.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final value = int.parse((filteredExpenses[i] as dynamic).amount.replaceAll(',', ''));
      final percentage = (value / totalAmount * 100).toStringAsFixed(1) + '%';
      percentages.add(percentage);
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: Colors.red,
        value: value.toDouble(),
        title: percentage,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
      );
    });
  }

  List<Widget> getExpenseList(
      List<T> filteredExpenses, List<String> percentages) {
    if (filteredExpenses.isEmpty) {
      print("No expense data available.");
      return [Text('No expense data available.')];
    }

    final Map<String, int> categorySums = {};
    for (var expense in filteredExpenses) {
      final category = (expense as dynamic).category;
      final amount = int.parse(expense.amount.replaceAll(',', ''));
      if (categorySums.containsKey(category)) {
        categorySums[category] = categorySums[category]! + amount;
      } else {
        categorySums[category] = amount;
      }
    }

    return List.generate(categorySums.length, (i) {
      final category = categorySums.keys.elementAt(i);
      final amount = categorySums[category]!;
      final percentage = percentages[i];

      final T? matchingExpense = filteredExpenses.cast<T?>().firstWhere(
            (expense) => (expense as dynamic).category == category,
        orElse: () => null,
      );

      final categoryEmoji = matchingExpense != null
          ? getCategoryEmoji((matchingExpense as dynamic).category)
          : '';

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: ListTile(
          leading: Container(
            width: 45.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: Text(
              percentage,
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),
          title: Row(
            children: [
              Text(
                categoryEmoji,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(width: 8.0),
              Text(
                category,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: Text('${amount}원'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> percentages = [];

    print("Building ExpenseSection with ${expenses.length} expenses.");

    return Column(
      children: [
        Container(
          height: 250,
          margin: EdgeInsets.fromLTRB(0, 50.0, 0, 50.0),
          child: PieChart(
            PieChartData(
              sections: showingExpenseSections(expenses, percentages),
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    onTouch(-1);
                    return;
                  }
                  onTouch(pieTouchResponse.touchedSection!.touchedSectionIndex);
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: getExpenseList(expenses, percentages),
          ),
        ),
      ],
    );
  }
}
