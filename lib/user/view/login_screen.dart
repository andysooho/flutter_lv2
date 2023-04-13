import 'package:flutter/material.dart';
import 'package:flutter_lv2/common/component/custom_text_form_field.dart';
import 'package:flutter_lv2/common/const/colors.dart';
import 'package:flutter_lv2/common/layout/default_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  //나중에 규모 커지만 모든 페이지에 공통적으로 적용하고 싶은 기능이 생길 것.
  //그래서 모든 View를 DefaultLayout으로 감싸서 사용하는걸 권장.
  @override
  Widget build(BuildContext context) {
    return DafaultLayout(
      child: SingleChildScrollView( //키보드 올리면 화면이 잘림 제일 쉬운 해결방법중 하나는은 스크롤 가능하게 만들기
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,//화면 드랙그 하면 키보드 내려감
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(height: 16.0),
                _SubTitle(),

                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width * 0.66,
                ),
                CustomTeextFormField(
                  hintText: '이메일을 입력하세요',
                  onChanged: (String value) {},
                ),
                const SizedBox(height: 12.0),
                CustomTeextFormField(
                  hintText: '비밀번호를 입력하세요',
                  onChanged: (String value) {},
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('로그인'),
                ),
                TextButton(
                  onPressed: (){},
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    '회원가입',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16.0,
        //fontWeight: FontWeight.w400,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
