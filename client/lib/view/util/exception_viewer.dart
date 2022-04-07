import 'package:flutter/material.dart';

class ExceptionViewer extends StatelessWidget {
  final Object? exception;

  const ExceptionViewer(this.exception, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Image.asset('assets/danielsad.png'),
        ),
        const SizedBox(width: 8),
        SelectableText(exception.toString(),
          style: const TextStyle(
            color: Colors.redAccent
          ),
        )
      ],
    );
  }
}
