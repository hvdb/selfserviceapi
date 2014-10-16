library selfservice_services_git;

import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';

import 'package:self_service_api/config/urls.dart';
import "package:json_object/json_object.dart";
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/services/genericclient.dart';


class Applications {

  final Logger log = new Logger('Aapplications');

  createNew(req) {

    log.fine('creating new application');

    var _jsonResponseFromStash;

    var requestContent;
    req.listen((List<int> buffer) {
      requestContent = new String.fromCharCodes(buffer);
    }, onDone: () {

      var jsonObject = JSON.decode(requestContent);
      var streamedContent = '';

      var applicationName = jsonObject["name"];
      var repoAdmin = jsonObject["repoAdmin"];

      var encodedJson = JSON.encode({"name":applicationName, "scmId":"git", "forkable":true});
      GenericClient.post(STASH_API_URL, encodedJson).then((HttpClientResponse response) {
        response.transform(UTF8.decoder).listen((contents) {
          streamedContent = streamedContent + contents.toString();
        }, onDone: () => _setRepoAdmin(repoAdmin, req, applicationName, streamedContent ));

      });

    });

  }

  _setRepoAdmin(String repoAdmin, req, String applicationName, streamedContent) {

    log.fine('Setting repo admin $repoAdmin for $applicationName');

    String url = STASH_API_URL + '/$applicationName/permissions/users?name=$repoAdmin&permission=REPO_ADMIN';
    String obj = JSON.encode({"name": repoAdmin, "permission":"Admin"});

    bool error = false;

    GenericClient.put(url, obj).then((HttpClientResponse response) {
      response.transform(UTF8.decoder).listen((contents) {
        var res = JSON.decode(contents);
        if (res["errors"] != null) {
          for (var error in res["errors"]) {
            log.severe('ERROR! Setting the repoadmin did not go well. $res');
            error = true;
            if (error["message"].contains('No such users')) {
              req.response.statusCode = HttpStatus.EXPECTATION_FAILED;
              log.severe('repoadmin is unknow $repoAdmin');
            } else {
              req.response.statusCode = HttpStatus.NOT_FOUND;
            }
          }
        }

      }, onDone: () => _handleStashRepoCreation(JSON.decode(streamedContent), req, error));

    });

  }




  _handleStashRepoCreation(jsonObject,req, bool previousEventError) {

    bool result = true;
    bool error = false;

    if (jsonObject["errors"] != null ) {
      req.response.statusCode = HttpStatus.CONFLICT;
      error = true;
    } else if(previousEventError) {
      error = true;
    }


    if (!error) {
      log.fine('handling creation of stash repo.');
      var _workingDir = 'works/spectingular-modules';


      result = _runProcess('git',['clone', '$STASH_SSH_URL/an/spectingular-modules.git'] , 'works/', result);
      result = _runProcess('git',['checkout', 'master'], _workingDir, result);
      result = _runProcess('git',['reset', '--hard'], _workingDir, result);

      var spectingularModulesJson = JSON.decode(new File('$_workingDir/bower.json').readAsStringSync());
      var applicationName = jsonObject["name"];

      String sshUrl;
      if (jsonObject["links"]["clone"][0]["name"] == 'ssh') {
        sshUrl = jsonObject["links"]["clone"][0]["href"];
      } else {
        sshUrl = jsonObject["links"]["clone"][1]["href"];
      }

      spectingularModulesJson["dependencies"][applicationName] = sshUrl;

      new File('$_workingDir/bower.json').writeAsStringSync(JSON.encode(spectingularModulesJson));

      result = _runProcess('git', ['commit', '-a', '-m', 'Added new module $applicationName' ], _workingDir, result);

      result = _runProcess('git', ['push', 'origin', 'master'], _workingDir, result);

      result = _initializeGitModule(applicationName, sshUrl, result);

      result = _makeAndAddBranch('develop', applicationName, result);
      result = _makeAndAddBranch('release-a', applicationName,result);
      result = _makeAndAddBranch('release-prd', applicationName, result);

      result = _generateModuleAndPush(applicationName, result);
      result = _runProcess('rm',['-rf', 'spectingular-modules'], 'works/', result);

      log.fine('Done! result is $result');
}

    if (!result) {
      req.response.statusCode = HttpStatus.NOT_FOUND;
    }

    req.response.close();

  }

  /**
   * Run a process using the [processCommand] as the function and the [processCommandAttributes] as the arguments.
   * And use the [workingDir] as workingdirectory.
   * But first evaluate the [result] to see if there was not problem in a previous process.
   *
   * returns the bool of the result. (if exitcode != 0 = false)
   */
  _runProcess(String processCommand, List<String> processCommandAttributes, String workingDir, bool result) {
    log.finer('running process $processCommand');
    if (result) {
      ProcessResult res = Process.runSync(processCommand, processCommandAttributes, workingDirectory: workingDir);
      print('stdout');
      print(res.stdout);
      if (res.exitCode != 0) {
        print(res.stderr);
        print('error during the following Process');
        print('run process $processCommand');
        print('run attr $processCommandAttributes');

        _runProcess('rm',['-rf', 'spectingular-modules'], 'works/', result);

      }
      return res.exitCode == 0 ;

    }
    return result;
  }


  bool _generateModuleAndPush(String applicationName, bool result) {

    result = _runProcess('git' ,['checkout', 'develop'],  'works/$applicationName', result);

    result = _runProcess('yo' ,['-no-insight','submodule','$applicationName'],  'works/$applicationName', result);

    result = _runProcess('git' ,['add', '--all'],  'works/$applicationName', result);
    result = _runProcess('git' ,['commit', '-m', 'First develop commit, Added skeleton app'],  'works/$applicationName', result);
    result = _runProcess('git' ,['push','-u', 'origin', 'develop'],  'works/$applicationName', result);

    result = _runProcess('rm', ['-rf', '$applicationName'],  'works/', result);
    return result;
  }

  bool _initializeGitModule(String applicationName, String sshUrl,  bool result) {

    //Initialize the git repo for the application
    result = _runProcess('mkdir' ,['-m', '777','$applicationName'],  'works', result);

    result = _runProcess('git' ,['init'],  'works/$applicationName', result);
    //result = _runProcess('git' ,['remote', 'add', 'origin', sshUrl],  'works/$applicationName', result);
    result = _runProcess('git', ['remote', 'add', 'origin', '$STASH_SSH_URL/an/$applicationName.git'],  'works/$applicationName', result);

    new File('works/$applicationName/created').writeAsStringSync("Created by Are you being served?");

    result = _runProcess('git' ,['add', '.'],  'works/$applicationName', result);
    result = _runProcess('git' ,['commit', '-m', 'First commit, added branches'],  'works/$applicationName', result);

    result = _runProcess('git' ,['push','-u', 'origin', 'master'],  'works/$applicationName', result);

    return result;
  }



  bool _makeAndAddBranch(String branch, String applicationName, bool result) {

    result = _runProcess('git' ,['checkout', '-b', '$branch'],  'works/$applicationName', result);
    result = _runProcess('git' ,['push','-u', 'origin', '$branch'],  'works/$applicationName', result);
    return result;

  }


  optionsOk(req) {
    req.response.close();
  }



// get all the applications
  get(req) {
    var requestContent;
    req.listen((List<int> buffer) {
      requestContent = new String.fromCharCodes(buffer);
    }, onDone: () {

      var url;

      if (requestContent != null) {
       url = STASH_API_URL;
      } else {
        url =STASH_API_URL + '?' +req.uri.query;
      }

      GenericClient.getlistOfRepos(url, req);

    });

  }

}
