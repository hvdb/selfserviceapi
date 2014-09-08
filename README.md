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





[ ![Codeship Status for hvdb/selfserviceapi](https://www.codeship.io/projects/0fadcc10-fa43-0131-9eeb-3aac33d676db/status)](https://www.codeship.io/projects/29031)