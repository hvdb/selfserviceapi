import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import "package:json_object/json_object.dart";
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/services/genericclient.dart';


class CreatePRService {



  final Logger _log = new Logger('CreatePRService');

//FIXME make error handling uniform. give back only one error message in one format.
  Future handlePullRequestFuture(JsonObject prRequest, String applicationName, req) {
    var completer = new Completer();
    Future createPullRequest =_createPullRequest(prRequest, applicationName);

    createPullRequest.then((JsonObject jsonObject){
      print('jsonObject $jsonObject');
      completer.complete(jsonObject);
    }).catchError((JsonObject jsonObject){
      print('error create $jsonObject');
      GenericClient.addCorsHeaders(req);
      req.response.statusCode = HttpStatus.NOT_FOUND;
      req.response.write(JSON.encode(jsonObject));
      req.response.close();
      completer.isCompleted;
    });
    return completer.future;
  }



  Future _createPullRequest(JsonObject prRequest, String applicationName) {
    var completer = new Completer();
    var streamedContent = '';
    GenericClient.post(STASH_API_URL+'/$applicationName/pull-requests', JSON.encode(prRequest)).then((HttpClientResponse response) {
      response.transform(UTF8.decoder).listen((contents) {
        streamedContent = streamedContent + contents.toString();
      }, onDone: () {
        JsonObject result = JSON.decode(streamedContent);
        if (result["errors"] == null ) {
          completer.complete(result);
        } else {
          //er zijn errors.
          _log.severe('Error during making pull request. Sending back information');
          completer.completeError(result);
        }
      }, onError: (e) {
        //handle error scenario
        _log.severe('Error during making pull request. Fatal error!');
        completer.completeError(e);

      });
    });

    return completer.future;


  }



}