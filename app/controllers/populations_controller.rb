class PopulationsController < ApplicationController
  def upload
    csv_importer.update_populations
    flash[:alert] = joined_error_messages(csv_importer)
    redirect_to root_path
  end

  private

  def csv_importer
    @csv_importer ||= Population::CsvImporter.new(csv: params[:populations_csv])
  end

  def joined_error_messages(csv_importer)
    csv_importer.errors.full_messages&.join('<br>')
  end
end
