FROM node:16-alpine AS front

RUN git clone https://github.com/YouROK/TorrServer.git
RUN cd ./web
RUN yarn install
RUN yarn run build

FROM --platform=$BUILDPLATFORM golang:1.21.2-alpine AS builder

COPY --from=front ./ ./

RUN cd /opt/src

RUN apk add --update g++
RUN go run gen_web.go
RUN cd server
RUN go mod tidy
RUN go clean -i -r -cache
RUN go build -ldflags '-w -s' --o "torrserver" ./cmd 

FROM debian:buster-slim AS compressed

COPY --from=builder /opt/src/server/torrserver ./torrserver

RUN apt-get update && apt-get install -y upx-ucl && upx --best --lzma ./torrserver

FROM alpine

ENV TS_CONF_PATH="/opt/ts/config"
ENV TS_LOG_PATH="/opt/ts/log"
ENV TS_TORR_DIR="/opt/ts/torrents"
ENV TS_PORT=8090
ENV GODEBUG=madvdontneed=1

COPY --from=compressed ./torrserver /usr/bin/torrserver
COPY --from=front ./docker-entrypoint.sh /docker-entrypoint.sh

RUN apk add --no-cache --update ffmpeg

CMD /docker-entrypoint.sh
