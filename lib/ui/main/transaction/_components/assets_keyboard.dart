import 'package:flutter/material.dart';

class AssetsKeyboard extends StatelessWidget {
  final TextEditingController controller;

  AssetsKeyboard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: GridView.count(
        crossAxisCount: 5,
        children: [
          _buildKeyboardButton(context, '💵︎', '현금'),
          _buildKeyboardButton(context, '🏦', '은행'),
          _buildKeyboardButton(context, '💳️', '카드'),
        ],
      ),
    );
  }

  Widget _buildKeyboardButton(BuildContext context, String icon, String text) {
    return GestureDetector(
      onTap: () {
        controller.text = '$icon $text';
        Navigator.pop(context); // 팝업 닫기
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  icon,
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  text,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
