class Population::CsvImporter::Parser
  MUNICIPALITY_INFO_COLUMNS = %w[municipalities.id regions.name prefectures.name municipalities.name]

  attr_reader :error_messages

  def initialize(csv)
    @csv = csv
    @error_messages = []
  end

  def data_for_upsert
    current_region = nil
    current_prefecture = nil

    data = @csv.map.with_index(2) do |row, row_number|
      if row['地方'].present?
        current_region = row['地方']
        next
      elsif row['都道府県'].present?
        current_prefecture = row['都道府県']
        next
      elsif row['市区町村'].present?
        if municipality_info(current_region, current_prefecture, row).present?
          municipality_id = municipality_info(current_region, current_prefecture, row)[0]
          years.map { |year| population_data(municipality_id, year, row, row_number) }
        else
          error_messages << "#{row_number}行目: 登録されていない地方、都道府県、市区町村のデータは入力できません"
        end
      else
        error_messages << "#{row_number}行目: 地方、都道府県、市区町村名が全て空白です"
      end
    end.flatten.compact

    error_messages.blank? ? data : nil
  end

  private

  def municipality_info(current_region, current_prefecture, row)
    registered_municipalities_info.find do |info|
      info[1] == current_region && info[2] == current_prefecture && info[3] == row['市区町村']
    end
  end

  def registered_municipalities_info
    # 各行で市区町村が登録済みか調べようとするとN+1問題が発生するので、配列にまとめておく
    @registered_municipalities_info ||= Municipality.includes(prefecture: :region).pluck(*MUNICIPALITY_INFO_COLUMNS)
  end

  def years
    @years ||= @csv.headers.drop(3).map { |year_str| year_str.chop.to_i }
  end

  def population_data(municipality_id, year, row, row_number)
    attributes = {
      municipality_id: municipality_id,
      year: year,
      value: row["#{year}年"]
    }
    validate_population(attributes, row_number, year)
  end

  def validate_population(attributes, row_number, year)
    population = Population.new(attributes)
    if population.valid?
      attributes
    else
      population.errors.full_messages.each do |message|
        error_messages << "#{row_number}行目, #{year}年の列: #{message}"
      end
    end
  end
end
