class MeasurementsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry, only: [:index, :new, :create, :edit]
  before_filter :load_interleave_person, only: [:index, :new, :create, :edit]
  before_filter :load_measurement, only: [:edit, :update]
  before_filter :load_interleave_datapoint, only: [:new, :edit]

  def index
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    add_breadcrumbs(registry: @registry, interleave_person: @interleave_person, datapoint: @datapoint)
    @measurements = Measurement.by_person(@interleave_person.person.person_id).by_interleave_data_point(@datapoint.id, options).paginate(per_page: 10, page: params[:page])
  end

  def new
    @measurement = Measurement.new()
    @measurement.interleave_datapoint = @datapoint
    @datapoint.initialize_defaults(@measurement)
    @concepts = []
    @type_concepts = load_type_concepts
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @measurement = Measurement.new(measurement_params)
    interleave_registry_cdm_source =  @registry.interleave_registry_cdm_sources.where(cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO).first
    @measurement.person = @interleave_person.person
    respond_to do |format|
      if @measurement.create_with_sub_datapoints!(interleave_registry_cdm_source)
        format.js { }
      else
        format.js { render json: { errors: @measurement.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @measurement.interleave_datapoint = @datapoint
    @concepts = [[@measurement.measurement_concept.concept_name, @measurement.measurement_concept_id]]
    @type_concepts = load_type_concepts
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def update
    respond_to do |format|
      if @measurement.update_attributes(measurement_params)
        format.js { }
      else
        format.js { render json: { errors: @measurement.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private
    def measurement_params
      params.require(:measurement).permit(:interleave_datapoint_id, :measurement_concept_id, :measurement_date, :measurement_type_concept_id, :value_as_number, :value_as_concept_id)
    end

    def load_interleave_registry
      @registry = InterleaveRegistry.find(params[:interleave_registry_id])
    end

    def load_interleave_person
      @interleave_person = InterleavePerson.find(params[:interleave_person_id])
    end

    def load_measurement
      @measurement = Measurement.find(params[:id])
    end

    def load_interleave_datapoint
      @datapoint = InterleaveDatapoint.find(params[:datapoint_id])
    end

    def load_type_concepts
      @datapoint.concept_values('measurement_type_concept_id').map { |measuremet_type| [measuremet_type.concept_name, measuremet_type.concept_id] }
    end

    def sort_column
      ['measurement_date', 'measurement_concept.concept_name', 'measurement_type_concept.concept_name', 'value_as_number'].include?(params[:sort]) ? params[:sort] : 'measurement_date'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end