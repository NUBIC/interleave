class ConditionOccurrencesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry, only: [:index, :new]
  before_filter :load_interleave_person, only: [:index, :new]

  def index
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    add_breadcrumbs(registry: @registry, interleave_person: @interleave_person, datapoint: @datapoint)
    @condition_occurrences = ConditionOccurrence.by_interleave_data_point(@datapoint.id).paginate(per_page: 10, page: params[:page])
  end

  def new
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    @concepts = []
    @condition_occurrence = ConditionOccurrence.new()
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  private
    def load_interleave_registry
      @registry = InterleaveRegistry.find(params[:interleave_registry_id])
    end

    def load_interleave_person
      @interleave_person = InterleavePerson.find(params[:interleave_person_id])
    end

    def sort_column
      !params[:sort].blank? ? params[:sort] : 'condition_start_date'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end