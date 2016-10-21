  class ObservationsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry, only: [:index, :new, :create, :edit]
  before_filter :load_interleave_person, only: [:index, :new, :create, :edit]
  before_filter :load_observation, only: [:edit, :update]
  before_filter :load_interleave_datapoint, only: [:new, :edit]

  def index
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    add_breadcrumbs(registry: @registry, interleave_person: @interleave_person, datapoint: @datapoint)
    @observations = Observation.by_person(@interleave_person.person.person_id).by_interleave_data_point(@datapoint.id, options).paginate(per_page: 10, page: params[:page])
  end

  def new
    @observation = Observation.new()
    @observation.interleave_datapoint = @datapoint
    @datapoint.initialize_defaults(@observation)
    @concepts = []
    @type_concepts = load_concepts('observation_type_concept_id')
    @sub_datapoints = @datapoint.initialize_sub_datapoint_entities
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @observation = Observation.new(observation_params)
    interleave_registry_cdm_source =  @registry.interleave_registry_cdm_sources.where(cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO).first
    @observation.person = @interleave_person.person

    respond_to do |format|
      if @observation.create_with_sub_datapoints!(interleave_registry_cdm_source, observations: params[:observations])
        format.js { }
      else
        format.js { render json: { errors: @observation.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @observation.interleave_datapoint = @datapoint
    @concepts = [[@observation.observation_concept.concept_name, @observation.observation_concept_id]]
    @type_concepts = load_concepts('observation_type_concept_id')
    @sub_datapoints = @datapoint.initialize_sub_datapoint_entities(@observation.interleave_entity)
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def update
    respond_to do |format|
      if @observation.update_with_sub_datapoints!(observation_params, observations: params[:observations])
        format.js { }
      else
        format.js { render json: { errors: @observation.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private
    def observation_params
      params.require(:observation).permit(:interleave_datapoint_id, :observation_concept_id, :observation_date, :observation_time, :observation_type_concept_id, :value_as_number, :value_as_string, :value_as_concept_id, :qualifier_concept_id, :unit_concept_id)
    end

    def load_observation
      @observation = Observation.find(params[:id])
    end

    def sort_column
      ['observation_date'].concat(@datapoint.interleave_sub_datapoints.map { |interleave_sub_datapoint| interleave_sub_datapoint.id.to_s }).include?(params[:sort]) ? params[:sort] : "#{@datapoint.id}"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end