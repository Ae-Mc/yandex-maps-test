import 'package:injectable/injectable.dart';
import 'package:yandex_maps_test/app/router/app_router.gr.dart';

@module
abstract class RouterModule {
  @singleton
  AppRouter appRouter() => AppRouter();
}
