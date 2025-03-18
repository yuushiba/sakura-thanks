FactoryBot.define do
  factory :post do
    title { "テスト投稿" }
    content { "これはテスト投稿の内容です。" }
    user

    # 画像付きの投稿を作成するトレイト
    trait :with_image do
      after(:build) do |post|
        # テスト用の画像ファイルをアタッチ
        file_path = Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
        
        # ファイルが存在しない場合は、fixtureディレクトリを作成
        unless File.exist?(file_path)
          FileUtils.mkdir_p(File.dirname(file_path))
          FileUtils.cp(Rails.root.join('app', 'assets', 'images', 'default_avatar.png'), file_path) rescue nil
        end
        
        # ファイルが存在する場合のみアタッチ
        post.image.attach(io: File.open(file_path), filename: 'test_image.jpg', content_type: 'image/jpeg') if File.exist?(file_path)
      end
    end
  end
end