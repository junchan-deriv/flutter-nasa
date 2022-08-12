# Flutter Nasa Besquare

Developers:

- Ngeo Jia Jun [@junchan-deriv](https://github.com/junchan-deriv/) [@ngeojiajun](https://github.com/ngeojiajun)
- Dharisini Kanesamoorthy [@Dharisini](https://github.com/Dharisini)
- Lashweenraj Ravinthiran [@Lashween28](https://github.com/Lashween28)

# Features

- Displaying Rovers

  - In order to shape the image with some shadow 'bordered_image' was declared at widgets.

- From each rovers, the details and 5 randomly generated pictures are displayed
- The last page consists of a search function based on "Sol" and "cameras"
  - there is an increment and decrement function at the Sol button to increase or decrease the value
  - the property is made seperately at the widget section as number_picker.dart

# Screenshots

<img src="https://github.com/junchan-deriv/flutter-nasa/blob/master/screenshots/screen_1.png?raw=true" height="200">
<img src="https://github.com/junchan-deriv/flutter-nasa/blob/master/screenshots/screen_1.2.png?raw=true" height="200">
<img src="https://github.com/junchan-deriv/flutter-nasa/blob/master/screenshots/screen_2.png?raw=true" height="200">
<img src="https://github.com/junchan-deriv/flutter-nasa/blob/master/screenshots/screen_2.5.png?raw=true" height="200">
<img src="https://github.com/junchan-deriv/flutter-nasa/blob/master/screenshots/screen_3.png?raw=true" height="200">
<img src="https://github.com/junchan-deriv/flutter-nasa/blob/master/screenshots/tablet-main.png?raw=true" height="200">
<img src="https://github.com/junchan-deriv/flutter-nasa/blob/master/screenshots/tablet-discover.png?raw=true" height="200">

# Tablet View Internals

## Trigger

The trigger is installed at the `RoverPage` constructor which will detect the viewport information as shown as below

```dart
    ....
    Size size = MediaQuery.of(context).size;
    bool mobile = size.longestSide == size.height;
    return Scaffold(
      body: mobile
          ? const RoverPageBody(rovers: rovers)
          : MasterDetailRenderer(
              master: const RoverPageBody(
                rovers: rovers,
              ),
              detail: (_) => const DetailsPage(
                    rover: "curiosity",
                  )),
    );
```

## Navigation

When the tablet view is in use, the need to override the default navigation behavior arise. To deal with that, the fact from `BuildContext` that holds the reference to the instances and state of the parent widgets was used.

Here is how the state is organized

```dart
class _MasterDetailRendererState extends State<MasterDetailRenderer> {
  List<Widget> details = [];
  @override
  void initState() {
    super.initState();
    details.add(widget.detail(context));
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: widget.master),
      Expanded(
        flex: 2,
        child: Stack(children: [...details]),
      )
    ]);
  }

  void pushDetail(DetailPageBuilder detail) {
    setState(() {
      details.add(detail(context));
    });
  }

  void popDetail() {
    setState(() {
      details.removeLast();
    });
  }

  void pushDetailAsRoot(DetailPageBuilder detail) {
    setState(() {
      details = [detail(context)];
    });
  }
}
```

The function of the states is exposed to the rest of the codebase through some static functions. One of them is shown as below:

```dart
bool pushDetailToTabletView(BuildContext context, DetailPageBuilder detail) {
  _MasterDetailRendererState? state =
      context.findAncestorStateOfType<_MasterDetailRendererState>();
  if (state == null) {
    return false;
  } else {
    state.pushDetail(detail);
    return true;
  }
}
```

All the functions will return a boolean to determine weather the tablet view renderer performed the action. This allow for the conditional use of the `Navigator` functions which will cause the entire UI to be replaced. An example of its usage is shown as below:

```dart
if (pushDetailToTabletView(context,
    ((context) => DiscoveryPage(
        rover: rover, manifest: roverInfo)))) {
    return;
}
//we are not in tablet view, just use the normal navigator
Navigator.of(context).push(
      PageTransition(
        child: DiscoveryPage(
        rover: rover, manifest: roverInfo),
        type: PageTransitionType.rightToLeft,
        childCurrent: this,
        duration: const Duration(milliseconds: 200),
      ),
);
```

# Cubit Internals

All cubits used in this application are just for loading the stuffs. But it is a bad practise to duplicate the same stuffs so some OOP approaches is used

## Backgrounds

Loader cubits typically have the following base states:

- Initialized
  - The cubit is just created and does not performing any loading nor holding any data
- Loading
  - The cubit is actively loading something
- Loaded
  - The data is loaded and ready for use
- Failed / Error
  - The loading is failed

## Approach taken

Since those states are shared across the cubits, it has been decided to make a base class for the loaders then extends thoses to share the common functions. But there is a problem that those loaders return the different the data. In order to deal with it, the [generic](#generic-basics) is used to allow the dynamic type resolution.

With that in mind, it is defined as below

```dart
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
  final Object error;
  LoaderError({required this.error, super.tag = ""});
}
```

## The base class

```dart
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
```

The entire idea is take the `Future<T>` and then dispatch the states appropriately.

## Example of the subclass

```dart
class NasaManifestLoaderCubit extends LoaderCubitBase<NasaRoverManifest> {
  void fetchNasaRoverManifest(String roverName) {
    //alias to internal call
    loadStuffsInternal(NasaService.getRoverManifest(roverName), roverName);
  }
}
```

# Generic basics

Some informations for beginners.

A easy way to understand generic is the variable for types. It allows the type to be specified by users as long it fulfill certain condition set by the author.

Naive example for adding numbers without worrying its the type:

```dart
T addSomething <T>(T n1,T n2){
    return (n1+n2) as T;
}
```

When `T` is `int` then the entire function will be resolved as

```dart
int addSomething(int n1, int n2)
```

But when it is puted into the compiler, it threw the error:

```
The + operator is not defined for Object
```

Why? The dart compiler compiles the function assuming the `T` is `Object` as it is not constrainted and attempts to resolve the `Object + Object` expression which is undefined.

To solve this we can add an constraint where the T must be the valid subclass of the `num` so the error is went away as below

```dart
T addSomething <T extends num>(T n1,T n2){
    return (n1+n2) as T;
}
```
