import 'package:flutter/material.dart';

class MasterDetailRenderer extends StatefulWidget {
  final Widget master;
  //
  // Default details page
  //
  final Widget detail;
  const MasterDetailRenderer(
      {Key? key, required this.master, required this.detail})
      : super(key: key);

  @override
  State<MasterDetailRenderer> createState() => _MasterDetailRendererState();
}

typedef DetailPageBuilder = Widget Function(BuildContext context);

class _MasterDetailRendererState extends State<MasterDetailRenderer> {
  List<Widget> details = [];
  @override
  void initState() {
    super.initState();
    details.add(widget.detail);
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

//Try to push to next page if the current effective view is in tablet mode
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

bool popDetailFromTabletView(BuildContext context) {
  _MasterDetailRendererState? state =
      context.findAncestorStateOfType<_MasterDetailRendererState>();
  if (state == null) {
    return false;
  } else {
    state.popDetail();
    return true;
  }
}

bool pushDetailToTabletViewAsRoot(
    BuildContext context, DetailPageBuilder detail) {
  _MasterDetailRendererState? state =
      context.findAncestorStateOfType<_MasterDetailRendererState>();
  if (state == null) {
    return false;
  } else {
    state.pushDetailAsRoot(detail);
    return true;
  }
}

bool inTabletView(BuildContext context) {
  return null != context.findAncestorStateOfType<_MasterDetailRendererState>();
}
