library selfservice_build_stash;

import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';

import 'package:self_service_api/config/urls.dart';
import "package:json_object/json_object.dart";
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/services/genericclient.dart';
import 'package:self_service_api/services/database/mongodb.dart';
import 'package:self_service_api/config/urls.dart';



class StashRepoChanged {
  Urls urls = new Urls();


  var fakeObject = '{"repository":{"slug":"iridium-parent","id":11,"name":"iridium-parent","scmId":"git","state":"AVAILABLE","statusMessage":"Available","forkable":true,"project":{"key":"IR","id":21,"name":"Iridium","public":false,"type":"NORMAL","isPersonal":false},"public":false},"refChanges":[{"refId":"refs/heads/master","fromHash":"2c847c4e9c2421d038fff26ba82bc859ae6ebe20","toHash":"f259e9032cdeb1e28d073e8a79a1fd6f9587f233","type":"UPDATE"}]}';

  handleRepoChange(req) {
    var changedRepo = JSON.decode(fakeObject);

    MongoDb db = new MongoDb();

    JsonObject changedRepoInformation = new JsonObject();
    changedRepoInformation.applicationId = changedRepo['repository']['project']['key'];
    changedRepoInformation.frontend = true;
    changedRepoInformation.triggerdFromBranch = changedRepo['refChanges'][0]['refId'];
    changedRepoInformation.commitHash =changedRepo['refChanges'][0]['toHash'];

    //Check for which environment (develop/test/acc/prd) if no match assume develop.
//Get branch config for project.
    //Check if the current triggerd branch is one of them, if use the configured dependencies for that env.
   //if not, use develop


    //Generate buildnumber
    String now = new DateTime.now().millisecondsSinceEpoch.toString();
    String buildIndicator = '${changedRepoInformation.applicationId}_${changedRepoInformation.commitHash}_$now';

    //Make bower.json

    //Insert into db build information. New build ID and bower.json.
    //Trigger jenkins With buildnumber, jenkins calls selfservice to get bower.json.

    //Trigger jenkins to build.
    String streamedContent ='';
    GenericClient.post('http://192.168.59.103:8080/job/build-angular-project/buildWithParameters?buildIndicator=$buildIndicator', '').then((HttpClientResponse response) {
      response.transform(UTF8.decoder).listen((contents) {
        streamedContent = streamedContent + contents.toString();
      }, onDone: () {
        print('succes! $streamedContent');
      }, onError: (e) {
        print('eRROR! $e, $streamedContent' );

      });
    });

   req.response.close();

  }

  buildInformation(req) {
    var buildIndicator =  urls.buildInformation.parse(req.uri.path)[0];

    print('request bower.json for $buildIndicator');


    var bowerJson = {
        "name": "$buildIndicator",
        "version": "0.0.1",
        "dependencies": {

        }};

    req.response.write(JSON.encode(bowerJson));
    req.response.close();



  }


  _retrieveAllApplicationsForEnv(String environment) {




  }

}
