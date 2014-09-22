import "package:json_object/json_object.dart";


class CreatePRRequest extends JsonObject {
  String title, description, state;
  bool open = true;
  bool close = false;
  Ref fromRef;
  Ref toRef;

}


class Ref extends JsonObject{
  String id;
  Repository repository;
  Ref(this.id, this.repository) {}
}

class Repository extends JsonObject{
  String slug, name;
  Project project;
  Repository(this.slug, this.name, this.project) {}
}

class Project extends JsonObject{
  String key;
  Project(this.key) {}
}



