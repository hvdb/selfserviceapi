import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import "package:json_object/json_object.dart";
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/services/genericclient.dart';


class MergePRService {


  final Logger _log = new Logger('MergePRService');

//FIXME make error handling uniform. give back only one error message in one format.
  Future handleMergePullRequestFuture(String applicationName, String prId, req, String version) {
    var completer = new Completer();

    Future mergePullRequest = _mergePullRequest(applicationName, prId, version);

    mergePullRequest.then((JsonObject jsonObject) {
      completer.complete(jsonObject);
    }).catchError((JsonObject jsonObject) {
      GenericClient.addCorsHeaders(req);
      req.response.statusCode = HttpStatus.NOT_FOUND;
      req.response.write(JSON.encode(jsonObject));
      req.response.close();
      completer.isCompleted;

    });

    return completer.future;

  }


  Future _mergePullRequest(String applicationName, String prId, String version) {
    var completer = new Completer();
    var streamedContent = '';
    GenericClient.post(STASH_API_URL + '/$applicationName/pull-requests/$prId/merge?version=$version', {
        "version" : version
    }).then((HttpClientResponse response) {
      response.transform(UTF8.decoder).listen((contents) {
        streamedContent = streamedContent + contents.toString();
      }, onDone: () {
        JsonObject result = JSON.decode(streamedContent);
        if (result["errors"] == null && result["state"] == "MERGED") {
          completer.complete(result);
        } else {
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