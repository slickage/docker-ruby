FROM alpine:3.6

# Essentials
RUN apk add --update \
    bash \
    build-base \
    curl \
    file \
    git \
    nodejs \
    openssl-dev \
    readline-dev \
    vim \
    wget \
    zlib-dev

# Timezone set to Honolulu
RUN apk add --update \
    tzdata \
&&  cp /usr/share/zoneinfo/Pacific/Honolulu /etc/localtime

ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
ENV RUBY_VERSION 2.4.1
ENV CONFIGURE_OPTS --disable-install-doc

ENV BUILD_PACKAGES \
    linux-headers \
    imagemagick-dev \
    qt-webkit \
    xvfb \
    libffi-dev \
    postgresql-dev \
    libffi-dev

RUN apk add --update $BUILD_PACKAGES
RUN rm -rf /var/cache/apk/*

RUN git clone --depth 1 git://github.com/sstephenson/rbenv.git ${RBENV_ROOT} \
&&  git clone --depth 1 https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build \
&&  git clone --depth 1 git://github.com/jf/rbenv-gemset.git ${RBENV_ROOT}/plugins/rbenv-gemset \
&&  ${RBENV_ROOT}/plugins/ruby-build/install.sh

RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh \
&&  echo 'eval "$(rbenv init -)"' >> /root/.bashrc

RUN rbenv install $RUBY_VERSION \
&&  rbenv global $RUBY_VERSION

RUN mkdir /app
