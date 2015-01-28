//checkout generator module.
//npm link
import 'package:logging/logging.dart';
import 'dart:io';
import 'dart:convert';


final Logger log = new Logger('setup');

void main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) {
    print(r.message);
  });


// _runProcess('remove dir setup', 'rm', ['-rf', 'setup']);


//  _runProcess('mkdir setup', 'mkdir', ['setup']);


//Checkout generator.
//  _runProcess('Checkout generator', 'git', ['clone', 'http://admin:admin@192.168.59.103:7990/scm/an/generator-submodule.git'],workingDir :'setup');

  //Make docker
  _runProcess('Docker build', 'docker', [ 'build', '-t', 'selfservice_api', '.']);


//Later:
//Make spectingular-modules.

}

_runProcess(String process, String processCommand, List<String> processCommandAttributes,{ String workingDir: null}) {
  log.fine('Running $process');
  ProcessResult res = Process.runSync(processCommand, processCommandAttributes, workingDirectory: workingDir);
  log.fine('$process results');
  log.fine(res.stdout);


  if (res.exitCode != 0) {
    log.severe('$process failed. Build aborted. See sterr:');
    log.severe(res.stderr);

    throw new Exception('$process failed.');
  }
}
