require 'rails_helper'

RSpec.describe Population::Csv::Importer::Parser, type: :model do
  describe '#data_for_upsert' do
    subject { parser.data_for_upsert }

    let!(:region_1) { Region.create!(name: 'あああ地方') }
    let!(:region_2) { Region.create!(name: 'くくく地方') }
    let!(:prefecture_1) { region_1.prefectures.create!(name: 'いいい県') }
    let!(:prefecture_2) { region_1.prefectures.create!(name: 'おおお都') }
    let!(:prefecture_3) { region_2.prefectures.create!(name: 'けけけ府') }
    let!(:prefecture_4) { region_2.prefectures.create!(name: 'ししし道') }
    let!(:municipality_1) { prefecture_1.municipalities.create!(name: 'ううう市') }
    let!(:municipality_2) { prefecture_1.municipalities.create!(name: 'えええ区') }
    let!(:municipality_3) { prefecture_2.municipalities.create!(name: 'かかか町') }
    let!(:municipality_4) { prefecture_2.municipalities.create!(name: 'ききき村') }
    let!(:municipality_5) { prefecture_3.municipalities.create!(name: 'こここ市') }
    let!(:municipality_6) { prefecture_3.municipalities.create!(name: 'さささ市') }
    let!(:municipality_7) { prefecture_4.municipalities.create!(name: 'すすす市') }
    let!(:municipality_8) { prefecture_4.municipalities.create!(name: 'せせせ市') }

    let(:parser) { described_class.new(csv) }

    context '正しいCSVデータを受け取った時' do
      let(:csv) do
        csv_str = <<~CSV
          地方,都道府県,市区町村,2000年,2001年,2002年
          あああ地方,,,3000000,6400000,780000
          ,いいい県,,1500000,3200000,390000
          ,,ううう市,1000000,1200000,900000
          ,,えええ区,500000,2000000,3000000
          ,おおお都,,1500000,3200000,390000
          ,,かかか町,1000000,1200000,900000
          ,,ききき村,500000,2000000,3000000
          くくく地方,,,22000,26000,30000
          ,けけけ府,,5000,7000,9000
          ,,こここ市,1000,2000,3000
          ,,さささ市,4000,5000,6000
          ,ししし道,,17000,19000,21000
          ,,すすす市,7000,8000,9000
          ,,せせせ市,10000,11000,12000
        CSV
        CSV.new(csv_str, headers: true)
      end

      it 'upsert用の配列を返す' do
        is_expected.to eq(
          [
            { municipality_id: municipality_1.id, year: 2000, value: 1000000 },
            { municipality_id: municipality_1.id, year: 2001, value: 1200000 },
            { municipality_id: municipality_1.id, year: 2002, value: 900000 },
            { municipality_id: municipality_2.id, year: 2000, value: 500000 },
            { municipality_id: municipality_2.id, year: 2001, value: 2000000 },
            { municipality_id: municipality_2.id, year: 2002, value: 3000000 },
            { municipality_id: municipality_3.id, year: 2000, value: 1000000 },
            { municipality_id: municipality_3.id, year: 2001, value: 1200000 },
            { municipality_id: municipality_3.id, year: 2002, value: 900000 },
            { municipality_id: municipality_4.id, year: 2000, value: 500000 },
            { municipality_id: municipality_4.id, year: 2001, value: 2000000 },
            { municipality_id: municipality_4.id, year: 2002, value: 3000000 },
            { municipality_id: municipality_5.id, year: 2000, value: 1000 },
            { municipality_id: municipality_5.id, year: 2001, value: 2000 },
            { municipality_id: municipality_5.id, year: 2002, value: 3000 },
            { municipality_id: municipality_6.id, year: 2000, value: 4000 },
            { municipality_id: municipality_6.id, year: 2001, value: 5000 },
            { municipality_id: municipality_6.id, year: 2002, value: 6000 },
            { municipality_id: municipality_7.id, year: 2000, value: 7000 },
            { municipality_id: municipality_7.id, year: 2001, value: 8000 },
            { municipality_id: municipality_7.id, year: 2002, value: 9000 },
            { municipality_id: municipality_8.id, year: 2000, value: 10000 },
            { municipality_id: municipality_8.id, year: 2001, value: 11000 },
            { municipality_id: municipality_8.id, year: 2002, value: 12000 },
          ]
        )
      end
    end
  end
end