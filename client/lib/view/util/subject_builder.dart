import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../view_model.dart';

class SubjectBuilder<T> extends StatelessWidget {
  
  final BehaviorSubject<T> Function(ViewModel) subject;
  final AsyncWidgetBuilder<T> builder;

  const SubjectBuilder({Key? key, required this.subject, required this.builder})
      : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final subject = this.subject.call(ViewModel.of(context));
    return StreamBuilder(
      initialData: subject.valueOrNull,
      stream: subject,
      builder: builder,
    );
  }
}
