import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/widgets.dart' hide Image;
import 'package:yandex_maps_test/app/theme/bloc/app_theme.dart';

class MapMarksBuilder {
  final BuildContext context;

  MapMarksBuilder(this.context);

  Future<Uint8List> buildClusterApperance(int clusterSize) async {
    final theme = AppTheme.of(context);
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(200, 200);
    final paint = Paint()
      ..color = theme.colorTheme.primary
      ..style = PaintingStyle.fill;
    const radius = 60.0;

    final textPainter = TextPainter(
      text: TextSpan(
        text: clusterSize.toString(),
        style: theme.textTheme.mapMarker
            .copyWith(color: theme.colorTheme.onPrimary),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width - 10);

    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    final circleCenter = Offset(size.height / 2, size.width / 2);

    canvas.drawCircle(circleCenter, radius, paint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  /// [avatarImage] must has size 200x200
  Future<Uint8List> buildPlacemarkImage(Image avatarImage) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final imagePaint = Paint();
    canvas.drawImage(avatarImage, Offset.zero, imagePaint);
    canvas.clipRRect(RRect.fromLTRBR(0, 0, 0, 0, const Radius.circular(100)));
    final image = await recorder.endRecording().toImage(200, 200);
    return (await image.toByteData())!.buffer.asUint8List();
  }
}
