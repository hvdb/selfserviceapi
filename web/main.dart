import 'dart:io';
import '../lib/services/server.dart';
import '../packages/logging/logging.dart';



void main() {
  print('main start');
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((LogRecord r) { print(r.message); });
  Server server = new Server();
  server.start();


}