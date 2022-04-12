class Population::Csv::Importer
  require 'csv'
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :csv

  with_options on: :before_parse do
    validates :csv, presence: true
    validate :accrept_only_csv, if: :csv_present?
  end

  with_options on: :after_parse do
    validate :all_fields_must_be_valid
  end

  def update_populations
    return unless valid?(:before_parse)

    data_for_upsert = parser.data_for_upsert

    return unless valid?(:after_parse)

    Population.upsert_all(
      data_for_upsert,
      unique_by: :index_populations_on_municipality_id_and_year
    )
  end

  private

  def parser
    @parser ||= Parser.new(CSV.read(csv, headers: true))
  end

  def csv_present?
    csv.present?
  end

  def accrept_only_csv
    errors.add(:csv, 'のデータ形式が不正です') if csv.content_type != 'text/csv'
  end

  def all_fields_must_be_valid
    return if parser.error_messages.blank?

    parser.error_messages.each do |message|
      errors.add(:base, message)
    end
  end
end
