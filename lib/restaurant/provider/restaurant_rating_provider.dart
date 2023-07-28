import 'package:flutter_lv2/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2/common/provider/pagination_provier.dart';
import 'package:flutter_lv2/rating/model/rating_model.dart';
import 'package:flutter_lv2/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantRatingProvider = StateNotifierProvider.family<
    RestaurantRatingStateNotifier, CursorPaginationBase, String>((ref,id) {
  final repo = ref.watch(RestaurantRatingRepositoryProvider(id));

  final notifier = RestaurantRatingStateNotifier(repository: repo);
  return notifier;
});

class RestaurantRatingStateNotifier
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  RestaurantRatingStateNotifier({
    required super.repository,
  });
}
