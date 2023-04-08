import 'package:flutter/material.dart';

import 'common/component/custom_text_form_field.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTeextFormField(
              hintText: '이메일을 입력하세요',
              onChanged: (String value) {},
            ),
            CustomTeextFormField(
              hintText: '비밀번호를 입력하세요',
              onChanged: (String value) {},
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }
}
