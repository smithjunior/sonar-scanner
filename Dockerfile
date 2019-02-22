FROM openjdk:8-jre-alpine

LABEL maintainer="Smith Junior <smith.junior@icloud.com>"

ARG SONAR_SCANNER_VERSION="3.3.0.1492"

RUN set -x \ 
    && apk upgrade \
    # replacing default repositories with edge ones
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && apk update 

RUN apk add --update --no-cache \ 
    sed \ 
    unzip \ 
    nodejs\
    npm \
    ca-certificates \
    xdg-utils \
    wget \
    gconf \
    nss \
    xrandr \
    gcc \
    hicolor-icon-theme \
    ttf-freefont \
    chromium \
    pango \
    # chromium-doc \
    v4l-utils-libs \
    strace \
    dumb-init \
    make \
    curl \
    g++\
    python \
    linux-headers \
    libstdc++ \
    binutils-gold \
    gnupg \
    libexif-dev \
    udev \
    autoconf \
    bash \    
    bison \
    build-base \
    bzip2 \
    curl \
    findutils \
    git \
    imagemagick \
    libbz2 \
    libcurl \
    libc6-compat \
    libevent \
    musl \
    openssh-client \
    openssh \
    python \
    python-dev \
    socat \
    stunnel \
    syslinux \
    tar \
    stunnel \
    zip

RUN npm install --global npm tsc-watch ntypescript typescript gulp-cli @angular/cli tslint

USER $USER

# Settings
ENV SONAR_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip"
ENV SONAR_RUNNER_HOME="/opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux"
ENV PATH $PATH:$SONAR_RUNNER_HOME/bin

RUN mkdir -p /opt
WORKDIR /opt

# Install sonar-scanner
RUN curl -o ./sonarscanner.zip -L $SONAR_URL
RUN unzip sonarscanner.zip 
RUN rm sonarscanner.zip
RUN rm -rf /usr/include \
   && rm -rf /var/cache/apk/* /root/.node-gyp /usr/share/man /tmp/* \
   && echo
# Ensure Sonar Scanner uses openjdk instead of the packaged JRE (which is broken)
RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' $SONAR_RUNNER_HOME/bin/sonar-scanner

COPY printScannerConfig.sh /opt
RUN chmod +x /opt/printScannerConfig.sh

CMD [ "/opt/printScannerConfig.sh" ]