# syntax=docker/dockerfile:1

ARG ALPINE_JRE_TAG=17.0.15_6-jre-alpine
ARG ALPINE_JDK_TAG=17.0.15_6-jdk-alpine
ARG UBUNTU_JRE_TAG=17.0.15_6-jre-noble
ARG UBUNTU_JDK_TAG=17.0.15_6-jdk-noble

ARG UID=14285
ARG GID=14285

FROM alpine:3.21.3 AS downloader

ARG UID
ARG GID

WORKDIR /opt

# Download Open Integration Engine release
RUN apk add --no-cache curl \
    && curl -L \
      -o /opt/engine.tar.gz \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://github.com/OpenIntegrationEngine/engine/releases/download/v4.5.2-tp.1/oie_unix_4_5_2.tar.gz \
    && tar xzf engine.tar.gz \
    && mv /opt/oie /opt/engine \
    && mkdir -p /opt/engine/appdata

WORKDIR /opt/engine
COPY --chmod=755 ./entrypoint.sh /opt/engine/entrypoint

RUN rm -rf cli-lib manager-lib \
    && rm mirth-cli-launcher.jar oiecommand

RUN (cat oieserver.vmoptions docs/oieservice-java9+.vmoptions ; echo "") > oieserver_base.vmoptions

RUN chown -R ${UID}:${GID} /opt/engine

##########################################
#
#     Alpine Images
#
##########################################

FROM eclipse-temurin:$ALPINE_JRE_TAG AS alpine-jre

ARG UID
ARG GID

COPY --from=downloader /opt/engine /opt/engine

RUN adduser -D -H -u $UID engine \
    && apk add --no-cache bash

VOLUME /opt/engine/appdata
VOLUME /opt/engine/custom-extensions
WORKDIR /opt/engine

EXPOSE 8443

USER engine
ENTRYPOINT ["./entrypoint"]
CMD ["./oieserver"]

FROM eclipse-temurin:$ALPINE_JDK_TAG AS alpine-jdk

ARG UID
ARG GID

COPY --from=downloader /opt/engine /opt/engine

RUN adduser -D -H -u $UID engine \
    && apk add --no-cache bash

VOLUME /opt/engine/appdata
VOLUME /opt/engine/custom-extensions
WORKDIR /opt/engine

EXPOSE 8443

USER engine
ENTRYPOINT ["./entrypoint"]
CMD ["./oieserver"]

##########################################
#
#     Ubuntu Images
#
##########################################

FROM eclipse-temurin:$UBUNTU_JRE_TAG AS ubuntu-jre

ARG UID
ARG GID

COPY --from=downloader /opt/engine /opt/engine

RUN groupadd --gid ${GID} engine \
    && useradd -u ${UID} -g ${GID} -M engine

VOLUME /opt/engine/appdata
VOLUME /opt/engine/custom-extensions
WORKDIR /opt/engine

EXPOSE 8443

USER engine
ENTRYPOINT ["./entrypoint"]
CMD ["./oieserver"]

FROM eclipse-temurin:$UBUNTU_JDK_TAG AS ubuntu-jdk

ARG UID
ARG GID

COPY --from=downloader /opt/engine /opt/engine

RUN groupadd --gid ${GID} engine \
    && useradd -u ${UID} -g ${GID} -M engine

VOLUME /opt/engine/appdata
VOLUME /opt/engine/custom-extensions
WORKDIR /opt/engine

EXPOSE 8443

USER engine
ENTRYPOINT ["./entrypoint"]
CMD ["./oieserver"]