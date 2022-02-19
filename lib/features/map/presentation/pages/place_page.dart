import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:yandex_maps_test/app/router/app_router.gr.dart';
import 'package:yandex_maps_test/app/theme/bloc/app_theme.dart';
import 'package:yandex_maps_test/features/map/domain/entities/place.dart';

class PlacePage extends StatelessWidget {
  final Place place;

  const PlacePage({Key? key, required this.place}) : super(key: key);

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
                place.name,
                style: AppTheme.of(context).textTheme.headline1,
              ),
              Text('Широта: ' + place.point.latitude.toStringAsFixed(6)),
              Text('Долгота: ' + place.point.longitude.toStringAsFixed(6)),
              const Spacer(),
              ElevatedButton(
                onPressed: () => GetIt.I<AppRouter>().pop(),
                child: Text(
                  'Назад',
                  style: AppTheme.of(context).textTheme.button,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    AppTheme.of(context).colorTheme.primary,
                  ),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
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
}
