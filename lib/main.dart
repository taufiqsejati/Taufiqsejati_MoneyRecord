import 'package:money_record/library/library.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: AppColor.primary, // Color for Android
      systemNavigationBarColor: Colors.white, // Color for Android
      statusBarIconBrightness: Brightness.light, //status barIcon Brightness
      statusBarBrightness:
          Brightness.dark // Dark == white status bar -- for IOS.
      ));
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
