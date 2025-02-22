FROM node:16-alpine AS front

RUN apk update
RUN apk add git
RUN git clone https://github.com/YouROK/TorrServer.git
RUN cd ./TorrServer/web \
	&& yarn install \
	&& yarn run build

FROM alpine:latest AS builder

COPY --from=front ./TorrServer ./

RUN apk add --update g++ go

RUN go run gen_web.go \
	&& cd server \
	&& go mod tidy \
	&& go clean -i -r -cache \
	&& go build -ldflags '-w -s' --o "torrserver" ./cmd 

FROM debian:buster-slim AS compressed

COPY --from=builder ./server/torrserver ./torrserver

RUN apt-get update && apt-get install -y upx-ucl && upx --best --lzma ./torrserver

FROM alpine:latest

ENV TS_CONF_PATH="/opt/ts/config"
ENV TS_LOG_PATH="/opt/ts/log"
ENV TS_TORR_DIR="/opt/ts/torrents"
ENV TS_PORT=8090
ENV GODEBUG=madvdontneed=1

COPY --from=compressed ./torrserver /usr/bin/torrserver
COPY --from=builder ./docker-entrypoint.sh /docker-entrypoint.sh

RUN apk add --no-cache --update ffmpeg

CMD /docker-entrypoint.sh
