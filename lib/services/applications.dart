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
;
    Process.run('git', ['clone', 'ssh://git@stash.europe.intranet:7999/an/spectingular-modules.git']).then((_) =>
    Process.run('cd', ['spectingular-modules']).then((_) =>
    Process.run('git', ['checkout', 'selfservice'])));

    new File('spectingular-modules/bower.json').readAsString().then((String contents) {
      var jsoncontent = JSON.decode(contents);
      var applicationName = jsonObject["name"];
      var sshUrl;
      if (jsonObject["links"]["clone"][0]["name"] == 'ssh') {
        sshUrl = jsonObject["links"]["clone"][0]["href"];
      } else {
        sshUrl = jsonObject["links"]["clone"][1]["href"];
      }

      jsoncontent["dependencies"][applicationName] = sshUrl;


      new File('spectingular-modules/bower.json').writeAsString(JSON.encode(jsoncontent)).then((File file) {

        Process.run('git',['commit', '-a','-m', '"Added new module '+applicationName+ '"']).then((_) =>
        Process.run('git',['push', 'origin', 'selfservice']));


      });


      Process.run('rm', ['-rf', 'spectingular-modules']);


    });



    //git clone
    //Process.run('git clone ', ['-l']).then((ProcessResult results) {
    //  print(results.stdout);
    //});


    //read file, add new line.
    //git commit
    //git push
    //remove dir

    GenericClient.addCorsHeaders(req);

    //req.response.write(JSON.encode(data));
    req.response.close();

  }


  optionsOk(req) {
    GenericClient.addCorsHeaders(req);

    req.response.close();
  }


// get all the applications
  get(req) {
    GenericClient.getlistOfRepos(GitConfig.stashApiUrl, req);

  }

}
