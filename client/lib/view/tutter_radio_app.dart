import 'package:flutter/material.dart';
import 'package:tutter_radio/view/theme.dart';

import '../view_model.dart';
import 'home_page.dart';
import 'util/view_model_provider.dart';

class TutterRadioApp extends StatelessWidget {
  final ViewModel viewModel;

  const TutterRadioApp({Key? key, required this.viewModel}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(viewModel,
        child: MaterialApp(
          debugShowCheckedModeBanner: true,
          title: 'Tutter radio',
          theme: themeData.copyWith(
            appBarTheme: const AppBarTheme(
              color: menuColor,
            ),
            checkboxTheme: themeData.checkboxTheme.copyWith(
              fillColor: MaterialStateProperty.all(tutterColor),
              checkColor: MaterialStateProperty.all(menuColor),
            ),
            dialogTheme: const DialogTheme(
                backgroundColor: backgroundColor
            ),
            listTileTheme: const ListTileThemeData(
              selectedColor: tutterColor,
            ),
            sliderTheme: SliderThemeData(
              thumbColor: tutterColor,
              activeTrackColor: tutterColor,
              inactiveTrackColor: tutterColor.withOpacity(0.3),
              valueIndicatorColor: menuColor,
              overlayColor: tutterColor.withOpacity(0.2),

            ),
            drawerTheme: const DrawerThemeData(
              backgroundColor: menuColor
            ),
          ),
          //home: const MyHomePage(),
          initialRoute: '/radio',
          routes: {
            '/radio': (context) => const MyHomePage()
          },
        )
    );
  }
}