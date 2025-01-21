# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
3.times do |n|
  User.create!(
    name: "テストユーザー#{n + 1}",
    email: "test#{n + 1}@example.com",
    password: 'password',
    password_confirmation: 'password'
  )
end

User.all.each do |user|
  2.times do |n|
    user.posts.create!(
      title: "#{user.name}の投稿#{n + 1}",
      content: "#{user.name}の#{n + 1}番目の投稿内容です。"
    )
  end
end
