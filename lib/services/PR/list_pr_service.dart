import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import "package:json_object/json_object.dart";
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/services/genericclient.dart';


class ListPRService {



  final Logger _log = new Logger('CreatePRService');



  Future getListOfPR(String applicationName) {
    var completer = new Completer();
    var streamedContent = '';
    GenericClient.get(STASH_API_URL+'/$applicationName/pull-requests').then((HttpClientResponse response) {
      response.transform(UTF8.decoder).listen((contents) {
        streamedContent = streamedContent + contents.toString();
      }, onDone: () {
        JsonObject result = JSON.decode(streamedContent);
        if (result["errors"] == null ) {
          completer.complete(result);
        } else {
          //er zijn errors.
          _log.severe('Error during requesting list of pull requests. Sending back information');
          completer.completeError(result);
        }
      }, onError: (e) {
        //handle error scenario
        _log.severe('Error during requesting list of pull requests. Fatal error!');
        completer.completeError(e);

      });
    });

    return completer.future;


  }



}