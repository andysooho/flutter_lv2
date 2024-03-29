import 'package:flutter/material.dart';
import 'package:flutter_lv2/common/const/colors.dart';
import 'package:flutter_lv2/common/layout/default_layout.dart';
import 'package:flutter_lv2/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2/common/utils/pagination_utils.dart';
import 'package:flutter_lv2/product/component/product_card.dart';
import 'package:flutter_lv2/product/model/product_model.dart';
import 'package:flutter_lv2/rating/component/rating_card.dart';
import 'package:flutter_lv2/rating/model/rating_model.dart';
import 'package:flutter_lv2/restaurant/component/restaurant_card.dart';
import 'package:flutter_lv2/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_lv2/restaurant/model/restaurant_model.dart';
import 'package:flutter_lv2/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_lv2/restaurant/provider/restaurant_rating_provider.dart';
import 'package:flutter_lv2/restaurant/view/basket_screen.dart';
import 'package:flutter_lv2/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';
import 'package:badges/badges.dart' as badges;

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id; //클릭한 식당의 id
  static String get routeName => 'restaruantDetail';

  const RestaurantDetailScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    _scrollController.addListener(addListener);
  }

  void addListener() {
    PaginationUtils.paginate(
      controller: _scrollController,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: '식당 상세',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(BasketScreen.routeName);
        },
        backgroundColor: PRIMARY_COLOR,
        child: badges.Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket.fold<int>(0, (prev, next) => prev + next.count).toString(),
            style: const TextStyle(
              color: PRIMARY_COLOR,
            ),
          ),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.white,
          ),
          child: const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
          ),
        ),
      ),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          renderTop(
            model: state,
          ),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(
              products: state.products,
              restaurant: state,
            ),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(models: ratingsState.data),
        ],
      ),
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RatingCard.fromModel(
                model: models[index],
              ),
            );
          },
          childCount: models.length,
        ),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate(List.generate(
              3,
              (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: SkeletonParagraph(
                        style: const SkeletonParagraphStyle(
                      lines: 5,
                      padding: EdgeInsets.zero,
                    )),
                  ))),
        ));
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        //일반 위젯
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

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
    required RestaurantModel restaurant,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index]; //products의 index번째를 model에 넣음

            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                      product: ProductModel(
                        id: model.id,
                        name: model.name,
                        imgUrl: model.imgUrl,
                        detail: model.detail,
                        price: model.price,
                        restaurant: restaurant,
                      ),
                    );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard.fromRestaurantProductModel(
                  model: model,
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
