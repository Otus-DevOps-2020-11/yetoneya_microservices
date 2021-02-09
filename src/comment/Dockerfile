FROM ruby:2.2

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

RUN apt-get update -qq && apt-get install -y build-essential

WORKDIR /app

ADD Gemfile* /

RUN bundle install
COPY . /app

CMD ["puma"]
