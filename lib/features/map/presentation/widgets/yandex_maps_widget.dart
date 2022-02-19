import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_maps_test/app/router/app_router.gr.dart';
import 'package:yandex_maps_test/features/map/domain/entities/place.dart';
import 'package:yandex_maps_test/features/map/presentation/util/map_clusters_builder.dart';
import 'package:yandex_maps_test/features/map/presentation/util/map_marks_builder.dart';

part 'yandex_maps_widget.freezed.dart';

class YandexMapsWidget extends StatefulWidget {
  final List<Place> places;

  const YandexMapsWidget({Key? key, required this.places}) : super(key: key);

  @override
  State<YandexMapsWidget> createState() => _YandexMapsWidgetState();
}

@freezed
class RadiusPerZoomLevel with _$RadiusPerZoomLevel {
  const factory RadiusPerZoomLevel({
    required double radius,
    required double zoom,
  }) = _RadiusPerZoomLevel;
}

class _YandexMapsWidgetState extends State<YandexMapsWidget> {
  late YandexMapController mapController;
  late final MapClustersBuilder clustersBuilder;
  late MapMarksBuilder marksBuilder;
  static const List<RadiusPerZoomLevel> zoomLevels = [
    RadiusPerZoomLevel(radius: 45, zoom: 3),
    RadiusPerZoomLevel(radius: 22.5, zoom: 5),
    RadiusPerZoomLevel(radius: 15.25, zoom: 10),
    RadiusPerZoomLevel(radius: 0, zoom: 200),
  ];
  var activeLevel = zoomLevels[0];
  List<MapObject> mapObjects = [];

  @override
  void initState() {
    clustersBuilder = MapClustersBuilder(
      places: UnmodifiableListView(widget.places),
      levels: UnmodifiableListView(zoomLevels),
    );
    clustersBuilder.calculateClusters();
    marksBuilder = MapMarksBuilder(context);
    updateMapObjects();
    super.initState();
  }

  @override
  void didUpdateWidget(YandexMapsWidget oldWidget) {
    if (oldWidget.places != widget.places) {
      setState(() {
        clustersBuilder.setPlaces(widget.places);
        clustersBuilder.calculateClusters();
        updateMapObjects();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return YandexMap(
      logoAlignment: const MapAlignment(
        horizontal: HorizontalAlignment.left,
        vertical: VerticalAlignment.bottom,
      ),
      onMapCreated: (controller) => mapController = controller,
      mapObjects: mapObjects,
      onCameraPositionChanged: (position, reason, __) async {
        final level = getLevelFromZoom(position.zoom);
        if (level != activeLevel) {
          activeLevel = level;
          await updateMapObjects();
          setState(() => {});
        }
      },
    );
  }

  static RadiusPerZoomLevel getLevelFromZoom(double zoom) {
    for (final level in zoomLevels) {
      if (zoom < level.zoom) {
        return level;
      }
    }
    throw RangeError('Uncovered zoom level: $zoom');
  }

  Future<void> updateMapObjects() async {
    final collections = clustersBuilder.getCollectionsOnLevel(activeLevel);
    int clusterId = 0;
    int placeId = 0;
    mapObjects = [];
    for (final collection in collections) {
      mapObjects.add((collection.length == 1)
          ? Placemark(
              mapId: MapObjectId('placemark_${placeId++}'),
              point: collection[0].point,
              onTap: (_, __) {
                GetIt.I<AppRouter>().push(PlaceRoute(place: collection[0]));
              },
              opacity: 1,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromBytes(
                    await marksBuilder.buildPlacemarkImage(
                      await getImageFromUrl(
                        'https://ae-mc.ru/files/images/linux.png',
                      ),
                    ),
                  ),
                ),
              ),
            )
          : collectionToClusterizedPlacemarkCollection(
              'cluster_${clusterId++}',
              collection,
            ) as MapObject);
    }
  }

  Future<ui.ImageDescriptor> getImageFromUrl(String url) async {
    final response = await Dio().get<Uint8List>(url,
        options: Options(responseType: ResponseType.bytes));
    return ui.ImageDescriptor.encoded(
      await ui.ImmutableBuffer.fromUint8List(
        response.data!,
      ),
    );
  }

  ClusterizedPlacemarkCollection collectionToClusterizedPlacemarkCollection(
    String clusterId,
    List<Place> collection,
  ) {
    return ClusterizedPlacemarkCollection(
      mapId: MapObjectId(clusterId),
      onClusterAdded:
          (ClusterizedPlacemarkCollection self, Cluster cluster) async {
        return cluster.copyWith(
          appearance: cluster.appearance.copyWith(
            opacity: 1,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromBytes(
                  await marksBuilder.buildClusterApperance(cluster.size),
                ),
                scale: 1,
              ),
            ),
          ),
        );
      },
      onClusterTap: zoomToCluster,
      placemarks: collection
          .mapIndexed((index, element) => Placemark(
                mapId: MapObjectId('${clusterId}_placemark_$index'),
                point: element.point,
                isVisible: false,
              ))
          .toList(),
      radius: 1000,
      minZoom: 200,
    );
  }

  void zoomToCluster(
    ClusterizedPlacemarkCollection placemarkCollection,
    Cluster cluster,
  ) {
    final List<double> latitudes = cluster.placemarks
        .map((e) => e.point.latitude)
        .toSet()
        .sorted((a, b) => a.compareTo(b));
    final List<double> longitudes = cluster.placemarks
        .map((e) => e.point.longitude)
        .toSet()
        .sorted((a, b) => a.compareTo(b));
    final northEast = Point(
      latitude: latitudes.first,
      longitude: longitudes.first,
    );
    final southWest = Point(
      latitude: latitudes.last,
      longitude: longitudes.last,
    );

    mapController.moveCamera(
      CameraUpdate.newBounds(
        BoundingBox(northEast: northEast, southWest: southWest),
      ),
      animation: const MapAnimation(duration: 1),
    );
  }
}
