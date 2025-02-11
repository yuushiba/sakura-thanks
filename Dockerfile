# ベースイメージの設定
ARG RUBY_VERSION=3.3.6
FROM ruby:$RUBY_VERSION-slim

# 作業ディレクトリの設定
WORKDIR /rails

# 環境変数の設定
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="test" \
    LANG=C.UTF-8

# 基本パッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    default-mysql-client \
    libpq-dev \
    libmysqlclient-dev \
    git \
    nodejs \  # Node.jsを追加
    npm \     # npmを追加
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Gemfileのコピーとインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリケーションのコピー
COPY . .

# 権限設定
RUN mkdir -p tmp/pids log && \
    chmod -R 777 tmp log

# サーバー起動設定
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
