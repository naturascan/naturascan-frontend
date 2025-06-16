import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as loggerCustom;
import 'package:logging/logging.dart';

class Log {
  static const String _NAME = 'Logger';
  static Logger _instance = Logger(_NAME);

  static var logger = loggerCustom.Logger(
    printer: loggerCustom.PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: false),
  );

  static void init() {
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print('${record.level.name}: ${record.time}: ${record.message}');
      }
    });
    _instance = Logger(_NAME);
  }

  static void setLevel(Level level) {
    Logger.root.level = level;
  }

  static void info(message, [Object? error, StackTrace? stackTrace]) {
    _instance.info(message, error, stackTrace);
  }

  static void warning(message, [Object? error, StackTrace? stackTrace]) {
    _instance.warning(message, error, stackTrace);
  }

  static void config(message, [Object? error, StackTrace? stackTrace]) {
    _instance.config(message, error, stackTrace);
  }

  static void fine(message, [Object? error, StackTrace? stackTrace]) {
    _instance.fine(message, error, stackTrace);
  }

  static void finer(message, [Object? error, StackTrace? stackTrace]) {
    _instance.finer(message, error, stackTrace);
  }

  static void finest(message, [Object? error, StackTrace? stackTrace]) {
    _instance.finest(message, error, stackTrace);
  }

  static void severe(message, [Object? error, StackTrace? stackTrace]) {
    _instance.severe(message, error, stackTrace);
  }

  static void shout(message, [Object? error, StackTrace? stackTrace]) {
    _instance.shout(message, error, stackTrace);
  }

  static showError(message) {
    logger.e(message);
  }

  static showInfo(message) {
    logger.i(message);
  }

  static showVerbose(message) {
    logger.v(message);
  }

  static showWarning(message) {
    logger.w(message);
  }
}
