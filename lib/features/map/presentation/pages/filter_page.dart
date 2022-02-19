import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:yandex_maps_test/app/router/app_router.gr.dart';
import 'package:yandex_maps_test/app/theme/bloc/app_theme.dart';
import 'package:yandex_maps_test/features/map/domain/entities/place.dart';
import 'package:yandex_maps_test/features/map/presentation/pages/map_page.dart';

class FilterPage extends StatefulWidget {
  final Filter filter;

  const FilterPage({Key? key, required this.filter}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

enum FilterPlaceType { none, left, right }

class _FilterPageState extends State<FilterPage> {
  late Filter filter;
  late FilterPlaceType placeType;

  @override
  void initState() {
    filter = widget.filter;
    switch (filter.placeType) {
      case null:
        placeType = FilterPlaceType.none;
        break;
      case PlaceType.left:
        placeType = FilterPlaceType.left;
        break;
      case PlaceType.right:
        placeType = FilterPlaceType.right;
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const Pad(all: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Фильтры',
                style: AppTheme.of(context).textTheme.headline1,
              ),
              const SizedBox(height: 16),
              Text(
                'Тип мест',
                style: AppTheme.of(context).textTheme.headline2,
              ),
              ListTile(
                title: const Text('Нет'),
                leading: Radio(
                  value: FilterPlaceType.none,
                  groupValue: placeType,
                  onChanged: (FilterPlaceType? value) =>
                      setPlaceType(FilterPlaceType.none),
                ),
                onTap: () => setPlaceType(FilterPlaceType.none),
              ),
              ListTile(
                title: const Text('Левые'),
                leading: Radio(
                  value: FilterPlaceType.left,
                  groupValue: placeType,
                  onChanged: (FilterPlaceType? value) =>
                      setPlaceType(FilterPlaceType.left),
                ),
                onTap: () => setPlaceType(FilterPlaceType.left),
              ),
              ListTile(
                title: const Text('Правые'),
                leading: Radio(
                  value: FilterPlaceType.right,
                  groupValue: placeType,
                  onChanged: (FilterPlaceType? value) =>
                      setPlaceType(FilterPlaceType.right),
                ),
                onTap: () => setPlaceType(FilterPlaceType.right),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => GetIt.I<AppRouter>().pop(filter),
                child: const Text('Ок'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      AppTheme.of(context).colorTheme.primary),
                  foregroundColor: MaterialStateProperty.all(
                      AppTheme.of(context).colorTheme.onPrimary),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setPlaceType(FilterPlaceType placeType) {
    setState(() {
      this.placeType = placeType;
    });
    switch (placeType) {
      case FilterPlaceType.none:
        filter = filter.copyWith(placeType: null);
        break;
      case FilterPlaceType.left:
        filter = filter.copyWith(placeType: PlaceType.left);
        break;
      case FilterPlaceType.right:
        filter = filter.copyWith(placeType: PlaceType.right);
        break;
    }
  }
}
