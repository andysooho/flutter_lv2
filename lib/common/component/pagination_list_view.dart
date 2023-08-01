import 'package:flutter/material.dart';
import 'package:flutter_lv2/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2/common/model/model_with_id.dart';
import 'package:flutter_lv2/common/provider/pagination_provier.dart';
import 'package:flutter_lv2/common/utils/pagination_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
  BuildContext context, int index, T model,
);

class PagiantionListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
      
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;

  final PaginationWidgetBuilder<T> itemBuilder;

  const PagiantionListView({
    super.key,
    required this.provider,
    required this.itemBuilder,
  });

  @override
  ConsumerState<PagiantionListView> createState() =>
      _PagiantionListViewState<T>();
}

class _PagiantionListViewState<T extends IModelWithId> extends ConsumerState<PagiantionListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
        controller: _scrollController,
        provider: ref.read(widget.provider.notifier));
  }

  @override
  void dispose() {
    _scrollController.removeListener(listener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // 완전 처음 로딩
    if (state is CursorPaginationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 에러
    if (state is CursorPaginationError) {
      return Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(
                    forceRefetch: true,
                  );
            },
            child: const Text('다시 시도'),
          ),
        ],
      ));
    }

    // CursorPagination, FetchMore, Refetching : meta, data 존재

    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: cp.data.length + 1, // +1 : progress indicator
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: cp is CursorPaginationFetchingMore
                    ? const CircularProgressIndicator()
                    : const Text('마지막 데이터 입니다.'),
              ),
            );
          }

          final pItem = cp.data[index];

          return widget.itemBuilder(context, index, pItem);
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}
