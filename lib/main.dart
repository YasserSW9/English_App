import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:english_app/core/di/dependency_injection.dart';
import 'package:english_app/core/routing/approuter.dart';
import 'package:english_app/core/routing/routes.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();

  runApp(EnglishClub(appRouter: AppRouter()));
}

class EnglishClub extends StatelessWidget {
  final AppRouter appRouter;

  const EnglishClub({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.adminMainScreen,
          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}
