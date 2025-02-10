# syntax = docker/dockerfile:1

# ベースイメージの指定 - これが全ての基礎になります
ARG RUBY_VERSION=3.3.6
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# 作業ディレクトリの設定
WORKDIR /rails

# 環境変数の設定 - システム全体で使用する重要な設定です
ENV LD_LIBRARY_PATH="/usr/lib/aarch64-linux-gnu:/usr/local/lib:$LD_LIBRARY_PATH" \
    PKG_CONFIG_PATH="/usr/lib/aarch64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH" \
    RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# ベース環境のセットアップ - 必要な全てのパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    default-mysql-client \
    libjemalloc2 \
    # VIPSとその依存関係
    libvips42 \
    libvips-tools \
    libvips-dev \
    libglib2.0-0 \
    libglib2.0-dev \
    libxml2 \
    pkg-config \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    libzstd-dev \
    imagemagick \
    libmagickwand-dev \
    fonts-ipafont \
    fontconfig \
    && fc-cache -f -v \
    # VIPSの設定
    && mkdir -p /usr/lib/aarch64-linux-gnu \
    && echo "/usr/lib/aarch64-linux-gnu" > /etc/ld.so.conf.d/vips.conf \
    && ldconfig \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# ビルドステージ
FROM base AS build

# ビルドに必要な依存関係のインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    default-libmysqlclient-dev \
    git \
    node-gyp \
    pkg-config \
    python-is-python3 \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Node.jsとYarnのインストール
ARG NODE_VERSION=20.18.1
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# Gemのインストール
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.6.2 && \
    bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Node.jsの依存関係をインストール
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# アプリケーションのコピー
COPY . .

# アセットのプリコンパイル
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

RUN rm -rf node_modules

# 本番環境用の最終イメージ
FROM base

# 本番環境用のパッケージを再インストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libvips42 \
    libvips-tools \
    libvips-dev \
    libglib2.0-0 \
    libglib2.0-dev \
    libxml2 \
    pkg-config \
    && echo "/usr/lib/aarch64-linux-gnu" > /etc/ld.so.conf.d/vips.conf \
    && ldconfig \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# ビルドステージからの成果物をコピー
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# セキュリティ設定
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p db log storage tmp && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# アプリケーション起動設定
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
