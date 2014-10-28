import 'dart:io';
import 'dart:convert';
import '../lib/services/server.dart';
import '../packages/logging/logging.dart';
import 'package:args/args.dart';



void main(List<String> arguments) {

  var settings = JSON.decode(new File('settings.json').readAsStringSync());
  String stashIp = settings["stashIp"];
//
//  String stashIp;
//  final parser = new ArgParser();
//  parser.addOption('stash-ip');
//
//  ArgResults results = parser.parse(arguments);
//
//  stashIp =results["stash-ip"];

  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) { print(r.message); });
  Server server = new Server();
  server.start(stashIp);


}


void _stashIp(String value) {
  print("myflag1: $value");
}