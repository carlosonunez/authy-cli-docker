FROM node:alpine
MAINTAINER Carlos Nunez <dev@carlosnunez.me>

RUN npm install --global authy-client
ENTRYPOINT [ "authy" ]
