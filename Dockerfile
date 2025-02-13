# ベースイメージの設定
ARG RUBY_VERSION=3.3.6
FROM ruby:$RUBY_VERSION-slim as builder

# 作業ディレクトリの設定
WORKDIR /rails

# 環境変数の設定
ENV RAILS_ENV="production" \
    BUNDLE_PATH="/usr/local/bundle" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_LOG_TO_STDOUT="true"

# 基本パッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    default-mysql-client \
    libpq-dev \
    libmariadb-dev-compat \
    libmariadb-dev \
    git \
    nodejs \
    npm \
    imagemagick \
    libmagickwand-dev \
    fontconfig \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Node.jsとYarnのセットアップ
RUN npm install -g yarn && \
    yarn global add esbuild tailwindcss @tailwindcss/forms && \
    yarn config set prefix /usr/local

# Gemfileのコピーとインストール（修正）
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install

# Node.js依存関係のインストール
COPY package.json yarn.lock ./
RUN yarn install

# フォントのセットアップ
RUN mkdir -p /usr/share/fonts/truetype/custom && \
    chmod 755 /usr/share/fonts/truetype/custom

# アプリケーションのコピー
COPY . .

# フォントファイルのコピーと設定
RUN cp app/assets/fonts/Yomogi-Regular.ttf /usr/share/fonts/truetype/custom/ && \
    chmod 644 /usr/share/fonts/truetype/custom/Yomogi-Regular.ttf && \
    fc-cache -fv

# アセットのプリコンパイル
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# 最終ステージ（軽量化）
FROM ruby:$RUBY_VERSION-slim

# 環境変数の設定（統一）
ENV RAILS_ENV="production" \
    BUNDLE_PATH="/usr/local/bundle" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_LOG_TO_STDOUT="true" \
    BUNDLE_WITHOUT="development:test"

WORKDIR /rails

# 必要なパッケージのみインストール（nodejs追加）
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    default-mysql-client \
    imagemagick \
    fontconfig \
    nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# builderステージから必要なファイルをコピー
COPY --from=builder /usr/share/fonts/truetype/custom /usr/share/fonts/truetype/custom
COPY --from=builder /rails /rails
COPY --from=builder /usr/local/bundle /usr/local/bundle

# フォントキャッシュの更新
RUN fc-cache -fv

# 権限設定
RUN mkdir -p tmp/pids log storage/production && \
    chmod -R 777 tmp log storage

# サーバー起動設定
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
