import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_maps_test/app/router/app_router.gr.dart';
import 'package:yandex_maps_test/app/theme/bloc/app_theme.dart';
import 'package:yandex_maps_test/features/map/domain/entities/place.dart';
import 'package:yandex_maps_test/features/map/presentation/widgets/yandex_maps_widget.dart';

part 'map_page.freezed.dart';

class MapPage extends StatefulWidget {
  static const places = [
    Place(
      name: 'Одно место',
      point: Point(latitude: 59.958246, longitude: 30.295324),
      type: PlaceType.left,
    ),
    Place(
      name: 'Другое место',
      point: Point(latitude: 59.558246, longitude: 30.295324),
      type: PlaceType.left,
    ),
    Place(
      name: 'Третье место',
      point: Point(latitude: 59.558246, longitude: 60.295324),
      type: PlaceType.right,
    ),
    Place(
      name: 'Четвёртое место',
      point: Point(latitude: 59.558246, longitude: 60.695324),
      type: PlaceType.right,
    ),
  ];

  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

@freezed
class Filter with _$Filter {
  const factory Filter({PlaceType? placeType}) = _Filter;
}

class _MapPageState extends State<MapPage> {
  Filter filter = const Filter();
  List<Place> places = MapPage.places;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            YandexMapsWidget(places: places),
            Positioned(
              right: 16,
              top: 16,
              child: FloatingActionButton(
                onPressed: () async {
                  final result = await GetIt.I<AppRouter>()
                      .push(FilterRoute(filter: filter));
                  if (result != null && result is Filter) {
                    setState(() {
                      filter = result;
                      places = MapPage.places.where(
                        (element) {
                          return filter.placeType != null
                              ? element.type == filter.placeType
                              : true;
                        },
                      ).toList();
                    });
                  }
                },
                child: const Icon(Icons.filter_list),
                backgroundColor: AppTheme.of(context).colorTheme.primary,
                foregroundColor: AppTheme.of(context).colorTheme.onPrimary,
                mini: true,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppTheme.of(context).colorTheme.primary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: AppTheme.of(context).colorTheme.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Меню'),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_rounded),
            label: 'Платежи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Я в помощь',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
