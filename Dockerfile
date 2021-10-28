FROM golang:1.17-alpine
LABEL maintainer="Carlos Nunez <dev@carlosnunez.me>"
RUN go install github.com/momaek/authy@latest
ENTRYPOINT [ "authy" ]
