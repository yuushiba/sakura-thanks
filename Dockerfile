# ベースイメージの設定
ARG RUBY_VERSION=3.3.6
FROM ruby:$RUBY_VERSION-slim

# 作業ディレクトリの設定
WORKDIR /rails

# 環境変数の設定
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="test" \
    LANG=C.UTF-8 \
    NODE_ENV="development" \
    PATH="/usr/local/node/bin:/usr/local/bundle/bin:/usr/local/bin:${PATH}"

# 基本パッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    default-mysql-client \
    libpq-dev \
    libmysqlclient-dev \
    git \
    nodejs \
    npm \
    # 画像処理に必要なパッケージ
    imagemagick \
    libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Node.jsとYarnのセットアップ
RUN npm install -g yarn && \
    yarn global add esbuild tailwindcss @tailwindcss/forms && \
    yarn config set prefix /usr/local

# Gemfileのコピーとインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Node.js依存関係のインストール
COPY package.json yarn.lock ./
RUN yarn install

# アプリケーションのコピー
COPY . .

# 権限設定
RUN mkdir -p tmp/pids log storage/development && \
    chmod -R 777 tmp log storage

# サーバー起動設定
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
