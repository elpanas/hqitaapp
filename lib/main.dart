import 'package:flutter/material.dart'
    show
        BuildContext,
        MaterialApp,
        StatelessWidget,
        Widget,
        WidgetsFlutterBinding,
        runApp;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hqitaapp/models/hive_model.dart';
import 'package:hqitaapp/providers/hqplayer_provider.dart';
import 'package:hqitaapp/providers/fav_provider.dart';
import 'package:hqitaapp/providers/fire_provider.dart';
import 'package:hqitaapp/providers/http_provider.dart';
import 'package:hqitaapp/constants.dart' show kDarkTheme, kListLocales;
import 'package:hqitaapp/views/fav_list.dart';
import 'package:hqitaapp/views/home.dart';
import 'package:hqitaapp/views/login.dart';
import 'package:hqitaapp/views/player_list.dart';
import 'package:hqitaapp/views/player_page.dart';
import 'package:hqitaapp/views/registration.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  Hive.registerAdapter(LocalPlayerAdapter());
  await Hive.initFlutter();
  await Hive.openBox('favourites');
  //await Hive.deleteBoxFromDisk('favourites');
  runApp(
    EasyLocalization(
      supportedLocales: kListLocales,
      path: 'assets/translations',
      fallbackLocale: kListLocales[0], // default locale (en, US)
      child: MyApp(),
    ),
  );
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HQPlayerProvider()),
        ChangeNotifierProxyProvider<HQPlayerProvider, FireProvider>(
          create: (_) => FireProvider(null),
          update: (_, hqplayerP, __) => FireProvider(hqplayerP),
        ),
        ChangeNotifierProxyProvider<HQPlayerProvider, HttpProvider>(
          create: (_) => HttpProvider(null),
          update: (_, hqplayerP, __) => HttpProvider(hqplayerP),
        ),
        ChangeNotifierProxyProvider<HQPlayerProvider, FavProvider>(
          create: (_) => FavProvider(null),
          update: (_, hqplayerP, __) => FavProvider(hqplayerP),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'HQ Player Finder',
            theme: kDarkTheme,
            initialRoute: HomePage.id,
            routes: {
              HomePage.id: (context) => HomePage(),
              PlayerListPage.id: (context) => PlayerListPage(),
              PlayerPage.id: (context) => PlayerPage(),
              RegistrationPage.id: (context) => RegistrationPage(),
              LoginPage.id: (context) => LoginPage(),
              FavListPage.id: (context) => FavListPage(),
            },
          );
        },
      ),
    );
  }
}
