import 'dart:developer';

import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with LoadingMixin<LoadingPage, String> {
  int total = 50;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    //todo: load data from here

    //add init list
    addInitList(List.generate(10, (index) => (length + index).toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: super.build(context),
    );
  }

  @override
  Future<List<String>> onRefresh() async {
    return List.generate(12, (index) => (index).toString());
  }

  @override
  Future<List<String>> onLoadMore() async {
    if (canLoadMore()) {
      await Future.delayed(Duration(seconds: 1));
      return List.generate(10, (index) => (length + index).toString());
    }
    return [];
  }

  @override
  Widget builder(String item) {
    return ListTile(title: Text(item));
  }

  @override
  bool canLoadMore() {
    return total > length;
  }
}

mixin LoadingMixin<T extends StatefulWidget, S> on State<T> {
  List<S> list = [];

  bool _isInit = false;

  bool _isLoadingMore = false;

  int get length => list.length;

  Future<List<S>> onRefresh();

  Future<List<S>> onLoadMore();

  void addInitList(List<S> l) {
    if (!_isInit) {
      replace(l);
      _isInit = true;
    } else {
      log('Already init list data');
    }
  }

  void replace(List<S> l) {
    list = l;
    setState(() {});
  }

  bool canLoadMore();

  Widget builder(S item);

  Widget? buildLoadMore() {}

  void _onLoadMore() async {
    if (!_isLoadingMore) {
      _isLoadingMore = true;
      if (canLoadMore()) {
        final l = await onLoadMore();
        if (l.isNotEmpty && _isLoadingMore) {
          list.addAll(l);
          if (mounted) {
            setState(() {});
          }
        }
      }
      _isLoadingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _isLoadingMore = false;
        list = await onRefresh();
        if (mounted) {
          setState(() {});
        }
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: length + 1,
        separatorBuilder: (context, index) => const SizedBox(),
        itemBuilder: (context, index) {
          if (index == length) {
            if (canLoadMore()) {
              _onLoadMore();
              return buildLoadMore() ??
                  const SizedBox(
                    height: 30,
                    width: 30,
                    child: Center(child: CircularProgressIndicator()),
                  );
            }
            return const SizedBox();
          }

          return builder(list[index]);
        },
      ),
    );
  }
}
