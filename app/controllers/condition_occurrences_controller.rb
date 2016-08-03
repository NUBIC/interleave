class ConditionOccurrencesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry, only: [:index, :new, :create, :edit]
  before_filter :load_interleave_person, only: [:index, :new, :create, :edit]
  before_filter :load_condition_occurrence, only: [:edit, :update]
  before_filter :load_interleave_datapoint, only: [:new, :edit]

  def index
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    add_breadcrumbs(registry: @registry, interleave_person: @interleave_person, datapoint: @datapoint)
    @condition_occurrences = ConditionOccurrence.by_person(@interleave_person.person.person_id).by_interleave_data_point(@datapoint.id, options).paginate(per_page: 10, page: params[:page])
  end

  def new
    @condition_occurrence = ConditionOccurrence.new()
    @condition_occurrence.interleave_datapoint = @datapoint
    @datapoint.initialize_defaults(@condition_occurrence)
    @concepts = []
    @type_concepts = load_type_concepts
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @condition_occurrence = ConditionOccurrence.new(condition_occurrence_params)
    interleave_registry_cdm_source =  @registry.interleave_registry_cdm_sources.where(cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO).first
    @condition_occurrence.person = @interleave_person.person
    respond_to do |format|
      if @condition_occurrence.create_with_sub_datapoints!(interleave_registry_cdm_source)
        format.js { }
      else
        format.js { render json: { errors: @condition_occurrence.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @condition_occurrence.interleave_datapoint = @datapoint
    @concepts = [[@condition_occurrence.condition_concept.concept_name, @condition_occurrence.condition_concept_id]]
    @type_concepts = load_type_concepts
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def update
    respond_to do |format|
      if @condition_occurrence.update_attributes(condition_occurrence_params)
        format.js { }
      else
        format.js { render json: { errors: @condition_occurrence.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private
    def condition_occurrence_params
      params.require(:condition_occurrence).permit(:interleave_datapoint_id, :condition_concept_id, :condition_start_date, :condition_end_date, :condition_type_concept_id)
    end

    def load_interleave_registry
      @registry = InterleaveRegistry.find(params[:interleave_registry_id])
    end

    def load_interleave_person
      @interleave_person = InterleavePerson.find(params[:interleave_person_id])
    end

    def load_condition_occurrence
      @condition_occurrence = ConditionOccurrence.find(params[:id])
    end

    def load_interleave_datapoint
      @datapoint = InterleaveDatapoint.find(params[:datapoint_id])
    end

    def load_type_concepts
      @datapoint.concept_values('condition_type_concept_id').map { |condition_type| [condition_type.concept_name, condition_type.concept_id] }
    end

    def sort_column
      ['condition_start_date', 'condition_end_date', 'condition_concept.concept_name', 'condition_type_concept.concept_name'].include?(params[:sort]) ? params[:sort] : 'condition_start_date'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end