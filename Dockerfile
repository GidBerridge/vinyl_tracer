FROM ruby:2.7.7-alpine3.16

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

# Install required libraries on Alpine
# note: build-base required for nokogiri gem
# note: postgresql-dv required for pg gem
RUN apk update && apk upgrade && \
    apk add tzdata postgresql-dev && \
    apk add postgresql-client && \
    apk add nodejs yarn && \
    apk add build-base

# Copy all application files
COPY . .

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Copy Gemfile so we can cache gems
COPY Gemfile Gemfile.lock ./
RUN gem install rails bundler
# Fix issue with sassc gem
RUN bundle config --local build.sassc --disable-march-tune-native

# Install Ruby gems
RUN bundle install --without development test
# RUN yarn install



# Precompile assets
# RUN SECRET_KEY_BASE=`bundle exec rails secret` bundle exec rails assets:precompile

# Run entrypoint.sh script
RUN chmod +x entrypoint.sh
CMD ["/entrypoint.sh"]



# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

# WORKDIR /usr/src/app

# COPY Gemfile Gemfile.lock ./

# ENV BUNDLE_VERSION 2.2.16
# # ENV PG_VERSION 1.2.3
# RUN gem install bundler --version "$BUNDLE_VERSION"
# # RUN gem install pg --version "$PG_VERSION"

# RUN bundle install

# COPY . .

EXPOSE 3000

