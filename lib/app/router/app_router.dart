import 'package:auto_route/auto_route.dart';
import 'package:yandex_maps_test/features/map/presentation/pages/map_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(page: MapPage, initial: true),
  ],
)
class $AppRouter {}
