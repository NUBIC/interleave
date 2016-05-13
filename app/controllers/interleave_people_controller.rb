class InterleavePeopleController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry

  def index
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    params[:affiliate_id] ||= 'all'
    @interleave_regsitry_affiliates = @registry.interleave_registry_affiliates.map { |interleave_regsitry_affiliate| [interleave_regsitry_affiliate.name, interleave_regsitry_affiliate.id] }
    @people = InterleavePerson.search_across_fields(params[:search], @registry, params[:affiliate_id], options).paginate(per_page: 10, page: params[:page])
  end

  private
    def load_interleave_registry
      @registry = InterleaveRegistry.find(params[:interleave_registry_id])
    end

    def sort_column
      !params[:sort].blank? ? params[:sort] : 'last_name'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end