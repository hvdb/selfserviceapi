class ApplicationObject {

  String name, commitHash;
  List<Contributer> contributers;
}

class BuildConfig {
  //Ie develop
  String name;
  //List of application objects for that env.
  List<ApplicationObject> applications;
}

class BuildResult {

  String buildIdentifier;
  Object buildResult;
  bool success;

}

class Contributer {
  String name;
  String corpKey;
}

class UnitTestFailure {

}

class End2EndTestFailure {

}