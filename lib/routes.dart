import 'package:flutter/material.dart';
import 'package:gps_routes/theme.dart';
import 'package:sizer/sizer.dart';
import 'views/Components/bottom_nav_bar.dart';

class Routes extends StatelessWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GPS',
          theme: theme(),
          initialRoute: BottomNavBar.routeName,
          routes: {BottomNavBar.routeName: (context) => const BottomNavBar()},
        );
      },
    );
  }
}
