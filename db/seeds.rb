# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Region
tohoku = Region.create!(name: '東北地方')
kanto = Region.create!(name: '関東地方')

# Prefecture
iwate = tohoku.prefectures.create!(name: '岩手県')
akita = tohoku.prefectures.create!(name: '秋田県')
tokyo = kanto.prefectures.create!(name: '東京都')
kanagawa = kanto.prefectures.create!(name: '神奈川県')

# Municipality
iwate.municipalities.create!(name: '盛岡市')
iwate.municipalities.create!(name: '遠野市')
akita.municipalities.create!(name: '秋田市')
akita.municipalities.create!(name: '男鹿市')
tokyo.municipalities.create!(name: '新宿区')
tokyo.municipalities.create!(name: '奥多摩町')
kanagawa.municipalities.create!(name: '横浜市')
kanagawa.municipalities.create!(name: '清川村')
