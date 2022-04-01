class RegionsController < ApplicationController
  def index
    @regions = Region.all
    @all_years = Population.all.pluck(:year).uniq
  end
end
