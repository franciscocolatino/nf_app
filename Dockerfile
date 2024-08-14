FROM ruby:3.1.2

ENV RAILS_ROOT=/app

RUN mkdir -p $RAILS_ROOT

RUN gem install bundler -v 2.3.21

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

COPY . ./

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]