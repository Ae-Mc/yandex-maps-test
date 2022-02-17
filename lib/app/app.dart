import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:yandex_maps_test/app/router/app_router.gr.dart';
import 'package:yandex_maps_test/app/theme/bloc/app_theme.dart';
import 'package:yandex_maps_test/app/theme/bloc/app_theme_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appRouter = GetIt.I<AppRouter>();

    return BlocProvider(
      create: (context) => AppThemeBloc(),
      child: Builder(builder: (context) {
        return MaterialApp.router(
          routeInformationParser: appRouter.defaultRouteParser(),
          routerDelegate: appRouter.delegate(),
          title: 'Test Yandex Maps',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: TextTheme(
              bodyText1: AppTheme.of(context).textTheme.body1Regular,
            ),
            fontFamily: AppTheme.of(context).textTheme.fontFamily,
          ),
        );
      }),
    );
  }
}
