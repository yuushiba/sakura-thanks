# sakura-thanks

## サービス概要

桜の写真と感謝のメッセージを共有できるプラットフォーム<br>
思い出の桜写真に手書き風のメッセージを添えて特別な人に送れるサービ<br>
桜の季節に合わせて過去の思い出を振り返り、新たな感謝を生み出すコミュニティ

## サービスへの想い、作りたい理由

幼少期からの植物好きという背景に加え、受験勉強後に見た桜の感動体験が原点です。<br>
この時、頑張りを支えてくれた両親や友人への感謝の気持ちが桜と共に込み上げてきました。<br>
その後、親や友人に桜の写真と共に感謝を伝えた際の喜びの経験や、友人との桜の思い出写真を見返した時の温かい気持ちから、この特別な瞬間を共有できるプラットフォームがあれば素晴らしいと考えました。<br>
桜は日本の伝統的な花であり、人生の節目を象徴する特別な存在です。入学、卒業、就職など、人生の大きな転換期に咲く桜は、多くの人の記憶に深く刻まれています。<br>
その一期一会の美しさと共に感謝の気持ちを伝えることで、より深い心の繋がりを生み出したいと考えています。

## 想定されるユーザー層

主なターゲットは以下の2つです
- 桜にまつわる思い出があり、感謝を伝えたい人
  - 卒業・入学シーズンの思い出がある人
  - 人生の転機に桜が関係している人
  - 大切な人との桜の思い出がある人
- 他の人の桜にまつわる思い出や感謝の気持ちを見たい人
  - 桜の写真が好きな人
  - 心温まるストーリーを求めている人
  - 感謝の気持ちに共感したい人

## サービスの利用イメージ

【MVPリリース時】
桜の写真とメッセージを投稿
他のユーザーの投稿を閲覧

【本リリース時】
共感できる投稿にコメント
写真に手書き風メッセージを追加
お気に入り機能で印象的な投稿を保存
SNS連携で広く共有

## ユーザーの獲得について

- SNSでの拡散（X連携機能を活用したハッシュタグなどの自然な拡散）
- 桜の季節に合わせたプロモーション（自身のXのアカウントでアプリ情報を更新）


## サービスの差別化ポイント・推しポイント

- 桜に特化した感謝の表現
  - 一般的なサンクスカードアプリとは異なり、桜という特別な題材を通じて感謝を表現
  - 季節性と一期一会の要素を活かした独自の価値提供

- 思い出と感謝の融合
  - 単なる写真共有やメッセージサービスではなく、思い出と感謝を結びつける
  - コミュニティ性を持たせることで、個人の思い出を社会的な価値へと発展

## 機能候補

【MVPリリース】
・写真投稿機能
・メッセージ投稿機能
・一覧表示・詳細表示機能
・掲示板の CRUD（登録・参照・更新・削除）機能
・ユーザー登録・認証（Google 認証は未実装）
・ログイン・ログアウト

【本リリース】
・Google 認証
・フラッシュメッセージ
・手書き風メッセージ機能
・お気に入り機能
・X連携機能
・投稿へのコメント機能
・掲示板の検索機能
・お問い合わせ
・利用規約
・プライバシーポリシー
・独自ドメイン
・i18nによる日本語化対応

## 機能の実装方針予定

- 写真処理系
MVPのときはACTIVERECORDをしようした基本的な画像アップロード。image_tagヘルパーメソッドによる画像表示
本リリースのときは手書き風文字を取り入れたいためImage Magick + mini_magick gem
gem 'carrierwave', '2.2.2'（画像アップロード）

- SNS連携
X API Free

- ユーザー認証
sorcery
omniauth-google-oauth2

- その他
rails-i18n
gem 'ransack', '3.2.1'
