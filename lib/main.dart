 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_service/core/values/list_bloc_provider.dart';
import 'package:social_service/core/values/theme.dart';
import 'package:social_service/firebase_options.dart';
import 'package:social_service/presentasion/pages/splash/splash_screen.dart';
import 'package:social_service/repositories/database/database_repository.dart';
import 'package:social_service/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DatabaseRepository>(
          create: (context) => DatabaseRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: listBlocProvider,
        child: MaterialApp(
          title: 'Social Service',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
