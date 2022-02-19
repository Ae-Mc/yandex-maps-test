import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_maps_test/features/map/domain/entities/place.dart';
import 'package:yandex_maps_test/features/map/presentation/widgets/yandex_maps_widget.dart';

class MapClustersBuilder {
  UnmodifiableListView<Place> places;
  final UnmodifiableListView<RadiusPerZoomLevel> levels;
  Map<RadiusPerZoomLevel, List<List<Place>>> clustersPerLevel = {};

  MapClustersBuilder({
    required this.places,
    required this.levels,
  });

  void setPlaces(List<Place> places) {
    this.places = UnmodifiableListView(places);
  }

  void calculateClusters() {
    for (final level in levels) {
      clustersPerLevel[level] = _getClustersForLevel(level);
    }
  }

  List<List<Place>> _getClustersForLevel(RadiusPerZoomLevel level) {
    final placesCopy = places.map((e) => e.copyWith()).toList();
    List<List<Place>> collections = [];
    for (int i = 0; i < placesCopy.length; i++) {
      final referencePlace = placesCopy[i];
      final collection = [referencePlace];
      for (int j = i + 1; j < placesCopy.length; j++) {
        if (inRadius(referencePlace.point, placesCopy[j].point, level.radius)) {
          collection.add(placesCopy.removeAt(j));
          j--;
        }
      }
      collections.add(collection);
    }
    return collections;
  }

  List<List<Place>> getCollectionsOnLevel(RadiusPerZoomLevel level) {
    if (clustersPerLevel.containsKey(level)) {
      return clustersPerLevel[level]!;
    }
    throw RangeError(
      "Level $level not passed into constructor or places aren't calculated",
    );
  }

  static bool inRadius(Point a, Point b, double radius) {
    return pow(a.latitude - b.latitude, 2) + pow(a.longitude - b.longitude, 2) <
        pow(radius, 2);
  }
}
