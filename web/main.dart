import 'dart:io';
import 'package:self_service_api/services/server.dart';
import 'package:logging/logging.dart';



void main() {
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((LogRecord r) { print(r.message); });
  Server server = new Server();
  server.start();


}