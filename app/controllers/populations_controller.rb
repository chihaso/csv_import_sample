class PopulationsController < ApplicationController
  def upload
    populations_csv = params[:populations]

    if populations_csv.nil?
      flash[:alert] = 'csvファイルを指定してください'
    elsif populations_csv.content_type != 'text/csv'
      flash[:alert] = 'csvファイル以外はアップロードできません'
    end
    
    redirect_to root_path
  end
end
