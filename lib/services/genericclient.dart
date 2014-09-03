import 'dart:io';
import 'dart:convert';
import "package:json_object/json_object.dart";
import 'package:crypto/crypto.dart';


class GenericClient {

  /**
   * Return a future for the given [url]
   *
   */
  static get(url) {

    HttpClient client = new HttpClient();
    return client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
      //temp
      var base64 = 'YWRtaW46YWRtaW4=';

      request.headers.add('Authorization', 'Basic '+base64);
      return request.close();
    });
  }


  static post(url, jsonData) {

    HttpClient client = new HttpClient();
    return client.postUrl(Uri.parse(url)).then((HttpClientRequest request) {

      //temp
      var base64 = 'YWRtaW46YWRtaW4=';

       request.headers.add('Authorization', 'Basic '+base64);
       request.headers.contentType = ContentType.JSON;
       request.write(jsonData);

      return request.close();
    });
  }


  static put(url, jsonData) {

    HttpClient client = new HttpClient();
    return client.putUrl(Uri.parse(url)).then((HttpClientRequest request) {

      //temp
      var base64 = 'YWRtaW46YWRtaW4=';

      request.headers.add('Authorization', 'Basic '+base64);
      request.headers.contentType = ContentType.JSON;
      request.write(jsonData);

      return request.close();
    });
  }





  /**
   * Add cors headers.
   */
  static addCorsHeaders(req) {
    req.response.headers.add("Access-Control-Allow-Methods", "*");
    req.response.headers.add("Access-Control-Allow-Origin", "*");
    req.response.headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");

  }


  /**
   * Get a list of modules from stash.
   *
   * [url] The url that is used to retrieve the information.
   * [req] The HttpRequest.
   */
  static getlistOfRepos(url, req) {

    get(url).then((HttpClientResponse response) {

      var streamedContent = '';
      response.transform(UTF8.decoder).listen((contents) {
          streamedContent = streamedContent + contents.toString();

      }, onDone: () => onLoadedDataListRepos(streamedContent, req));



    });
  }


  static onLoadedDataListRepos(object, req) {

    var applications = new List();

    var jsonContent = JSON.decode(object);

    for (var app in jsonContent["values"]) {
      applications.add(makeApplication(app));
    }

    addCorsHeaders(req);

    var data = new JsonObject();
    data.applications = applications;
    data.limit = jsonContent["limit"];
    data.nextPageStart = jsonContent["nextPageStart"];


    req.response.write(JSON.encode(data));
    req.response.close();

  }


  /**
   * Get the information from stash about the given repo.
   *
   * [url] The url that is used to retrieve the information.
   * [req] The HttpRequest.
   */
  static getSingleRepo(url, req) {

    get(url).then((HttpClientResponse response) {
      response.transform(UTF8.decoder).listen((contents) {

        addCorsHeaders(req);

        req.response.write(JSON.encode(makeApplication(JSON.decode(contents))));
        req.response.close();

      });

    });


  }

  /**
   * Construct the application object with the correct values.
   * [app] The json object which holds all the data.
   */
  static makeApplication(app) {

    var application = new JsonObject();
    var gitConfiguration = new JsonObject();
    application.id = app["id"];
    application.name = app["name"];
    application.type = app["name"].substring(0, 1);

    gitConfiguration.repoInstance = 'stash';
    if (app["links"]["clone"][0]["name"] == 'ssh') {
      gitConfiguration.repoUrl = app["links"]["clone"][0]["href"];
    } else {
      gitConfiguration.repoUrl = app["links"]["clone"][1]["href"];
    }


    gitConfiguration.browseUrl = app["links"]["self"][0]["href"];
    application.gitConfiguration = gitConfiguration;

    return application;
  }


}
