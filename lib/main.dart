import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/route_generator.dart';
import 'package:movie_db/services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      useInheritedMediaQuery: false,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      title: 'Movie DB',
      navigatorKey: navigationService.navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
