FROM golang:1.17-alpine
LABEL maintainer="Carlos Nunez <dev@carlosnunez.me>"
RUN apk update
RUN apk add git
RUN go install "github.com/momaek/authy@v0.1.7"
ENTRYPOINT [ "authy" ]
