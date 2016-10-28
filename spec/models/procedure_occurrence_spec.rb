require 'rails_helper'
require 'active_support'

RSpec.describe ProcedureOccurrence, type: :model do
  it { should belong_to :procedure_concept }
  it { should belong_to :procedure_type_concept }
  it { should belong_to :modifier_concept }
  it { should belong_to :person }
  it { should validate_presence_of :procedure_concept_id }
  it { should validate_presence_of :procedure_date }
  it { should validate_presence_of :procedure_type_concept_id }
  it { should validate_presence_of :interleave_datapoint_id }

  before(:each) do
    interleave_spec_setup
    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_registry = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_affiliate = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry)
    @interleave_registry_cdm_source = FactoryGirl.create(:interleave_registry_cdm_source, cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: @interleave_registry)
    @interleave_datapoint_biopsy = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Biopsy', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 0, overlap: true)
    @interleave_datapoint_trus = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'TRUS', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 0, overlap: true)

    @interleave_datapoint_biopsy_total_number_of_cores = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Total number of cores', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores, column: 'measurement_concept_id', concept: @concept_measurement_total_number_of_cores, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores, column: 'measurement_type_concept_id', concept: @concept_pathology_finding, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_relationship, interleave_datapoint: @interleave_datapoint_biopsy, interleave_sub_datapoint: @interleave_datapoint_biopsy_total_number_of_cores, relationship_concept_id: @concept_relationship_has_asso_finding.id)

    @interleave_datapoint_biopsy_total_number_of_cores_positive = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Total number of cores positive', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores_positive, column: 'measurement_concept_id', concept: @concept_measurement_total_number_of_cores_positive, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores_positive, column: 'measurement_type_concept_id', concept: @concept_pathology_finding, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_relationship, interleave_datapoint: @interleave_datapoint_biopsy, interleave_sub_datapoint: @interleave_datapoint_biopsy_total_number_of_cores_positive, relationship_concept_id: @concept_relationship_has_asso_finding.id)
  end

  it 'creates an interleave entity upon create with sub datapoints', focus: false do
    procedure_occurrence_1 = FactoryGirl.create(:procedure_occurrence, person: @person_little_my, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_biopsy.id, quantity: 1)
    procedure_occurrence_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    expect(InterleaveEntity.where(interleave_datapoint_id: @interleave_datapoint_biopsy, cdm_table: ProcedureOccurrence.table_name, fact_id: procedure_occurrence_1.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source).count).to eq(1)
  end

  it 'creates sub datapoints upon create with sub datapoints', focus: false do
    procedure_occurrence_1 = FactoryGirl.build(:procedure_occurrence, person: @person_little_my, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_biopsy.id, quantity: 1)
    sub_datapoint_entities = @interleave_datapoint_biopsy.initialize_sub_datapoint_entities
    measurements = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    expect(Measurement.count).to eq(0)
    procedure_occurrence_1.create_with_sub_datapoints!(@interleave_registry_cdm_source, measurements: measurements)
    interleave_entity = InterleaveEntity.where(interleave_datapoint_id: @interleave_datapoint_biopsy, cdm_table: ProcedureOccurrence.table_name, fact_id: procedure_occurrence_1.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source).first
    expect(Measurement.count).to eq(2)
    expect(interleave_entity.children.count).to eq(2)
    expected_measurements = sub_datapoint_entities.map  do |e|
      { person_id: @person_little_my.person_id, measurement_concept_id: e.measurement_concept_id, measurement_date: procedure_occurrence_1.procedure_date , value_as_concept_id: e.value_as_concept_id, value_as_number: e.value_as_number, measurement_type_concept_id: e.measurement_type_concept_id }
    end

    saved_measurements = []
    actual_measuremnts = interleave_entity.children.map do |ie|
      saved_measurements << m = Measurement.find(ie.fact_id)
      { person_id: m.person_id, measurement_concept_id: m.measurement_concept_id, measurement_date: m.measurement_date, value_as_concept_id: m.value_as_concept_id, value_as_number: m.value_as_number, measurement_type_concept_id: m.measurement_type_concept_id }
    end
    expect(expected_measurements).to match_array(actual_measuremnts)
    expect(FactRelationship.where(domain_concept_id_1: ProcedureOccurrence.domain_concept.concept_id, fact_id_1: procedure_occurrence_1.id, domain_concept_id_2: Measurement.domain_concept.concept_id, fact_id_2: saved_measurements.map(&:id), relationship_concept_id: @concept_relationship_has_asso_finding.id).count).to eq(2)
  end

  it 'reports procedure occurrences by person', focus: false do
    procedure_occurrence_1 = FactoryGirl.create(:procedure_occurrence, person: @person_little_my, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_biopsy.id, quantity: 1)
    procedure_occurrence_2 = FactoryGirl.create(:procedure_occurrence, person: @person_moomin, procedure_concept: @concept_procedure_ultrasound_transrectal, procedure_type_concept: @concept_procedure_type_secondary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_trus.id, quantity: 11)

    expect(ProcedureOccurrence.by_person(@person_little_my.person_id)).to match_array([procedure_occurrence_1])
  end

  it 'reports procedure occurrences by interleave datapoint', focus: false do
    procedure_occurrence_1 = FactoryGirl.build(:procedure_occurrence, person: @person_little_my, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_biopsy.id, quantity: 1)
    procedure_occurrence_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    procedure_occurrence_2 = FactoryGirl.build(:procedure_occurrence, person: @person_moomin, procedure_concept: @concept_procedure_ultrasound_transrectal, procedure_type_concept: @concept_procedure_type_secondary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_trus.id, quantity: 1)
    procedure_occurrence_2.create_with_sub_datapoints!(@interleave_registry_cdm_source)

    expect(ProcedureOccurrence.by_interleave_data_point(@interleave_datapoint_biopsy.id)).to match_array([procedure_occurrence_1])
  end

  it 'knows its domain concept', focus: false do
    expect(ProcedureOccurrence.domain_concept).to eq(@concept_domain_procedure)
  end

  it 'knows its interleave date', focus: false do
    procedure_date = Date.parse('1/1/2016')
    procedure_occurrence_1 = FactoryGirl.create(:procedure_occurrence, person: @person_little_my, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, procedure_date: procedure_date, interleave_datapoint_id: @interleave_datapoint_biopsy.id, quantity: 1)
    expect(procedure_occurrence_1.interleave_date).to eq(procedure_date.to_s(:date))
  end
end