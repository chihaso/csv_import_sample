class Population::Csv::Importer::Parser
  def initialize(csv)
    @csv = csv
  end

  def data_for_upsert
    current_region = nil
    current_prefecture = nil

    @csv.map do |row|
      next if row.header_row?

      if row['地方'].present?
        current_region = row['地方']
        nil
      elsif row['都道府県'].present?
        current_prefecture = row['都道府県']
        nil
      elsif row['市区町村'].present?
        if municipality_info(current_region, current_prefecture, row).present?
          municipality_id = municipality_info(current_region, current_prefecture, row)[0]
          years.map { |year| population_data(municipality_id, year, row) }
        else
          raise '登録されていない市区町村のデータはアップロードできません'
        end
      else
        raise '地方、都道府県、市区町村名が全て空白です'
      end
    end.flatten.compact
  end

  private

  def municipality_info(current_region, current_prefecture, row)
    registered_municipalities_info.find do |info|
      info[1] == current_region && info[2] == current_prefecture && info[3] == row['市区町村']
    end
  end

  def registered_municipalities_info
    # 各行で市区町村が登録済みか調べようとするとN+1問題が発生するので、配列にまとめておく
    columns = %w[municipalities.id regions.name prefectures.name municipalities.name]
    @registered_municipalities_info ||= Municipality.includes(prefecture: :region).pluck(*columns)
  end

  def years
    @years ||= @csv.headers.drop(3).map { |year_str| year_str.chop.to_i }
  end

  def population_data(municipality_id, year, row)
    {
      municipality_id: municipality_id,
      year: year,
      value: row["#{year}年"].to_i
    }
  end
end
