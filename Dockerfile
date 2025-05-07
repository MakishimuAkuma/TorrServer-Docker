FROM alpine:latest

ENV TS_CONF_PATH="/opt/ts/config"
ENV TS_LOG_PATH="/opt/ts/log"
ENV TS_TORR_DIR="/opt/ts/torrents"
ENV TS_PORT=8090
ENV GODEBUG=madvdontneed=1

RUN case "$TARGETPLATFORM" in \
        "linux/386") wget -O "/usr/bin/torrserver" "https://github.com/YouROK/TorrServer/releases/download/MatriX.135/TorrServer-linux-386" ;; \
        "linux/amd64") wget -O "/usr/bin/torrserver" "https://github.com/YouROK/TorrServer/releases/download/MatriX.135/TorrServer-linux-amd64" ;; \
        "linux/arm/v6") wget -O "/usr/bin/torrserver" "https://github.com/YouROK/TorrServer/releases/download/MatriX.135/TorrServer-linux-arm5" ;; \
        "linux/arm/v7") wget -O "/usr/bin/torrserver" "https://github.com/YouROK/TorrServer/releases/download/MatriX.135/TorrServer-linux-arm7" ;; \
        "linux/arm64/v8") wget -O "/usr/bin/torrserver" "https://github.com/YouROK/TorrServer/releases/download/MatriX.135/TorrServer-linux-arm64" ;; \
        "linux/riscv64") wget -O "/usr/bin/torrserver" "https://github.com/YouROK/TorrServer/releases/download/MatriX.135/TorrServer-linux-riscv64" ;; \
    esac
ADD "https://github.com/YouROK/TorrServer/blob/master/docker-entrypoint.sh" "/docker-entrypoint.sh"

RUN chmod +x "/usr/bin/torrserver"
RUN chmod +x "/docker-entrypoint.sh"

RUN apk add --no-cache --update ffmpeg

ENTRYPOINT [ "/docker-entrypoint.sh" ]
