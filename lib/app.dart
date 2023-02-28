import 'package:flutter/material.dart';
// 3行目のコメントがないと4行目で~が出る
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'importer.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // 13~17行目 flutter_screenutil
    return ScreenUtilInit(
      // iPhone 13 Pro（390.0 x 844.0）
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      // 19~21行目 go_router
      builder: (context, child) => MaterialApp.router(
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        // ライト用テーマ
        theme: LightTheme().themeData(context),
        // ダーク用テーマ
        darkTheme: DarkTheme().themeData(context),
        debugShowCheckedModeBanner: false,
        // 30~38行目 localization
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ja'),
        ],
      ),
    );
  }
}
