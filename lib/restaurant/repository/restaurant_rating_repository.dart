import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_lv2/common/const/data.dart';
import 'package:flutter_lv2/common/dio/dio.dart';
import 'package:flutter_lv2/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2/common/model/pagiantion_params.dart';
import 'package:flutter_lv2/rating/model/rating_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_rating_repository.g.dart';

final RestaurantRatingRepositoryProvider =
    Provider.family<RestaurantRatingRepository, String>((ref, rid) {
  final dio = ref.watch(dioProvider);
  final repository = RestaurantRatingRepository(dio,
      baseUrl: 'http://$ip/restaurant/$rid/rating');

  return repository;
});

// http://$ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? params = const PaginationParams(),
  });
}
