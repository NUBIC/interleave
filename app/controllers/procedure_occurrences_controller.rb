class ProcedureOccurrencesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry, only: [:index, :new, :create, :edit]
  before_filter :load_interleave_person, only: [:index, :new, :create, :edit]
  before_filter :load_procedure_occurrence, only: [:edit, :update]

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
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    @concepts = []
    @type_concepts = Concept.procedure_types.valid.standard.map { |procedure_type| [procedure_type.concept_name, procedure_type.concept_id] }
    @procedure_occurrence = ProcedureOccurrence.new()
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @procedure_occurrence = ProcedureOccurrence.new(procedure_occurence_params)
    interleave_registry_cdm_source =  @registry.interleave_registry_cdm_sources.where(cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO).first
    @procedure_occurrence.interleave_registry_cdm_source_id = interleave_registry_cdm_source.id
    @procedure_occurrence.person = @interleave_person.person
    respond_to do |format|
      if @procedure_occurrence.save
        format.js { }
      else
        format.js { render json: { errors: @procedure_occurrence.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    @concepts = [[@procedure_occurrence.procedure_concept.concept_name, @procedure_occurrence.procedure_concept_id]]
    @type_concepts = Concept.procedure_types.valid.standard.map { |procedure_type| [procedure_type.concept_name, procedure_type.concept_id] }
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def update
    respond_to do |format|
      if @procedure_occurrence.update_attributes(procedure_occurence_params)
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

    def load_interleave_registry
      @registry = InterleaveRegistry.find(params[:interleave_registry_id])
    end

    def load_interleave_person
      @interleave_person = InterleavePerson.find(params[:interleave_person_id])
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