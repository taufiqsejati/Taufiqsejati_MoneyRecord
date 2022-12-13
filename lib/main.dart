import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/presentation/page/home_page.dart';
import 'package:money_record/presentation/page/login_page.dart';

import 'data/model/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('id_ID').then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
            primaryColor: AppColor.primary,
            appBarTheme: const AppBarTheme(
                foregroundColor: Colors.white,
                backgroundColor: AppColor.primary),
            colorScheme: const ColorScheme.light(
                primary: AppColor.primary, secondary: AppColor.secondary)),
        home: FutureBuilder(
            future: Session.getUser(),
            builder: (context, AsyncSnapshot<User> snapshot) {
              if (snapshot.data != null && snapshot.data?.idUser != null) {
                return const HomePage();
              }
              return const LoginPage();
            }));
  }
}