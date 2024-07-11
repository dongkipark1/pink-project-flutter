import 'package:flutter/material.dart';

class Customtextformfield extends StatelessWidget {
  final String text;
  const Customtextformfield(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // 배경색 설정

            borderRadius: BorderRadius.circular(50), // 둥근 테두리
            boxShadow: [
              BoxShadow(
                color: Color(0xfffc7c9a).withOpacity(0.4), // 그림자 색상 및 투명도
                spreadRadius: 2, // 그림자 퍼짐 정도
                blurRadius: 5, // 그림자 흐림 정도
                offset: Offset(0, 3), // 그림자 위치
              ),
            ],
          ),
          child: TextFormField(
            style: TextStyle(
              fontSize: 15, // 폰트사이즈
              color: Colors.black45,
            ),
            validator: (value) => value!.isEmpty
                ? "Please enter some text"
                : null,
            obscureText: text == "Password" ? true : false,
            decoration: InputDecoration(
              hintText: text,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
