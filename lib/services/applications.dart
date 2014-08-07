library selfservice_services_git;

import 'dart:io';
import 'dart:convert';
import '../config/urls.dart';
import "package:json_object/json_object.dart";
import '../providers/gitrepo.dart';

class Applications {


  createNew(req) {

    var gitRepoInstance = '1';
    var gitRepoName ='gApplicatieNaam';

    //Call stash maak een nieuwe repo aan.
    GitRepo.createRepo(gitRepoInstance, gitRepoName);


    //voeg applicatie toe aan spectingular-modules (database opzetten met daarin de modules?)

    //git clone
    //Process.run('git clone ', ['-l']).then((ProcessResult results) {
    //  print(results.stdout);
    //});


    //read file, add new line.
    //git commit
    //git push
    //remove dir




  }


// get all the applications
  get(req) {


    var data = new List();

    var application = new JsonObject();


    HttpClient client = new HttpClient();
    client.getUrl(Uri.parse("http://stash.europe.intranet/rest/api/1.0/projects/AN/repos"))
        .then((HttpClientRequest request) {
          // Optionally set up headers...
          // Optionally write to the request object...
          // Then call close.

        return request.close();
      })
      .then((HttpClientResponse response) {
      // Process the response.
          print(reponse);
      });




    var gitConfiguration = new JsonObject();
    gitConfiguration.repoInstance = 'stash';
    gitConfiguration.repoUrl = 'http://stash.europe.intranet/';

    application.id = 1;
    application.name = 'pManagePaymentAccountsWA';
    application.gitConfiguration = gitConfiguration;
    data.add(application);
    application.id = 2;

    data.add(application);
    application.id = 3;
    data.add(application);
    application.id = 4;
    data.add(application);
    application.id = 5;
    data.add(application);
    application.id = 6;
    data.add(application);

    addCorsHeaders(req);

    req.response.write(JSON.encode(data));
    req.response.close();
  }


  addCorsHeaders(req) {
    req.response.headers.add("Access-Control-Allow-Methods", "POST, OPTIONS, GET");
    req.response.headers.add("Access-Control-Allow-Origin", "*");
    req.response.headers.add('Access-Control-Allow-Headers', '*');

  }


}
