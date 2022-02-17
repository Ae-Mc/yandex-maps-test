import 'package:flutter/material.dart';
import 'package:yandex_maps_test/app/theme/bloc/app_theme.dart';
import 'package:yandex_maps_test/features/map/presentation/widgets/yandex_maps_widget.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: YandexMapsWidget(),
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
