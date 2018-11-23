FROM node:alpine
MAINTAINER Carlos Nunez <dev@carlosnunez.me>

RUN apk add --no-cache python make
USER node
RUN mkdir /home/node/.npm-global
ENV PATH=/home/node/.npm-global/bin:$PATH
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
RUN npm install --global authy-client
ENTRYPOINT [ "authy" ]
