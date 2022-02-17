import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapsWidget extends StatelessWidget {
  const YandexMapsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YandexMap(
      logoAlignment: const MapAlignment(
        horizontal: HorizontalAlignment.left,
        vertical: VerticalAlignment.bottom,
      ),
    );
  }
}
