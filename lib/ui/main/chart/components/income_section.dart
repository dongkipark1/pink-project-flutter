import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class IncomeSection<T> extends StatelessWidget {
  final int touchedIndex;
  final ValueChanged<int> onTouch;
  final List<T> incomes;
  final DateTime selectedDate;

  IncomeSection({
    required this.touchedIndex,
    required this.onTouch,
    required this.incomes,
    required this.selectedDate,
  });

  List<PieChartSectionData> showingIncomeSections(List<T> filteredIncomes, List<String> percentages) {
    if (filteredIncomes.isEmpty) {
      print("No income data available.");
      return [];
    }

    double totalAmount = filteredIncomes.fold(
        0,
            (sum, item) => sum + int.parse((item as dynamic).amount.replaceAll(',', '')));

    return List.generate(filteredIncomes.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final value = int.parse((filteredIncomes[i] as dynamic).amount.replaceAll(',', ''));
      final percentage = (value / totalAmount * 100).toStringAsFixed(1) + '%';
      percentages.add(percentage);
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: Colors.blue,
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

  List<Widget> getIncomeList(List<T> filteredIncomes, List<String> percentages) {
    if (filteredIncomes.isEmpty) {
      print("No income data available.");
      return [Text('No income data available.')];
    }

    final Map<String, int> categorySums = {};
    for (var income in filteredIncomes) {
      final item = income as dynamic;
      final category = item.category;
      final amount = int.parse(item.amount.replaceAll(',', ''));
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

      // 안전하게 값을 가져오기 위해 타입 검사
      final T? matchingIncome = filteredIncomes.cast<T?>().firstWhere(
            (income) => (income as dynamic).category == category,
        orElse: () => null,
      );

      final categoryImagePath = matchingIncome != null
          ? (matchingIncome as dynamic).categoryImagePath
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
              color: Colors.blue,
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
                categoryImagePath,
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

    print("Building IncomeSection with ${incomes.length} incomes.");

    return Column(
      children: [
        Container(
          height: 250,
          margin: EdgeInsets.fromLTRB(0, 50.0, 0, 50.0),
          child: PieChart(
            PieChartData(
              sections: showingIncomeSections(incomes, percentages),
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
            children: getIncomeList(incomes, percentages),
          ),
        ),
      ],
    );
  }
}
