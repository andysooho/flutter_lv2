import 'package:flutter/material.dart';
import 'package:flutter_lv2/common/component/pagination_list_view.dart';
import 'package:flutter_lv2/restaurant/component/restaurant_card.dart';
import 'package:flutter_lv2/restaurant/view/restaurant_detail_screen.dart';
import 'package:go_router/go_router.dart';

import '../provider/restaurant_provider.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PagiantionListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            //context.go('restaurant/${model.id}');
            context.goNamed(
              RestaurantDetailScreen.routeName,
              pathParameters: {
                'rid': model.id,
              },
            );
          },
          child: RestaurantCard.fromModel(
            model: model,
          ),
        );
      },
    );
  }
}
