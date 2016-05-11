class InterleavePersonController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction

    @registries = InterleaveRegistry.all
  end

  private
    def sort_column
      InterleavePerson.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end