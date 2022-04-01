class RegionsController < ApplicationController
  def index
    @regions = Region.all
    @all_years = Population.all.order(:year).pluck(:year).uniq
  end
end
