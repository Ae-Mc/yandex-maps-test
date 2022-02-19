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

  /// [avatarImage] must has size 150x150
  Future<Uint8List> buildPlacemarkImage(ImageDescriptor avatarImage) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final imagePaint = Paint();
    canvas.drawCircle(
      const Offset(50, 50),
      50,
      Paint()..color = AppTheme.of(context).colorTheme.primary,
    );
    canvas.drawImage(
      (await (await avatarImage.instantiateCodec(
                  targetHeight: 100, targetWidth: 100))
              .getNextFrame())
          .image,
      const Offset(0, 0),
      imagePaint,
    );
    canvas.clipRRect(RRect.fromLTRBR(0, 0, 0, 0, const Radius.circular(50)));
    final image = await recorder.endRecording().toImage(100, 100);
    return (await image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
