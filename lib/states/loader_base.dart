import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///
///Base class for loader
///

abstract class LoaderState<T> {}

///
/// The loader is initialized but do not load anything
///
class LoaderInitialized<T> extends LoaderState<T> {}

///
/// The loader is loading something
///
class Loading<T> extends LoaderState<T> {}

///
/// The loader is loaded something
///
class Loaded<T> extends LoaderState<T> {
  ///
  /// Loaded data
  ///
  final T loaded;
  final String tag;
  Loaded({required this.loaded, this.tag = ""});
}

///
/// Loader failed
///
class LoaderError<T> extends LoaderState<T> {
  final Error error;
  LoaderError(this.error);
}

///
///Base class for the loader
///
abstract class LoaderCubitBase<T> extends Cubit<LoaderState<T>> {
  LoaderCubitBase() : super(LoaderInitialized<T>());
  @protected
  void loadStuffsInternal(Future<T> f, String tag) {
    emit(Loading<T>());
    f.then((data) {
      emit(Loaded(loaded: data, tag: tag));
    }, onError: (error) {
      emit(LoaderError(error));
    });
  }

  ///
  /// can the loader reset
  ///
  bool get canReset => state is! Loading<T>;

  ///
  /// reset the loader
  ///
  void reset() {
    if (!canReset) {
      throw Exception("The loader is not resetable");
    }
    emit(LoaderInitialized());
  }

  ///
  /// some utilities to get the stuffs
  ///

  ///
  /// is the loader is loading the stuffs
  ///
  bool get isLoading => state is Loading<T>;

  ///
  /// is loader failed
  ///
  bool get isFailed => state is LoaderError;

  ///
  /// is loader does nothing for now
  ///
  bool get isEmpty => state is LoaderInitialized;
}
