import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lv2/common/const/data.dart';
import 'package:flutter_lv2/common/layout/default_layout.dart';
import 'package:flutter_lv2/product/component/product_card.dart';
import 'package:flutter_lv2/restaurant/component/restaurant_card.dart';
import 'package:flutter_lv2/restaurant/model/restaurant_detail_model.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id; //클릭한 식당의 id

  const RestaurantDetailScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '식당 상세',
      child: FutureBuilder<Map<String, dynamic>>(
        future: getRestaurantDetail(),
        builder: (_, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator()
            );
          }

          final item = RestaurantDetailModel.fromJson(
            json: snapshot.data!,
          );

          return CustomScrollView(
            slivers: [
              renderTop(
                model: item,
              ),
              renderLabel(),
              renderProducts(),
            ],
          );
        },
      ),

      // Column(
      //   children: [
      //     RestaurantCard(
      //       image: Image.asset(
      //         'asset/img/food/ddeok_bok_gi.jpg',
      //         fit: BoxFit.cover,
      //       ),
      //       name: '불타는 떡복이',
      //       tags: ['떡볶이', '분식', '치즈'],
      //       ratingsCount: 100,
      //       deliveryTime: 30,
      //       deliveryFee: 3000,
      //       ratings: 4.76,
      //       isDetail: true,
      //       detail: '떡볶이는 맛있어요',
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 16.0),
      //       child: ProductCard(),
      //     ),
      //   ],
      // ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard(),
            );
          },
          childCount: 10,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
