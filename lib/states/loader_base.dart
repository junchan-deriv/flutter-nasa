import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///
///Base class for loader
///

abstract class LoaderState<T> {
  final dynamic tag;
  LoaderState({this.tag = ""});
}

///
/// The loader is initialized but do not load anything
///
class LoaderInitialized<T> extends LoaderState<T> {}

///
/// The loader is loading something
///
class Loading<T> extends LoaderState<T> {
  Loading({super.tag = ""});
}

///
/// The loader is loaded something
///
class Loaded<T> extends LoaderState<T> {
  ///
  /// Loaded data
  ///
  final T loaded;
  Loaded({required this.loaded, super.tag = ""});
}

///
/// Loader failed
///
class LoaderError<T> extends LoaderState<T> {
  final Error error;
  LoaderError({required this.error, super.tag = ""});
}

///
///Base class for the loader
///
abstract class LoaderCubitBase<T> extends Cubit<LoaderState<T>> {
  LoaderCubitBase() : super(LoaderInitialized<T>());
  @protected
  void loadStuffsInternal(Future<T> f, dynamic tag) {
    emit(Loading<T>(tag: tag));
    f.then((data) {
      emit(Loaded(loaded: data, tag: tag));
    }, onError: (error) {
      emit(LoaderError(error: error, tag: tag));
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

  ///
  /// is the loader loaded
  ///
  bool get isLoaded => state is Loaded<T>;
}
