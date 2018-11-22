FROM node:alpine
MAINTAINER Carlos Nunez <dev@carlosnunez.me>

RUN npm install --global authenticator-cli
ENTRYPOINT [ "authenticator" ]
