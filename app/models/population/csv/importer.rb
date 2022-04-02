class Population::Csv::Importer
  require 'csv'
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :csv

  validates :csv, presence: { message: 'csvファイルを選択してください' }
  validate :accrept_only_csv

  def update_populations
    return unless valid?

    Population.upsert_all(
      parser.data_for_upsert,
      unique_by: :index_populations_on_municipality_id_and_year
    )
  end

  private

  def parser
    @parser ||= Parser.new(CSV.read(csv, headers: true))
  end

  def accrept_only_csv
    return unless csv
    errors.add(:csv, 'csvファイル以外はアップロードできません') if csv.content_type != 'text/csv'
  end
end
