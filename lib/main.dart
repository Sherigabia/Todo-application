import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:todo_app/home_view.dart';

void main() {
  runApp(
      DevicePreview(enabled: kDebugMode, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Todo App',
      theme: ThemeData(
          primaryColor: const Color.fromRGBO(37, 43, 103, 1.0),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromRGBO(37, 43, 103, 1.0),
            elevation: 0,
          )),
      home: const HomeView(),
    );
  }
}
