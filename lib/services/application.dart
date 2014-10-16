library selfservice_services_application;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';

import 'package:self_service_api/config/urls.dart';

import 'package:self_service_api/config/urls.dart';
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/services/genericclient.dart';
import 'package:self_service_api/services/PR/check_pr_service.dart';
import 'package:self_service_api/services/PR/merge_pr_service.dart';
import 'package:self_service_api/services/PR/create_pr_service.dart';
import 'package:self_service_api/services/PR/list_pr_service.dart';

import "package:json_object/json_object.dart";


class Application {
  Urls urls = new Urls();

  final Logger _log = new Logger('Aapplication');

  final CheckPRService checkPRService = new CheckPRService();
  final MergePRService mergePRService = new MergePRService();
  final CreatePRService createPRService = new CreatePRService();
  final ListPRService listPRService = new ListPRService();

  mergeBranche(req) {
    var applicationName =  urls.applicationMergeEnv.parse(req.uri.path)[0];

    var requestContentStream;
    req.listen((List<int> buffer) {
      requestContentStream = new String.fromCharCodes(buffer);
    }, onDone: () {
      _handleMergeBranch(JSON.decode(requestContentStream), applicationName, req);
    });

  }

  _handleMergeBranch(var requestContent, String applicationName, req) {
    _log.fine('mergin branches.');

    String from = requestContent["from"];
    String to = requestContent["to"];
    //construct pullrequest class

    var prRequest = new JsonObject();

    prRequest.title = 'Merge from $from to $to';
    prRequest.state = 'OPEN';
    prRequest.open = true;
    prRequest.fromRef = new JsonObject();
    prRequest.fromRef.id = 'refs/heads/$from';
    prRequest.fromRef.repository = new JsonObject();
    prRequest.fromRef.repository.project = new JsonObject();
    prRequest.fromRef.repository.slug = applicationName;
    prRequest.fromRef.repository.project.key = 'AN';
    prRequest.toRef = new JsonObject();
    prRequest.toRef.repository = new JsonObject();
    prRequest.toRef.repository.project = new JsonObject();
    prRequest.toRef.id = 'refs/heads/$to';
    prRequest.toRef.repository.slug = applicationName;
    prRequest.toRef.repository.project.key = 'AN';



    Future createPullRequestDone = createPRService.handlePullRequestFuture(prRequest, applicationName, req);

    JsonObject createPRResponse;
    createPullRequestDone.then((JsonObject jsonObject) {
      createPRResponse = jsonObject;
      Future checkPullRequestDone = checkPRService.handleCheckPullRequestFuture(applicationName, jsonObject["id"], req);

      checkPullRequestDone.then((JsonObject jsonObject) {
        Future mergePullRequest = mergePRService.handleMergePullRequestFuture(applicationName, createPRResponse["id"], req, createPRResponse["version"]);

        mergePullRequest.then((JsonObject jsonObject){
          //Everything went ok. Write json object and send back.
          //All exceptions are handled in the corresponding exception catch.
          req.response.write(JSON.encode(jsonObject));
          req.response.close();
        });

      });

    });

  }



  /**
   * Get the application details.
   *
   * Enrich with own settings.
   */

  get(req) {
    var applicationId =  urls.applicationDetailsUrl.parse(req.uri.path)[0];
    GenericClient.getSingleRepo('$STASH_API_URL/$applicationId', req);
  }



  getListOfPullRequests(req) {
  var applicationId =  urls.applicationPullRequests.parse(req.uri.path)[0];

  Future listOfPr = listPRService.getListOfPR(applicationId);
  listOfPr.then((JsonObject jsonObject){
    if (jsonObject['values'].isEmpty) {
      req.response.statusCode = HttpStatus.NOT_FOUND;
      req.response.close();
    } else {

      //Everything went ok. Write json object and send back.
      //All exceptions are handled in the corresponding exception catch.
      req.response.write(JSON.encode(jsonObject));
      req.response.close();
    }
  }).catchError((e){
    req.response.statusCode = HttpStatus.SERVICE_UNAVAILABLE;
    req.response.close();
  });


}


  postBranchConfiguration(req) {
    var requestContentStream;
    req.listen((List<int> buffer) {
      requestContentStream = new String.fromCharCodes(buffer);
    }, onDone: () {
      print('received: $requestContentStream');
      //TODO save to db.
      req.response.close();
    });

  }

  getBranchConfiguration(req) {
    var applicationId =  urls.applicationBranchConfig.parse(req.uri.path)[0];
//TODO read from db.
    JsonObject branchConfig = new JsonObject();
    branchConfig.applicationId ='pDemo';
    branchConfig.develop = 'develop';
    branchConfig.test = 'master';
    branchConfig.acceptatie = 'release-a';
    branchConfig.productie = 'release-prd';

    req.response.write(JSON.encode(branchConfig));
    req.response.close();

  }




}
