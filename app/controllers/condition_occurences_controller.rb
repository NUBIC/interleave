class ConditionOccurencesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry, only: :index
  before_filter :load_interleave_person, only: :index

  def index
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction

    @datapoints = @registry.interleave_datapoints.by_domain('Condition')
    @condition_occurence_datapoints = []
    @datapoints.each do |datapoint|
      condition_occurence_datapoint = {}
      condition_occurence_datapoint[:datapoint] = datapoint
      condition_occurences = ConditionOccurrence.by_interleave_data_point(datapoint.id).paginate(per_page: 10, page: params[:page])
      condition_occurence_datapoint[:condition_occurences] = condition_occurences
      @condition_occurence_datapoints << condition_occurence_datapoint
    end
  end

  private
    def load_interleave_registry
      @registry = InterleaveRegistry.find(params[:interleave_registry_id])
    end

    def load_interleave_person
      @person = InterleavePerson.find(params[:interleave_person_id])
    end

    def sort_column
      !params[:sort].blank? ? params[:sort] : 'condition_start_date'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end