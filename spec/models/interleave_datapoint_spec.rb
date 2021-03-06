require 'rails_helper'
include InterleaveSpecSetup
RSpec.describe InterleaveDatapoint, type: :model do
  it { should belong_to :interleave_registry }
  it { should have_many :interleave_datapoint_values }
  it { should have_many :interleave_datapoint_default_values }
  it { should have_many :interleave_datapoint_relationships }
  it { should have_many :interleave_sub_datapoints }
  it { should have_one :interleave_datapoint_relationship }
  it { should have_one :interleave_datapoint_parent }

  before(:each) do
    interleave_spec_setup
    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_registry = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_affiliate = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry)
    @interleave_registry_cdm_source = FactoryGirl.create(:interleave_registry_cdm_source, cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: @interleave_registry)

    @interleave_datapoint_diagnosis = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Diagnosis', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 1, overlap: true)

    @interleave_datapoint_comorbidities = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Comorbidities', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 0, overlap: false)
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_neoplasam_of_prostate, column: 'condition_concept_id')
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_benign_prostatic_hyperplasia, column: 'condition_concept_id')
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_type_ehr_problem_list_entry, column: 'condition_type_concept_id')

    @interleave_datapoint_gleason_primary = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Gleason primary', domain_id: Measurement::DOMAIN_ID, cardinality: 0, overlap: false)
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_gleason_primary, value_as_number: 1, column: 'value_as_number')
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_gleason_primary, value_as_number: 2, column: 'value_as_number')
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_gleason_primary, value_as_number: 3, column: 'value_as_number')
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_gleason_primary, value_as_number: 4, column: 'value_as_number')
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_gleason_primary, value_as_number: 5, column: 'value_as_number')

    @interleave_datapoint_biopsy = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Biopsy', domain_id: ProcedureOccurrence::DOMAIN_ID, cardinality: 0, overlap: true)

    @interleave_datapoint_biopsy_total_number_of_cores = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Total number of cores', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores, column: 'measurement_concept_id', concept: @concept_measurement_total_number_of_cores, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores, column: 'measurement_type_concept_id', concept: @concept_pathology_finding, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_relationship, interleave_datapoint: @interleave_datapoint_biopsy, interleave_sub_datapoint: @interleave_datapoint_biopsy_total_number_of_cores, relationship_concept_id: @concept_relationship_has_asso_finding.id)

    @interleave_datapoint_biopsy_total_number_of_cores_positive = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Total number of cores positive', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores_positive, column: 'measurement_concept_id', concept: @concept_measurement_total_number_of_cores_positive, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores_positive, column: 'measurement_type_concept_id', concept: @concept_pathology_finding, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_relationship, interleave_datapoint: @interleave_datapoint_biopsy, interleave_sub_datapoint: @interleave_datapoint_biopsy_total_number_of_cores_positive, relationship_concept_id: @concept_relationship_has_asso_finding.id)

    @interleave_datapoint_weight = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Weight', domain_id: Measurement::DOMAIN_ID, cardinality: 0 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_weight, column: 'measurement_concept_id', concept: @concept_measurement_body_weight_measured, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_weight, column: 'measurement_type_concept_id', concept: @concept_lab_result, hardcoded: true)
  end

  it 'knows its parent datapoint', focus: false do
    expect(@interleave_datapoint_biopsy_total_number_of_cores_positive.interleave_datapoint_parent).to eq(@interleave_datapoint_biopsy)
  end

  it 'knows it does not have a parent datapoint', focus: false do
    expect(@interleave_datapoint_biopsy.interleave_datapoint_parent).to be_nil
  end

  it 'returns the integer values belonging to a datapoint', focus: false do
    expect(@interleave_datapoint_gleason_primary.integer_values('value_as_number')).to match_array([1,2,3,4,5])
  end

  it 'returns the concepts belonging to a datapoint with restricted concepts by column', focus: false do
    expect(@interleave_datapoint_diagnosis.concept_values('condition_concept_id')).to match_array([@concept_condition_neoplasam_of_prostate, @concept_condition_benign_prostatic_hyperplasia])
    expect(@interleave_datapoint_diagnosis.concept_values('condition_type_concept_id')).to match_array([@concept_condition_type_ehr_problem_list_entry])
  end

  it 'searches the concepts belonging to a datapoint with restricted concepts case insensitively by column', focus: false do
    expect(@interleave_datapoint_diagnosis.concept_values('condition_concept_id', 'plasm')).to match_array([@concept_condition_neoplasam_of_prostate])
    expect(@interleave_datapoint_diagnosis.concept_values('condition_concept_id','PLASM')).to match_array([@concept_condition_neoplasam_of_prostate])
    expect(@interleave_datapoint_diagnosis.concept_values('condition_type_concept_id', 'ehr')).to match_array([@concept_condition_type_ehr_problem_list_entry])
    expect(@interleave_datapoint_diagnosis.concept_values('condition_type_concept_id','EHR')).to match_array([@concept_condition_type_ehr_problem_list_entry])
  end

  it 'returns the concepts belonging to a datapoint with unrestricted concepts by column', focus: false do
    expect(@interleave_datapoint_comorbidities.concept_values('condition_concept_id')).to match_array([@concept_condition_neoplasam_of_prostate, @concept_condition_benign_prostatic_hyperplasia, @concept_condition_glioblastoma_multiforme, @concept_condition_pituitary_adenoma])
    expect(@interleave_datapoint_comorbidities.concept_values('condition_type_concept_id')).to match_array([@concept_condition_type_ehr_chief_complaint, @concept_condition_type_ehr_episode_entry, @concept_condition_type_ehr_problem_list_entry])
  end

  it 'searches the concepts belonging to a datapoint with unrestricted concepts case insensitively by column', focus: false do
    expect(@interleave_datapoint_comorbidities.concept_values('condition_concept_id', 'adenom')).to match_array([@concept_condition_pituitary_adenoma])
    expect(@interleave_datapoint_comorbidities.concept_values('condition_concept_id', 'ADENOM')).to match_array([@concept_condition_pituitary_adenoma])

    expect(@interleave_datapoint_comorbidities.concept_values('condition_type_concept_id', 'problem')).to match_array([@concept_condition_type_ehr_problem_list_entry])
    expect(@interleave_datapoint_comorbidities.concept_values('condition_type_concept_id', 'PROBLEM')).to match_array([@concept_condition_type_ehr_problem_list_entry])
  end

  it 'initializess sub datapoint entities', focus: false do
    actual_entities = @interleave_datapoint_biopsy.initialize_sub_datapoint_entities.map do |e|
      { person_id: nil, measurement_concept_id: e.measurement_concept_id, measurement_date: nil, value_as_concept_id: nil, value_as_number: nil, measurement_type_concept_id: e.measurement_type_concept_id }
    end
    expected_entities = [{ person_id: nil, measurement_concept_id: @concept_measurement_total_number_of_cores.concept_id, measurement_date: nil, value_as_concept_id: nil, value_as_number: nil, measurement_type_concept_id: @concept_pathology_finding.concept_id },{ person_id: nil, measurement_concept_id: @concept_measurement_total_number_of_cores_positive.concept_id, measurement_date: nil, value_as_concept_id: nil, value_as_number: nil, measurement_type_concept_id: @concept_pathology_finding.concept_id }]
    expect(expected_entities).to match_array(actual_entities)
  end

  it 'initializes sub datapoint entities from an existing interleave entity', focus: false do
    procedure_occurrence_1 = FactoryGirl.build(:procedure_occurrence, person: @person_little_my, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, procedure_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_biopsy.id, quantity: 1)
    sub_datapoint_entities = @interleave_datapoint_biopsy.initialize_sub_datapoint_entities
    measurements = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    expect(Measurement.count).to eq(0)
    procedure_occurrence_1.create_with_sub_datapoints!(@interleave_registry_cdm_source, measurements: measurements)

    actual_entities = @interleave_datapoint_biopsy.initialize_sub_datapoint_entities(procedure_occurrence_1.interleave_entity).map do |e|
      { person_id: nil, measurement_concept_id: e.measurement_concept_id, measurement_date: nil, value_as_concept_id: nil, value_as_number: nil, measurement_type_concept_id: e.measurement_type_concept_id }
    end
    expected_entities = [{ person_id: nil, measurement_concept_id: @concept_measurement_total_number_of_cores.concept_id, measurement_date: nil, value_as_concept_id: nil, value_as_number: nil, measurement_type_concept_id: @concept_pathology_finding.concept_id },{ person_id: nil, measurement_concept_id: @concept_measurement_total_number_of_cores_positive.concept_id, measurement_date: nil, value_as_concept_id: nil, value_as_number: nil, measurement_type_concept_id: @concept_pathology_finding.concept_id }]

    expect(expected_entities).to match_array(actual_entities)
  end

  it 'knows if a column is hardcoded', focus: false do
    interleave_datapoint = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Hardcoded', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: interleave_datapoint, column: 'measurement_concept_id', concept: @concept_measurement_total_number_of_cores, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: interleave_datapoint, column: 'measurement_type_concept_id', concept: @concept_pathology_finding, hardcoded: false)
    expect(interleave_datapoint.hardcoded?('measurement_concept_id')).to be_truthy
    expect(interleave_datapoint.hardcoded?('measurement_type_concept_id')).to be_falsy
    expect(interleave_datapoint.hardcoded?('operator_concept_id')).to be_falsy
  end

  it 'initializes defaults', focus: false do
    measurement = FactoryGirl.build(:measurement, person:  @person_little_my, measurement_concept: nil, measurement_type_concept: nil, measurement_date: nil, interleave_datapoint_id: @interleave_datapoint_weight.id)
    @interleave_datapoint_weight.initialize_defaults(measurement)
    expect(measurement.measurement_concept_id).to eq(@concept_measurement_body_weight_measured.id)
    expect(measurement.measurement_type_concept_id).to eq(@concept_lab_result.id)
  end
end