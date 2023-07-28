import 'package:flutter/material.dart';
import 'package:flutter_lv2/common/provider/pagination_provier.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    if (controller.offset > controller.position.maxScrollExtent - 400) {
      provider.paginate(
        fetchMore: true,
      );
    }
  }
}
