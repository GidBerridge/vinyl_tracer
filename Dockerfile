FROM ruby:2.7.7-alpine3.16

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV SECRET_KEY_BASE 1

# Install required libraries on Alpine
# note: build-base required for nokogiri gem
# note: postgresql-dv required for pg gem
RUN apk update && apk upgrade && \
    apk add tzdata postgresql-dev && \
    apk add postgresql-client && \
    apk add nodejs yarn && \
    apk add build-base



# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Copy Gemfile so we can cache gems
COPY Gemfile Gemfile.lock ./
RUN gem install rails bundler
# Fix issue with sassc gem
# RUN bundle config --local build.sassc --disable-march-tune-native

# Install Ruby gems
RUN bundle install --without development test
# RUN yarn install

# Copy all application files
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile
RUN bundle exec rails webpacker:compile

# Run entrypoint.sh script
RUN chmod +x entrypoint.sh
CMD ["/entrypoint.sh"]


EXPOSE 3000

