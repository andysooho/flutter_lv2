import 'package:flutter/material.dart';
import 'package:flutter_lv2/common/const/colors.dart';


class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight( //높이를 최대 의 높이에 맞춰서 늘림
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'asset/img/food/ddeok_bok_gi.jpg',
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,//똑같이 빈?간격 나누기
                children: [
                  Text(
                    '떡볶이',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                      '전통떡볶이의 정석\n둘이먹다 하나죽어도 모를맛',
                      overflow: TextOverflow.ellipsis, //텍스트가 넘치면 ...으로 표시
                      maxLines: 2,
                      style: TextStyle(
                        color: BODY_TEXT_COLOR,
                        fontSize: 14.0,
                      ),
                  ),
                  Text(
                    '₩10000',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ),
        ],

      ),
    );
  }
}
