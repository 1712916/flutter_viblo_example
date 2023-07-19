import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_example/cancel_task_page/cancel_task_util.dart';
import 'package:flutter_example/load_data_util/base_response.dart';
import 'package:flutter_example/load_data_util/load_behavior.dart';
import 'package:flutter_example/load_data_util/safe_emit_mixin.dart';

/*
* LoadListData được xây dựng phục vụ cho chức năng load dữ liệu
*  - init
*  - reload
*  - refresh
*  - search
*  - loadMore
*
*  Sử dụng cho state management Cubit
*  - mixin SafeEmit: kiểm tra bloc closed trước khi emit
*
*  Sử dụng paging theo:
*  - limit: số lượng item mỗi trang
*  - offset: trang hiện tại
*  - totalRecord: tổng số item
* */

/*
* Tại sao lại sử dụng mixin thay vì 1 abstract class?
* Xem ví dụ bên dưới
* - Theo mixin: [LoadDataExampleByMixin]
* - Theo abstract class: [LoadDataExampleByAbstractClass]
*
* -> Kết luận sử dụng cái nào cũng được :#
* */

abstract class GetListResponse<L> {
  final List<L>? list;
  final int totalRecord;

  GetListResponse(this.list, this.totalRecord);
}

abstract class LoadListState<L> extends Equatable {
  final bool isLoading;
  final List<L>? list;

  const LoadListState(this.isLoading, this.list);

  LoadListState copyWith({bool? isLoading, List<L>? list});
}

mixin LoadListMixin<L, T extends LoadListState<L>> on SafeEmit<T> implements LoadBehavior, SearchBehavior {
  final CancelTaskUtil _cancelTaskUtil = CancelTaskUtil();

  String _keyWord = '';

  String get currentKeyword => _keyWord;

  int limit = 10;
  int defaultOffset = 1;

  late final LoadingUtil _loadingUtil = LoadingUtil()
    ..limit = limit
    ..setDefaultOffset(defaultOffset);

  void decreaseTotalRecords() {
    _loadingUtil.decreaseOffset();
  }

  int get totalRecord => _loadingUtil.total;

  @override
  void init() async {
    _loadList();
  }

  void _loadList({String? input}) {
    _cancelTaskUtil.addTask<Either<ErrorResponse, GetListResponse<L>>>(
      Stream.fromFuture(
        getInitList(),
      ),
      _emitList,
      (err, stackTrace) {},
    );
  }

  void onReload() {
    _keyWord = '';

    _loadingUtil.onRefresh();

    safeEmit(state.copyWith(isLoading: true) as T);

    _loadList();
  }

  @override
  Future<void> onRefresh() async {
    _keyWord = '';

    _loadingUtil.onRefresh();

    return _loadList();
  }

  @override
  void onSearch(String input) {
    _loadingUtil.onRefresh();

    _keyWord = input;

    safeEmit(state.copyWith(isLoading: true) as T);

    _loadList(input: input);
  }

  @override
  bool canLoadMore() {
    return (state.list?.length ?? 0) < _loadingUtil.total;
  }

  @override
  void onLoadMore() async {
    _cancelTaskUtil.addTask<Either<ErrorResponse, GetListResponse<L>>>(
      Stream.fromFuture(
        getLoadMoreList(),
      ),
      _emitLoadMore,
      (err, stackTrace) {},
    );
  }

  _updateLoadData(int? total) {
    _loadingUtil.total = total ?? 0;
    _loadingUtil.increaseOffset();
  }

  void _emitLoadMore(Either<ErrorResponse, GetListResponse<L>> result) {
    result.fold(
      (l) {},
      (r) {
        safeEmit(
          state.copyWith(
            isLoading: false,
            list: [...?state.list, ...?r.list],
          ) as T,
        );

        _updateLoadData(r.totalRecord);
      },
    );
  }

  void _emitList(Either<ErrorResponse, GetListResponse<L>> result) {
    result.fold((l) {
      safeEmit(
        state.copyWith(
          isLoading: false,
          list: [],
        ) as T,
      );
    }, (r) {
      safeEmit(
        state.copyWith(
          isLoading: false,
          list: r.list,
        ) as T,
      );

      _updateLoadData(r.totalRecord);
    });
  }

  Future<Either<ErrorResponse, GetListResponse<L>>> getLoadMoreList();

  Future<Either<ErrorResponse, GetListResponse<L>>> getInitList();
}

abstract class LoadListCubit<L, T extends LoadListState<L>> extends Cubit<T> with SafeEmit<T>, LoadListMixin<L, T> {
  LoadListCubit(super.initialState);
}

///**************************Example**************************

class LoadDataExampleByMixin extends Cubit<ListDataExampleState>
    with SafeEmit, LoadListMixin<int, ListDataExampleState> {
  LoadDataExampleByMixin() : super(const ListDataExampleState(true, null));

  @override
  Future<Either<ErrorResponse, GetListResponse<int>>> getInitList() {
    // TODO: implement getInitList
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorResponse, GetListResponse<int>>> getLoadMoreList() {
    // TODO: implement getLoadMoreList
    throw UnimplementedError();
  }
}

class LoadDataExampleByAbstractClass extends LoadListCubit<int, ListDataExampleState> {
  LoadDataExampleByAbstractClass() : super(const ListDataExampleState(true, null));

  @override
  Future<Either<ErrorResponse, GetListResponse<int>>> getInitList() {
    // TODO: implement getInitList
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorResponse, GetListResponse<int>>> getLoadMoreList() {
    // TODO: implement getLoadMoreList
    throw UnimplementedError();
  }
}

class ListDataExampleState extends LoadListState<int> {
  const ListDataExampleState(super.isLoading, super.list, {this.title});

  final String? title;

  @override
  LoadListState copyWith({bool? isLoading, List<int>? list, String? title}) {
    return ListDataExampleState(
      isLoading ?? this.isLoading,
      list ?? this.list,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        list.hashCode,
        title,
      ];
}
