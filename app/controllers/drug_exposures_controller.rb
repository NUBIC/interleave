class DrugExposuresController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry, only: [:index, :new, :create, :edit]
  before_filter :load_interleave_person, only: [:index, :new, :create, :edit]
  before_filter :load_drug_exposure, only: [:edit, :update]
  before_filter :load_interleave_datapoint, only: [:new, :edit]

  def index
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    add_breadcrumbs(registry: @registry, interleave_person: @interleave_person, datapoint: @datapoint)
    @drug_exposures = DrugExposure.by_person(@interleave_person.person.person_id).by_interleave_data_point(@datapoint.id, options).paginate(per_page: 10, page: params[:page])
  end

  def new
    @drug_exposure = DrugExposure.new()
    @drug_exposure.interleave_datapoint = @datapoint
    @datapoint.initialize_defaults(@drug_exposure)
    @concepts = []
    @type_concepts = load_concepts('drug_type_concept_id')
    @route_concepts = load_concepts('route_concept_id')
    # @dose_unit_concepts = []
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @drug_exposure = DrugExposure.new(drug_exposure_params)
    interleave_registry_cdm_source =  @registry.interleave_registry_cdm_sources.where(cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO).first
    @drug_exposure.person = @interleave_person.person
    respond_to do |format|
      if @drug_exposure.create_with_sub_datapoints!(interleave_registry_cdm_source)
        format.js { }
      else
        format.js { render json: { errors: @drug_exposure.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @drug_exposure.interleave_datapoint = @datapoint
    @concepts = [[@drug_exposure.drug_concept.concept_name, @drug_exposure.drug_concept_id]]
    @type_concepts = load_concepts('drug_type_concept_id')
    @route_concepts = load_concepts('route_concept_id')
    # @dose_unit_concepts = [[@drug_exposure.dose_unit_concept.concept_name, @drug_exposure.dose_unit_concept_id]]

    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def update
    respond_to do |format|
      if @drug_exposure.update_attributes(drug_exposure_params)
        format.js { }
      else
        format.js { render json: { errors: @drug_exposure.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private
    def drug_exposure_params
      params.require(:drug_exposure).permit(:interleave_datapoint_id, :drug_concept_id, :drug_exposure_start_date, :drug_exposure_end_date, :drug_type_concept_id, :route_concept_id, :dose_unit_concept_id)
    end

    def load_drug_exposure
      @drug_exposure = DrugExposure.find(params[:id])
    end

    def sort_column
      ['drug_exposure_start_date', 'drug_exposure_end_date', 'drug_concept.concept_name', 'drug_type_concept.concept_name'].include?(params[:sort]) ? params[:sort] : 'drug_exposure_start_date'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end