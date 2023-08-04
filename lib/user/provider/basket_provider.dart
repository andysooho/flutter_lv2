import 'package:collection/collection.dart';
import 'package:flutter_lv2/product/model/product_model.dart';
import 'package:flutter_lv2/user/model/basket_item_model.dart';
import 'package:flutter_lv2/user/model/patch_basket_body.dart';
import 'package:flutter_lv2/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);
  return BasketProvider(
    repository: repository,
  );
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketProvider({
    required this.repository,
  }) : super([]);

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                productId: e.product.id,
                count: e.count,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 1. 아직 장바구니에 해당 상품이 없다면, 장바구니에 추가
    // 2. 장바구니에 해당 상품이 있다면, 수량을 1 증가
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state.map((e) {
        if (e.product.id == product.id) {
          return e.copywith(
            count: e.count + 1,
          );
        } else {
          return e;
        }
      }).toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        ),
      ];
    }

    //Optimistic Response
    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false, // true: 강제삭제
  }) async {
    // 1-1. 장바구니에 해당 상품 존재, 카운트가 >= 2, 카운트를 1 감소
    // 1-2. 장바구니에 해당 상품 존재, 카운트가 1, 장바구니에서 제거
    // 2. 장바구니에 해당 상품이 없다면, 아무것도 하지 않음

    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count >= 2) {
      state = state.map((e) {
        if (e.product.id == product.id) {
          return e.copywith(
            count: e.count - 1,
          );
        } else {
          return e;
        }
      }).toList();
    } else if (existingProduct.count == 1 || isDelete) {
      state = state.where((e) => e.product.id != product.id).toList();
    }

    await patchBasket();
  }
}
