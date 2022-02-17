import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:yandex_maps_test/app/app.dart';
import 'package:yandex_maps_test/main.config.dart';

@InjectableInit()
configureDependencies() => $initGetIt(GetIt.I);

void main() {
  configureDependencies();
  runApp(const App());
}
