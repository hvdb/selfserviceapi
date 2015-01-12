
# > docker build -t selfservice_api .
# > docker run -p 8889:9090 -d selfservice_api

FROM google/dart:1.6.0
MAINTAINER Henk vd Brink <hendrik.van.den.brink@ing.nl>

RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl python build-essential git ca-certificates
RUN mkdir /nodejs && curl http://nodejs.org/dist/v0.10.30/node-v0.10.30-linux-x64.tar.gz | tar xvzf - -C /nodejs --strip-components=1

ENV PATH $PATH:/nodejs/bin


ADD pubspec.yaml  /container/pubspec.yaml
ADD pubspec.lock  /container/pubspec.lock
ADD lib         /container/lib
ADD web          /container/web
ADD setup        /container/setup
ADD works        /container/works

#Link the private npm generator module.
#WORKDIR /container/setup/generator-submodule
#RUN npm link

WORKDIR /container

#Install dependencies.
RUN pub get

#RUN npm install -g yo


EXPOSE 9090

WORKDIR /container
ENTRYPOINT ["dart"]

CMD ["web/main.dart","--stash-ip", "192.168.59.103"]