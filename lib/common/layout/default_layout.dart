import 'package:flutter/material.dart';

//이제 여기에 공통적으로 넣고싶은거 넣으면 된다.
class DafaultLayout extends StatelessWidget {
  final Widget child;

  const DafaultLayout({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    backgroundColor: Colors.white;
    return Scaffold(
      body: child, //입력받은 child를 그대로 넘겨주기
    );
  }
}
