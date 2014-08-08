library selfservice_services_git;

import 'dart:io';
import 'dart:convert';
import '../config/urls.dart';
import "package:json_object/json_object.dart";
import '../providers/gitrepo.dart';
import '../config/gitconfig.dart';
import 'genericclient.dart';


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


    GenericClient.getlistOfRepos(GitConfig.stashApiUrl, req);



  }

}
