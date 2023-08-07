import 'package:flutter/material.dart';
import 'package:flutter_lv2/common/component/pagination_list_view.dart';
import 'package:flutter_lv2/order/component/order_card.dart';
import 'package:flutter_lv2/order/model/order_model.dart';
import 'package:flutter_lv2/order/provider/order_provier.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PagiantionListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(_,index, model) {
        return OrderCard.fromModel(model: model);
      },
    );
  }
}
