library selfservice_services_git;

import 'dart:io';
import 'dart:convert';
import '../config/urls.dart';
import "package:json_object/json_object.dart";
import '../providers/gitrepo.dart';
import '../config/gitconfig.dart';
import 'genericclient.dart';


class Applications {


  createNew(req) {

    var _jsonResponseFromStash;

    var requestContent;
    req.listen((List<int> buffer) {
      requestContent = new String.fromCharCodes(buffer);
    }, onDone: () {

      //Call stash maak een nieuwe repo aan.
      var stashUrl = GitConfig.stashApiUrl;

      var jsonObject = JSON.encode(JSON.decode(requestContent));

      var streamedContent = '';

      GenericClient.post(stashUrl, jsonObject).then((HttpClientResponse response) {
        response.transform(UTF8.decoder).listen((contents) {
          streamedContent = streamedContent + contents.toString();

        }, onDone: () => _handleStashRepoCreation(JSON.decode(streamedContent), req));

      });

    });


  }


  _handleStashRepoCreation(jsonObject,req) {
    GenericClient.addCorsHeaders(req);

    if (jsonObject["errors"] != null) {
      req.response.statusCode = HttpStatus.CONFLICT;

    } else {

      var _workingDir = 'works/spectingular-modules';
      Process.runSync('rm', ['-rf', 'spectingular-modules'], workingDirectory: 'works/');
      Process.runSync('git', ['clone', 'ssh://git@stash.europe.intranet:7999/an/spectingular-modules.git'], workingDirectory: 'works/');
      Process.runSync('git', ['checkout', 'selfservice'], workingDirectory: _workingDir);
      Process.runSync('git', ['reset', '--hard'], workingDirectory: _workingDir);

      var jsonContent = JSON.decode(new File(_workingDir + '/bower.json').readAsStringSync());
      var applicationName = jsonObject["name"];

      var sshUrl;
      if (jsonObject["links"]["clone"][0]["name"] == 'ssh') {
        sshUrl = jsonObject["links"]["clone"][0]["href"];
      } else {
        sshUrl = jsonObject["links"]["clone"][1]["href"];
      }

      jsonContent["dependencies"][applicationName] = sshUrl;

      new File(_workingDir + '/bower.json').writeAsStringSync(JSON.encode(jsonContent));

      Process.runSync('git', ['commit', '-a', '-m', 'Added new module ' + applicationName], workingDirectory: _workingDir);
      Process.runSync('git', ['push', 'origin', 'selfservice'], workingDirectory: _workingDir);

    }



    req.response.close();

  }

  optionsOk(req) {
    GenericClient.addCorsHeaders(req);

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
       url = GitConfig.stashApiUrl;
      } else {
        url =GitConfig.stashApiUrl + '?' +req.uri.query;
      }

      GenericClient.getlistOfRepos(url, req);

    });

  }

}
