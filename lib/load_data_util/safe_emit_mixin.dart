import 'package:flutter_bloc/flutter_bloc.dart';

mixin SafeEmit<T> on Cubit<T> {
  void safeEmit(T state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
