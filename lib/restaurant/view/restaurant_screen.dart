import 'package:flutter/material.dart';
import 'package:flutter_lv2/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2/restaurant/component/restaurant_card.dart';
import 'package:flutter_lv2/restaurant/model/restaurant_model.dart';
import 'package:flutter_lv2/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_lv2/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<CursorPagination<RestaurantModel>>(
              future: ref.watch(restaurantRepositoryProvider).paginate(),
              builder:
                  (context, AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
                // print(snapshot.data);
                if (!snapshot.hasData) {
                  // 데이터가 없으면 로딩중
                  return const CircularProgressIndicator();
                }

                return ListView.separated(
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: (_, index) {
                    final pItem = snapshot.data!.data[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RestaurantDetailScreen(
                              id: pItem.id,
                            ),
                          ),
                        );
                      },
                      child: RestaurantCard.fromModel(
                        model: pItem,
                      ),
                    );
                  },
                  separatorBuilder: (_, index) {
                    return const SizedBox(height: 16.0);
                  },
                );
              },
            )),
      ),
    );
  }
}
