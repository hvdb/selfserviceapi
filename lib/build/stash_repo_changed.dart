library selfservice_build_stash;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';

import 'package:self_service_api/config/urls.dart';
import "package:json_object/json_object.dart";
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/services/genericclient.dart';
import 'package:self_service_api/services/database/mongodb.dart';
import 'package:self_service_api/config/urls.dart';
import 'package:mongo_dart/mongo_dart.dart';



class StashRepoChanged {
  Urls urls = new Urls();
  MongoDb db = new MongoDb();

  var fakeObject = '{"repository":{"slug":"iridium-parent","id":11,"name":"iridium-parent","scmId":"git","state":"AVAILABLE","statusMessage":"Available","forkable":true,"project":{"key":"IR","id":21,"name":"Iridium","public":false,"type":"NORMAL","isPersonal":false},"public":false},"refChanges":[{"refId":"refs/heads/master","fromHash":"2c847c4e9c2421d038fff26ba82bc859ae6ebe20","toHash":"f259e9032cdeb1e28d073e8a79a1fd6f9587f233","type":"UPDATE"}]}';

  handleRepoChange(req) {

    var requestContentStream;
    req.listen((List<int> buffer) {
      requestContentStream = new String.fromCharCodes(buffer);
    }, onDone: () {
      print('requestcontentstream $requestContentStream');
      var changedRepo = JSON.decode(requestContentStream);
      print('json changedRepo $changedRepo');

      JsonObject changedRepoInformation = new JsonObject();
      changedRepoInformation.applicationId = changedRepo['repository']['slug'];
      changedRepoInformation.frontend = true;
      changedRepoInformation.triggerdFromBranch = changedRepo['refChanges'][0]['refId'];
      changedRepoInformation.commitHash = changedRepo['refChanges'][0]['toHash'];
      changedRepoInformation.status = 'pending';
      //Get correct env.
      changedRepoInformation.environment = 'develop';


      //Generate buildnumber
      String now = new DateTime.now().millisecondsSinceEpoch.toString();
      changedRepoInformation.buildIndicator = '${changedRepoInformation.applicationId}_${changedRepoInformation.commitHash}_$now';

      List<Map> listChangedRepoInformaton = new List();
      listChangedRepoInformaton.add(changedRepoInformation);
      //Insert into db build information. New build ID and bower.json.
      db.insertBuildInformation(listChangedRepoInformaton);

      //Trigger jenkins to build.
      GenericClient.post('http://192.168.59.103:8080/job/build-angular-project/buildWithParameters?buildIndicator=${changedRepoInformation.buildIndicator}', '').then((HttpClientResponse response) {
        response.transform(UTF8.decoder).listen((contents) {
        }, onDone: () {
          print('succes!');
        }, onError: (e) {
          print('eRROR! $e' );

        });
      });

     req.response.close();

    });

  }

  retrieveBuildInformationWithApplicationId(req) {
    GenericClient.addCorsHeaders(req);
    var applicationId =  urls.buildInformationApplicationId.parse(req.uri.path)[0];
    Future retrieve = db.retrieveBuildInformationsWithApplicationId(applicationId);

    retrieve.then((List value) {

      req.response.write(JSON.encode(value));
      req.response.close();
    });

  }



  retrieveBuildInformationWithBuildindicator(req) {
   var buildIndicator =  urls.buildInformationBuildIndicator.parse(req.uri.path)[0];

//TODO set status to building.

    //Check for which environment (develop/test/acc/prd) if no match assume develop.
    //Get branch config for project.
    //Check if the current triggerd branch is one of them, if use the configured dependencies for that env.
    //if not, use develop
   Future retrieve = db.retrieveBuildInformationWithBuildIndicator(buildIndicator);


  retrieve.then((object) {



  //Make bower.json

  var bowerJson = {
      "name": "$buildIndicator",
      "version": "0.0.1",
      "dependencies": {

      }};

  print('after');
  GenericClient.addCorsHeaders(req);
  req.response.write(object);
  req.response.close();

});



  }


  _retrieveAllApplicationsForEnv(String environment) {




  }

}
