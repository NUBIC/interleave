class InterleaveRegistriesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction

    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction

    @registries = InterleaveRegistry.search_across_fields(params[:search], options).paginate(per_page: 10, page: params[:page])
  end

  private
    def sort_column
      InterleaveRegistry.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end