# ベースイメージの設定
ARG RUBY_VERSION=3.3.6
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# 環境変数の設定 - より明確に定義
ENV NODE_VERSION=20.18.1 \
    YARN_VERSION=1.22.22 \
    # PATHの設定を改善
    PATH="/usr/local/node/bin:/usr/local/bundle/bin:/usr/local/bin:${PATH}" \
    NODE_PATH="/usr/local/node/lib/node_modules" \
    NPM_CONFIG_PREFIX="/usr/local/node" \
    RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="test"

# 基本パッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    default-mysql-client \
    git \
    libjemalloc2 \
    libglib2.0-0 \
    libglib2.0-dev \
    libgomp1 \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    libzstd-dev \
    imagemagick \
    libmagickwand-dev \
    fonts-ipafont \
    fontconfig \
    pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && ldconfig

# ビルドステージ
FROM base AS build

# Node.jsとYarnのセットアップを改善
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    # npmをグローバルにインストール
    /usr/local/node/bin/npm install -g npm@latest && \
    # yarnをグローバルにインストール
    /usr/local/node/bin/npm install -g yarn@${YARN_VERSION} && \
    # 開発ツールをインストール
    /usr/local/node/bin/npm install -g esbuild tailwindcss && \
    # シンボリックリンクを作成
    mkdir -p /usr/local/bin && \
    ln -sf /usr/local/node/bin/node /usr/local/bin/node && \
    ln -sf /usr/local/node/bin/npm /usr/local/bin/npm && \
    ln -sf /usr/local/node/bin/yarn /usr/local/bin/yarn && \
    ln -sf /usr/local/node/bin/esbuild /usr/local/bin/esbuild && \
    ln -sf /usr/local/node/bin/tailwindcss /usr/local/bin/tailwindcss && \
    # インストール確認
    echo "Verifying installations:" && \
    node --version && \
    npm --version && \
    yarn --version && \
    esbuild --version && \
    tailwindcss --version

# Gemfile関連のセットアップ
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.6.2 && \
    bundle install --jobs 4

# Node.js依存関係のセットアップを改善
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# アプリケーションのコピー
COPY . .

# アセットのプリコンパイル
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# 最終イメージ
FROM base

# Node.js環境のコピーと設定
COPY --from=build /usr/local/node /usr/local/node
ENV PATH="/usr/local/node/bin:/usr/local/bundle/bin:/usr/local/bin:${PATH}"

# 最終イメージでのツールのセットアップ
RUN /usr/local/node/bin/npm install -g esbuild tailwindcss && \
    mkdir -p /usr/local/bin && \
    ln -sf /usr/local/node/bin/esbuild /usr/local/bin/esbuild && \
    ln -sf /usr/local/node/bin/tailwindcss /usr/local/bin/tailwindcss

# ビルドステージからの成果物をコピー
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# セキュリティ設定と権限
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p db log storage tmp && \
    chown -R rails:rails db log storage tmp /usr/local/node && \
    # Node.jsツールの権限を設定
    chmod -R 755 /usr/local/node/bin/*

USER 1000:1000

# 起動設定
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]