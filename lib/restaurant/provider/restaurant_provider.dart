import 'package:flutter_lv2/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2/common/model/pagiantion_params.dart';
import 'package:flutter_lv2/common/provider/pagination_provier.dart';
import 'package:flutter_lv2/restaurant/model/restaurant_model.dart';
import 'package:flutter_lv2/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((e) => e.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);

  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  
  void getDetail({
    required String id,
  }) async {
    //만약 데이터가 없다면 (CursorPagiantion == False)
    // -> paginate()를 호출 (데이터 가져오는 시도 함)
    if (state is! CursorPagination) {
      await paginate();
    }

    // 그래도 데이터가 없다면 (state != CursorPagination)
    // 서버 오류 등
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    //[RestaurantModel]을 [RestaurantDetailModel]로 변환
    //ex) [RestaurantModel1] [RestaurantModel2] [RestaurantModel3]
    // getDetail(id:2);
    // [RestaurantModel1] [RestaurantDetailModel2] [RestaurantModel3]
    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>(
            (e) => e.id == id ? resp : e,
          )
          .toList(),
    );
  }
}
