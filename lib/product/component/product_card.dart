import 'package:flutter/material.dart';
import 'package:flutter_lv2/common/const/colors.dart';
import 'package:flutter_lv2/product/model/product_model.dart';
import 'package:flutter_lv2/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_lv2/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;
  final String id;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const ProductCard({
    required this.id,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    this.onAdd,
    this.onRemove,
    Key? key,
  }) : super(key: key);

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onAdd,
    VoidCallback? onRemove,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        fit: BoxFit.cover,
        width: 110,
        height: 110,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onAdd: onAdd,
      onRemove: onRemove,
    );
  }

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantProductModel model,
    VoidCallback? onAdd,
    VoidCallback? onRemove,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        fit: BoxFit.cover,
        width: 110,
        height: 110,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onAdd: onAdd,
      onRemove: onRemove,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    return Column(
      children: [
        IntrinsicHeight(
          //높이를 최대 의 높이에 맞춰서 늘림
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: image,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, //똑같이 빈?간격 나누기
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      detail,
                      overflow: TextOverflow.ellipsis, //텍스트가 넘치면 ...으로 표시
                      maxLines: 2,
                      style: const TextStyle(
                        color: BODY_TEXT_COLOR,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      '₩$price',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
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
        ),
        if (onAdd != null && onRemove != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _Footer(
              //_Footer 에서 factory Constructor로 받아서 깔끔하게 더 정리 가능
              total: (basket.firstWhere((e) => e.product.id == id).count *
                      basket
                          .firstWhere((e) => e.product.id == id)
                          .product
                          .price)
                  .toString(),
              count: basket.firstWhere((e) => e.product.id == id).count,
              onAdd: onAdd!,
              onRemove: onRemove!,
            ),
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _Footer({
    required this.total,
    required this.count,
    required this.onAdd,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '총액 ₩$total',
            style: const TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            renderButton(
              icon: Icons.remove,
              onTap: onRemove,
            ),
            const SizedBox(width: 8.0),
            Text(
              count.toString(),
              style: const TextStyle(
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8.0),
            renderButton(
              icon: Icons.add,
              onTap: onAdd,
            ),
          ],
        ),
      ],
    );
  }

  Widget renderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: PRIMARY_COLOR,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
