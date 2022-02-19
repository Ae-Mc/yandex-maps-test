import 'package:auto_route/auto_route.dart';
import 'package:yandex_maps_test/features/map/presentation/pages/filter_page.dart';
import 'package:yandex_maps_test/features/map/presentation/pages/map_page.dart';
import 'package:yandex_maps_test/features/map/presentation/pages/place_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(page: FilterPage),
    AutoRoute(page: MapPage, initial: true),
    AutoRoute(page: PlacePage),
  ],
)
class $AppRouter {}
