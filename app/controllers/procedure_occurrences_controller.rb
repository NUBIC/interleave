class ProcedureOccurrencesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry, only: [:index, :new, :create, :edit]
  before_filter :load_interleave_person, only: [:index, :new, :create, :edit]
  before_filter :load_procedure_occurrence, only: [:edit, :update]
  before_filter :load_interleave_datapoint, only: [:new, :edit]

  def index
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    add_breadcrumbs(registry: @registry, interleave_person: @interleave_person, datapoint: @datapoint)
    @procedure_occurrences = ProcedureOccurrence.by_person(@interleave_person.person.person_id).by_interleave_data_point(@datapoint.id, options).paginate(per_page: 10, page: params[:page])
  end

  def new
    @procedure_occurrence = ProcedureOccurrence.new()
    @procedure_occurrence.interleave_datapoint = @datapoint
    @datapoint.initialize_defaults(@procedure_occurrence)
    @concepts = []
    @type_concepts = load_concepts('procedure_type_concept_id')
    @sub_datapoints = @datapoint.initialize_sub_datapoint_entities
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @procedure_occurrence = ProcedureOccurrence.new(procedure_occurence_params)
    interleave_registry_cdm_source =  @registry.interleave_registry_cdm_sources.where(cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO).first
    @procedure_occurrence.person = @interleave_person.person

    respond_to do |format|
      if @procedure_occurrence.create_with_sub_datapoints!(interleave_registry_cdm_source, measurements: params[:measurements])
        format.js { }
      else
        format.js { render json: { errors: @procedure_occurrence.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @procedure_occurrence.interleave_datapoint = @datapoint
    @concepts = [[@procedure_occurrence.procedure_concept.concept_name, @procedure_occurrence.procedure_concept_id]]
    @type_concepts = load_concepts('procedure_type_concept_id')
    @sub_datapoints = @datapoint.initialize_sub_datapoint_entities(@procedure_occurrence.interleave_entity)
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def update
    respond_to do |format|
      if @procedure_occurrence.update_with_sub_datapoints!(procedure_occurence_params, measurements: params[:measurements])
        format.js { }
      else
        format.js { render json: { errors: @procedure_occurrence.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private
    def procedure_occurence_params
      params.require(:procedure_occurrence).permit(:interleave_datapoint_id, :procedure_concept_id, :procedure_date, :procedure_type_concept_id, :modifier_concept_id, :quantity)
    end

    def load_procedure_occurrence
      @procedure_occurrence = ProcedureOccurrence.find(params[:id])
    end

    def sort_column
      ['procedure_date', 'quantity', 'procedure_concept.concept_name', 'procedure_type_concept.concept_name'].include?(params[:sort]) ? params[:sort] : 'procedure_date'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end