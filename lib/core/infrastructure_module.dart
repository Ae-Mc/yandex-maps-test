import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class InfrastractureModule {
  @singleton
  Logger logger() => Logger(printer: PrettyPrinter());
}
