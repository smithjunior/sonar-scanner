FROM node:11-alpine

LABEL maintainer="Smith Junior <smith.junior@icloud.com>"

ARG SONAR_SCANNER_VERSION="3.3.0.1492"

RUN set -x \ 
   # replacing default repositories with edge ones
   && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories \
   && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
   && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
   && apk update \
   && apk upgrade 

RUN apk add --update --no-cache \ 
   sed \ 
   unzip \ 
   # nodejs\
   atk \
   at-spi2-atk \
   gtk+3.0 \
   openjdk8-jre \
   openjdk8 \   
   at-spi2-core \
   clang \
   #npm \
   ca-certificates \
   xdg-utils \
   libxcursor \
   wget \
   gconf \
   nss \
   xrandr \
   gcompat \
   libc6-compat \
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
   libxdamage \
   libx11 \
   expat \
   libxscrnsaver \
   libstdc++ \
   libxi \
   cdist \
   binutils-gold \
   gnupg \
   libexif-dev \
   udev \
   autoconf \
   bash \
   dbus-libs \
   bison \
   libstdc++6 \
   libxcomposite \
   ttf-liberation \
   fontconfig \
   build-base \
   bzip2 \
   curl \
   findutils \
   git \
   imagemagick \
   libbz2 \
   libcurl \
   libevent \
   musl \
   openssh-client \
   openssh \
   cups-libs \
   python \
   grep \
   python-dev \
   cairo \
   gdk-pixbuf \
   libxscrnsaver \
   libxfixes \
   musl-utils \
   socat \
   stunnel \
   syslinux \
   tar \
   stunnel \
   zip


RUN npm install --global npm tsc-watch ntypescript typescript gulp-cli @angular/cli tslint

#USER $USER

RUN ln -s /usr/bin/chromium-browser /usr/bin/google-chrome
# This line is to tell karma-chrome-launcher where
# chromium was downloaded and installed to.
ENV CHROME_BIN /usr/bin/chromium-browser

# Tell Puppeteer to skip installing Chrome.
# We'll be using the installed package instead.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
# Telling node-sass which pre-built binary to fetch.
# This way we don't need rebuilding node-sass each time!
ENV SASS_BINARY_NAME=linux-x64-67
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
# RUN rm -rf /usr/include \
#   && rm -rf /var/cache/apk/* /root/.node-gyp /usr/share/man /tmp/* \
#   && echo
# Ensure Sonar Scanner uses openjdk instead of the packaged JRE (which is broken)
RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' $SONAR_RUNNER_HOME/bin/sonar-scanner

COPY printScannerConfig.sh /opt
RUN chmod +x /opt/printScannerConfig.sh

CMD [ "/opt/printScannerConfig.sh" ]
