FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
ARG RUSTDESK_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE="RustDesk"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/rustdesk-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  if [ -z ${RUSTDESK_VERSION+x} ]; then \
    RUSTDESK_VERSION=$(curl -sX GET "https://api.github.com/repos/rustdesk/rustdesk/releases/latest" \
      | awk '/tag_name/{print $4;exit}' FS='[""]' | sed 's|^Audacity-||'); \
  fi && \
  curl -o \
    /tmp/rustdesk.deb -L \
    "https://github.com/rustdesk/rustdesk/releases/download/${RUSTDESK_VERSION}/rustdesk-${RUSTDESK_VERSION}-$(uname -m).deb" && \
  apt-get install -y --no-install-recommends \
    /tmp/rustdesk.deb && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /root/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
