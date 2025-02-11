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
# フォント関連のパッケージを追加
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
    # 画像処理関連パッケージ
    imagemagick \
    libmagickwand-dev \
    # フォント関連パッケージ
    fontconfig \
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

# フォントのセットアップ
# フォントディレクトリの作成と権限設定を確実に
RUN mkdir -p /usr/share/fonts/truetype/custom && \
    chmod 755 /usr/share/fonts/truetype/custom

# フォントファイルのコピーと設定
COPY app/assets/fonts/Yomogi-Regular.ttf /usr/share/fonts/truetype/custom/
RUN chmod 644 /usr/share/fonts/truetype/custom/Yomogi-Regular.ttf && \
    fc-cache -fv && \
    # フォントが正しく認識されているか確認
    fc-list | grep -i "Yomogi" || echo "Warning: Yomogi font not found in fc-list"

# アプリケーションのコピー
COPY . .

# 権限設定
RUN mkdir -p tmp/pids log storage/development && \
    chmod -R 777 tmp log storage

# ImageMagickポリシーの設定
# フォントへのアクセスを許可
RUN if [ -f /etc/ImageMagick-6/policy.xml ]; then \
    sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/' /etc/ImageMagick-6/policy.xml; \
    fi

# フォントの最終確認
RUN convert -list font | grep -i "Yomogi" || echo "Warning: Yomogi font not found in ImageMagick"

# サーバー起動設定
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
