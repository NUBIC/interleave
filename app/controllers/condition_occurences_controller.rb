class ConditionOccurencesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry, only: :index
  before_filter :load_interleave_person, only: :index

  def index
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction

    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    @condition_occurences = ConditionOccurrence.by_interleave_data_point(@datapoint.id).paginate(per_page: 10, page: params[:page])
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