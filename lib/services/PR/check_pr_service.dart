import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import "package:json_object/json_object.dart";
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/services/genericclient.dart';




class CheckPRService {


  final Logger _log = new Logger('CheckPRService');


  //FIXME make error handling uniform. give back only one error message in one format.
  Future handleCheckPullRequestFuture(String applicationName, String prId, req) {
    var completer = new Completer();

    Future mergePullRequest = _handleCheckPullRequest(applicationName, prId);

    mergePullRequest.then((JsonObject jsonObject){
      print('jsonObject $jsonObject');
      completer.complete(jsonObject);
    }).catchError((JsonObject jsonObject){
      print('errorHandlepullre CHECK $jsonObject');
      GenericClient.addCorsHeaders(req);
      req.response.statusCode = HttpStatus.NOT_FOUND;
      req.response.write(JSON.encode(jsonObject));
      req.response.close();
      completer.isCompleted;

    });

    return completer.future;

  }




  Future _handleCheckPullRequest(String applicationName, String prId) {
    var completer = new Completer();
    var streamedContent = '';
    GenericClient.get(STASH_API_URL+'/$applicationName/pull-requests/$prId/merge').then((HttpClientResponse response) {
      response.transform(UTF8.decoder).listen((contents) {
        streamedContent = streamedContent + contents.toString();
      }, onDone: () {
        JsonObject result = JSON.decode(streamedContent);
        if (result["errors"] == null && result["canMerge"] == true) {
          completer.complete(result);
        } else {
          //er zijn errors.
          _log.severe('Error during checking pull request. Sending back information');
          completer.completeError(result);
        }
      }, onError: (e) {
        //handle error scenario
        _log.severe('Error during checking pull request. Fatal error!');
        completer.completeError(e);

      });
    });

    return completer.future;
  }




}