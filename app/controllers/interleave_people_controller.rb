class InterleavePeopleController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry, only: [:index, :details]
  before_filter :load_interleave_person, only: :details

  def index
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    options[:search] = params[:search]
    options[:affiliate_id] = params[:affiliate_id].to_i unless params[:affiliate_id].blank?
    add_breadcrumbs(registry: @registry)
    @regsitry_affiliates = @registry.interleave_registry_affiliates.map { |regsitry_affiliate| [regsitry_affiliate.name,  regsitry_affiliate.id] }
    @people = InterleavePerson.search_across_fields(@registry, options).paginate(per_page: 10, page: params[:page])
  end

  def details
    add_breadcrumbs(registry: @registry, interleave_person: @interleave_person)
  end

  private
    def load_interleave_registry
      @registry = InterleaveRegistry.find(params[:interleave_registry_id])
    end

    def load_interleave_person
      @interleave_person = InterleavePerson.find(params[:id])
    end

    def sort_column
      ['first_name', 'last_name', 'interleave_registry_affiliates.name'].include?(params[:sort]) ? params[:sort] : 'last_name'
    end

    def sort_direction
      ['asc', 'desc'].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end