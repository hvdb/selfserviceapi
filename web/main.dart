import 'dart:io';
import '../lib/services/server.dart';
import '../packages/logging/logging.dart';
import 'package:args/args.dart';



void main(List<String> arguments) {

  String stashIp;
  final parser = new ArgParser();
  parser.addOption('stash-ip');

  ArgResults results = parser.parse(arguments);

  stashIp =results["stash-ip"];

  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((LogRecord r) { print(r.message); });
  Server server = new Server();
  server.start(stashIp);


}


void _stashIp(String value) {
  print("myflag1: $value");
}