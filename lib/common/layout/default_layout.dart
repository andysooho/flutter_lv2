import 'package:flutter/material.dart';

//이제 여기에 공통적으로 넣고싶은거 넣으면 된다.
class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child, //입력받은 child를 그대로
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, //그림자 없애기
      title: Text(
        title!,
        style: const TextStyle(
          color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        ),
      ),
      foregroundColor: Colors.black,
    );
  }
}
