FROM ruby:3.1.2-alpine3.16

ARG BUNDLER_VERSION_VAR \
    RAILS_ENV \
    RAILS_MASTER_KEY
ENV BUNDLER_VERSION=$BUNDLER_VERSION_VAR \
    RAILS_LOG_TO_STDOUT="enabled" \
    RAILS_SERVE_STATIC_FILES="enabled" \
    BUNDLE_WITHOUT="development test" \
    RAILS_ENV=$RAILS_ENV \
    RAILS_MASTER_KEY=$RAILS_MASTER_KEY \
    APP_DIR="/usr/src/app/" \
    TMP_PACKAGES="build-base libxml2-dev libxslt-dev" \
    RUNTIME_PACKAGES="python3 py3-pip postgresql-dev xz-dev tzdata shared-mime-info nodejs openssl yarn imagemagick libmcrypt-dev curl" \
    SECRET_KEY_BASE="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
    DATABASE_URL="postgres://test:test@test.com:5432/test"

WORKDIR $APP_DIR

RUN apk add --no-cache --virtual .tmp_packages $TMP_PACKAGES && \
    apk add --no-cache --virtual .runtime_packages $RUNTIME_PACKAGES

COPY Gemfile* $APP_DIR

RUN gem install bundler -v $BUNDLER_VERSION && \
    bundle config set without $BUNDLE_WITHOUT && \
    bundle install --jobs 4 --retry 5

COPY . $APP_DIR


RUN apk del .tmp_packages

CMD ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0"]