require 'rails_helper'

RSpec.describe ProcedureOccurrence, type: :model do
  it { should belong_to :procedure_concept }
  it { should belong_to :procedure_type_concept }
  it { should belong_to :modifier_concept }
  it { should belong_to :person }
  it { should validate_presence_of :procedure_concept_id }
  it { should validate_presence_of :procedure_date }
  it { should validate_presence_of :procedure_type_concept_id }
  it { should validate_presence_of :interleave_datapoint_id }
  it { should validate_presence_of :interleave_registry_cdm_source_id }

  before(:each) do
    interleave_spec_setup
    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_registry = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_affiliate = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry)
    @interleave_registry_cdm_source = FactoryGirl.create(:interleave_registry_cdm_source, cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: @interleave_registry)
    @interleave_datapoint_biopsy = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Biopsy', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 0, unrestricted: true, overlap: true)
    @interleave_datapoint_trus = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'TRUS', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 0, unrestricted: false, overlap: true)
  end

  it 'creates an interleave entity upon creation', focus: false do
    procedure_occurrence_1 = FactoryGirl.create(:procedure_occurrence, person: @person_little_my, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_biopsy.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id, quantity: 1)
    expect(InterleaveEntity.where(interleave_datapoint_id: @interleave_datapoint_biopsy, cdm_table: ProcedureOccurrence.table_name, domain_concept_id: ProcedureOccurrence.domain_concept.id, fact_id: procedure_occurrence_1.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source).count).to eq(1)
  end

  it 'reports procedure occurrences by person', focus: false do
    procedure_occurrence_1 = FactoryGirl.create(:procedure_occurrence, person: @person_little_my, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_biopsy.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id, quantity: 1)
    procedure_occurrence_2 = FactoryGirl.create(:procedure_occurrence, person: @person_moomin, procedure_concept: @concept_procedure_ultrasound_transrectal, procedure_type_concept: @concept_procedure_type_secondary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_trus.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id, quantity: 11)

    expect(ProcedureOccurrence.by_person(@person_little_my.person_id)).to match_array([procedure_occurrence_1])
  end

  it 'reports procedure occurrences by interleave datapoint', focus: false do
    procedure_occurrence_1 = FactoryGirl.create(:procedure_occurrence, person: @person_little_my, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_biopsy.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id, quantity: 1)
    procedure_occurrence_2 = FactoryGirl.create(:procedure_occurrence, person: @person_moomin, procedure_concept: @concept_procedure_ultrasound_transrectal, procedure_type_concept: @concept_procedure_type_secondary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_trus.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id, quantity: 1)

    expect(ProcedureOccurrence.by_interleave_data_point(@interleave_datapoint_biopsy.id)).to match_array([procedure_occurrence_1])
  end

  it 'knows its domain concept', focus: false do
    expect(ProcedureOccurrence.domain_concept).to eq(@concept_domain_procedure)
  end
end