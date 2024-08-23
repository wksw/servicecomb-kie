FROM golang:1.18.10 as build

WORKDIR /go/src/github.com/apache/servicecomb-kie

COPY ./ /go/src/github.com/apache/servicecomb-kie/

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build --ldflags "-s -w" -o kie ./cmd/kieserver


FROM golang:alpine
# FROM alpine:latest

WORKDIR /opt/servicecomb-kie

RUN mkdir -p /opt/servicecomb-kie/conf
# RUN mkdir /lib64 &&  ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

COPY --from=build /go/src/github.com/apache/servicecomb-kie/kie /opt/servicecomb-kie/kie
COPY ./scripts/start.sh /opt/servicecomb-kie/
COPY ./examples/dev/conf/microservice.yaml /opt/servicecomb-kie/conf/


ENTRYPOINT ["/opt/servicecomb-kie/start.sh"]
