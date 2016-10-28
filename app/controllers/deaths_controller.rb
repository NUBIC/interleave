class DeathsController < ApplicationController
  before_filter :load_interleave_registry, only: [:index, :create, :update, :destroy]
  before_filter :load_interleave_person, only: [:index, :create, :update, :destroy]
  before_filter :load_death, only: [:index, :edit, :update, :destroy]

  def index
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    @death.interleave_datapoint = @datapoint
    @type_concepts = load_concepts('death_type_concept_id')

    if @death.new_record?
      @cause_concepts = []
    else
      @cause_concepts = [[@death.cause_concept.concept_name, @death.cause_concept_id]]
    end
    add_breadcrumbs(registry: @registry, interleave_person: @interleave_person, datapoint: @datapoint)
  end

  def create
    @death = Death.new(death_params)
    @datapoint = @registry.interleave_datapoints.find(death_params[:interleave_datapoint_id])
    interleave_registry_cdm_source =  @registry.interleave_registry_cdm_sources.where(cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO).first
    @death.person = @interleave_person.person
    if @death.create_with_sub_datapoints!(interleave_registry_cdm_source)
      flash[:success] = "You have successfully updated death data."
      redirect_to interleave_registry_interleave_person_deaths_url(@registry, @interleave_person, datapoint_id: @datapoint.id)
    else
      render 'index'
    end
  end

  def update
    @datapoint = @registry.interleave_datapoints.find(death_params[:interleave_datapoint_id])
    if @death.update_attributes(death_params)
      flash[:success] = "You have successfully updated death data."
      redirect_to interleave_registry_interleave_person_deaths_url(@registry, @interleave_person, datapoint_id: @datapoint.id)
    else
      render 'index'
    end
  end

  def destroy
    @datapoint = @registry.interleave_datapoints.find(params[:interleave_datapoint_id])
    if @death.destroy
      flash[:success] = "You have successfully cleared death data."
      redirect_to interleave_registry_interleave_person_deaths_url(@registry, @interleave_person, datapoint_id: @datapoint.id)
    else
      render 'index'
    end
  end

  private
    def death_params
      params.require(:death).permit(:interleave_datapoint_id, :death_date, :death_type_concept_id, :cause_concept_id, :cause_source_value, :cause_source_concept_id)
    end

    def load_death
      @death = Death.where(person_id: @interleave_person.person.person_id).first

      if @death.blank?
        @death = Death.new
      end
    end
end