#Install dependencies.
Pub get

#Start server.
dart web/main.dart --stash-ip 10.0.0.1


#create docker image.
docker build -t selfservice_api .
(This uses the boot2docker ip for connecting to stash. please change this ip if needed)


#Stash is needed.
Make sure you also start a stash container.
docker pull mechatoni/stash

install it via the setup (get license etc)
Clone the spectingular-modules. (or run script to import it)

> TODO make a protractor script for this.


docker run -p 8889:9090 -d selfservice_api


#How to run the complete application.

Make sure the generator-submodue is in setup directory.

Start stash. docker pull mechatoni/stash
docker run -d  -p 7990:7990 -p 7999:7999 mechatoni/stash

Run the installation wizard.
Add project: Angular (AN)

Import spectingular-modules. (git clone change remote ip and push)

Start this container. (api)

Start selfservice. (see other project.)


start jenkins container if wanted:
docker run -d -p 8080:8080 jenkins

add job: build-angular-project 
parameterized build: buildIndicator

jenkins config:

This gets the bower.json
curl --request get 'http://192.168.59.103:8889/build/information/'${buildIndicator}


MongoDB

docker run -d -p 27017:27017 -p 28017:28017 -e MONGODB_PASS="mypass" tutum/mongodb


Connect to mongodb.
mongo --host 192.168.59.103

use admin

db.auth("admin", "mypass")

use build


db.addUser({user: "test", pwd: "test"})



[ ![Codeship Status for hvdb/selfserviceapi](https://www.codeship.io/projects/0fadcc10-fa43-0131-9eeb-3aac33d676db/status)](https://www.codeship.io/projects/29031)