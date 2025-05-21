FROM alpine:latest

ENV TS_CONF_PATH="/opt/ts/config"
ENV TS_LOG_PATH="/opt/ts/log"
ENV TS_TORR_DIR="/opt/ts/torrents"
ENV TS_PORT=8090

RUN touch "/usr/bin/torrserver"

RUN case "$TARGETPLATFORM" in \
        "linux/386") curl "https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-386" >> "/usr/bin/torrserver" ;; \
        "linux/amd64") curl "https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-amd64" >> "/usr/bin/torrserver" ;; \
        "linux/arm/v6") curl "https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-arm5" >> "/usr/bin/torrserver" ;; \
        "linux/arm/v7") curl "https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-arm7" >> "/usr/bin/torrserver" ;; \
        "linux/arm64/v8") curl "https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-arm64" >> "/usr/bin/torrserver" ;; \
        "linux/riscv64") curl "https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-riscv64" >> "/usr/bin/torrserver" ;; \
    esac
	
ADD "https://raw.githubusercontent.com/YouROK/TorrServer/refs/heads/master/docker-entrypoint.sh" "/docker-entrypoint.sh"

RUN chmod +x "/usr/bin/torrserver"
RUN chmod +x "/docker-entrypoint.sh"

RUN apk add --no-cache --update ffmpeg

ENTRYPOINT [ "/docker-entrypoint.sh" ]
