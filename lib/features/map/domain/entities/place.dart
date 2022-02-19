import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
part 'place.freezed.dart';

@freezed
class Place with _$Place {
  const factory Place({
    required String name,
    required Point point,
    required PlaceType type,
  }) = _Place;
}

enum PlaceType { left, right }
