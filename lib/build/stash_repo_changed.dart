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

  handleRepoChange(req) {

    var requestContentStream;
    req.listen((List<int> buffer) {
      requestContentStream = new String.fromCharCodes(buffer);
    }, onDone: () {
      var changedRepo = JSON.decode(requestContentStream);
      print('json changedRepo $changedRepo');
      JsonObject changedRepoInformation = new JsonObject();
      changedRepoInformation.applicationId = changedRepo['repository']['slug'];
      changedRepoInformation.frontend = true;
      changedRepoInformation.triggerdFromBranch = changedRepo['refChanges'][0]['refId'];
      changedRepoInformation.commitHash = changedRepo['refChanges'][0]['toHash'];
      changedRepoInformation.authorName = changedRepo['changesets']['values'][0]['toCommit']['author']['name'];
      changedRepoInformation.authorEmail = changedRepo['changesets']['values'][0]['toCommit']['author']['emailAddress'];
      changedRepoInformation.status = 'pending';

      //Get correct env.//Check for which environment (develop/test/acc/prd) if no match assume develop.
      changedRepoInformation.environment = _determineDependencyBranch(changedRepoInformation.triggerdFromBranch);


      //Generate buildnumber
      String now = new DateTime.now().millisecondsSinceEpoch.toString();
      changedRepoInformation.buildIndicator = '${changedRepoInformation.applicationId}_${changedRepoInformation.commitHash}_$now';

      Map mapChangedRepoInformation = new Map();
      mapChangedRepoInformation.addAll(changedRepoInformation);
      //Insert into db build information. New build ID and bower.json.
      db.insertBuildInformation(mapChangedRepoInformation);

      //Trigger jenkins to build.
      GenericClient.post('http://192.168.59.103:8080/job/build-angular-project/buildWithParameters?buildIndicator=${changedRepoInformation.buildIndicator}', '').then((HttpClientResponse response) {
        response.transform(UTF8.decoder).listen((contents) {
        }, onDone: () {
          print('succes!');
          req.response.close();
        }, onError: (e) {
          print('eRROR! $e' );
          req.response.close();
        });
      });


    });

  }


  String _determineDependencyBranch(String branch) {

    //retrieve dependencies.

    JsonObject branchConfig = new JsonObject();
    branchConfig.applicationId ='pDemo';
    branchConfig.develop = 'develop';
    branchConfig.test = 'master';
    branchConfig.acceptatie = 'release-a';
    branchConfig.productie = 'release-prd';

    //strip branch.
    branch = branch.substring(branch.lastIndexOf('/'));
    print('branch is $branch');
    if (branchConfig['test'] == branch) {
      return 'test';
    } else if (branchConfig['acceptatie'] == branch) {
      return 'acceptatie';
    } else if (branchConfig['productie'] == branch) {
      return 'productie';
    } else {
      return 'develop';
    }

  }


  /**
   * Retrieve the build information regarding ther applicationId given in the requested path.
   */
  retrieveBuildInformationWithApplicationId(req) {
    var applicationId =  urls.buildInformationApplicationId.parse(req.uri.path)[0];
    Future retrieve = db.retrieveBuildInformationsWithApplicationId(applicationId);
    retrieve.then((List value) {
      req.response.write(JSON.encode(value));
      req.response.close();
    });

  }



  retrieveBuildInformationWithBuildindicator(req) {
    var buildIndicator =  urls.buildInformationBuildIndicator.parse(req.uri.path)[0];
    String environmentToBuild;
    String applicationId;

    Future retrieve = db.retrieveBuildInformationWithBuildIndicator(buildIndicator);

    retrieve.then((Map object) {

      if (object != null) {
        db.updateBuildStatusInformation(buildIndicator, 'building');
        //Get branch config for project.
        Future dependencies = db.retrieveDependenciesForApplicationAndEnvironment(object['applicationId'], object['environment']);
        dependencies.then((Map object) {
          if (object != null) {
            //Make bower.json
            var bowerJson = {
                "name": "$applicationId", "version": "0.0.1", "dependencies": object["dependencies"]
            };
            req.response.write(JSON.encode(bowerJson));
            req.response.close();
          } else {
            req.response.statusCode = HttpStatus.NOT_FOUND;
            req.response.close();
          }
        });
      } else {
        req.response.statusCode = HttpStatus.NOT_FOUND;
        req.response.close();

      }

    });
  }



//
//  Map depen = new Map();
//
//  JsonObject dependency = new JsonObject();
//  dependency.applicationId = applicationId;
//  dependency.environment = environmentToBuild;
//
//  Map listOfDependencies = new Map();
//  listOfDependencies['spectingular-core'] = 'http://stash.europe.intranet/an/bladiebla.git';
//  listOfDependencies['spectingular-comp'] = 'http://stash.europe.intranet/an/comp.git';
//  listOfDependencies['angular-core'] = 'http://stash.europe.intranet/an/bladiebla.git';
//  listOfDependencies['angular-1'] = 'http://stash.europe.intranet/an/bladiebla1.git';
//  listOfDependencies['spectingular-2'] = 'http://stash.europe.intranet/an/bladiebla2.git';
//  listOfDependencies['spectingular-3'] = 'http://stash.europe.intranet/an/bladiebla3.git';
//  dependency.dependencies = listOfDependencies;
//
//  depen.addAll(dependency);
//
//
////db.insertDependencies(depen);



}

