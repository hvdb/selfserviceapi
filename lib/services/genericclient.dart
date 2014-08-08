import 'dart:io';
import 'dart:convert';
import "package:json_object/json_object.dart";
class GenericClient {


  static get(url, req) {

    HttpClient client = new HttpClient();
    return client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
      return request.close();
    });
  }


 static addCorsHeaders(req) {
    req.response.headers.add("Access-Control-Allow-Methods", "POST, OPTIONS, GET");
    req.response.headers.add("Access-Control-Allow-Origin", "*");
    req.response.headers.add('Access-Control-Allow-Headers', '*');

  }


static getlistOfRepos(url, req) {

  var data = new List();
  get(url,req).then((HttpClientResponse response) {
    response.transform(UTF8.decoder).listen((contents) {


      Map obj = JSON.decode(contents);

      List responseApps = obj["values"];

      for (var app in responseApps) {
        data.add(makeApplication(app));
      }
      addCorsHeaders(req);

      req.response.write(JSON.encode(data));
      req.response.close();
    });
    });
}


  static getSingleRepo(url, req) {
var content = get(url,req);

get(url,req).then((HttpClientResponse response) {
  response.transform(UTF8.decoder).listen((contents) {

    var data = makeApplication(JSON.decode(contents));

    addCorsHeaders(req);

    req.response.write(JSON.encode(data));
    req.response.close();

  });

});



  }

  static makeApplication(app) {

    var application = new JsonObject();
    var gitConfiguration = new JsonObject();
    application.id = app["id"];
    application.name = app["name"];
    application.type = app["name"].substring(0,1);

    gitConfiguration.repoInstance = 'stash';
    gitConfiguration.repoUrl = app["links"]["clone"][0]["href"];
    gitConfiguration.browseUrl = app["links"]["self"][0]["href"];
    application.gitConfiguration = gitConfiguration;

    return application;
  }


}
