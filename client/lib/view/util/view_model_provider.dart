import 'package:flutter/material.dart';

import '../../view_model.dart';

class ViewModelProvider extends InheritedWidget {
  final ViewModel viewModel;

  const ViewModelProvider(this.viewModel, {Key? key, required Widget child})
      : super(key: key, child: child);

  static ViewModelProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ViewModelProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is! ViewModelProvider ||
        !identical(oldWidget.viewModel, viewModel);
  }
}
