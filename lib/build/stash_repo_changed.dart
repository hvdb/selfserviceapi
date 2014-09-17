library selfservice_build_stash;

import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';

import 'package:self_service_api/config/urls.dart';
import "package:json_object/json_object.dart";
import 'package:self_service_api/config/gitconfig.dart';
import 'package:self_service_api/services/genericclient.dart';


class StashRepoChanged {


  var fakeObject = '{"repository":{"slug":"iridium-parent","id":11,"name":"iridium-parent","scmId":"git","state":"AVAILABLE","statusMessage":"Available","forkable":true,"project":{"key":"IR","id":21,"name":"Iridium","public":false,"type":"NORMAL","isPersonal":false},"public":false},"refChanges":[{"refId":"refs/heads/master","fromHash":"2c847c4e9c2421d038fff26ba82bc859ae6ebe20","toHash":"f259e9032cdeb1e28d073e8a79a1fd6f9587f233","type":"UPDATE"}]}';

  handleRepoChange(req) {
    var changedRepo = JSON.decode(fakeObject);
    print('print $changedRepo');










    req.response.write('hallo!');
    req.response.close();

  }


  _retrieveAllApplicationsForEnv(String environment) {




  }

}
