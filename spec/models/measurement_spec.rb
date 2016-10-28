require 'rails_helper'
require 'active_support'

RSpec.describe Measurement, type: :model do
  it { should belong_to :measurement_concept }
  it { should belong_to :measurement_type_concept }
  it { should belong_to :person }
  it { should validate_presence_of :measurement_concept_id }
  it { should validate_presence_of :measurement_date }
  it { should validate_presence_of :measurement_type_concept_id }
  it { should validate_presence_of :interleave_datapoint_id }

  before(:each) do
    interleave_spec_setup
    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_registry = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_affiliate = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry)
    @interleave_registry_cdm_source = FactoryGirl.create(:interleave_registry_cdm_source, cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: @interleave_registry)
    @interleave_datapoint_diagnosis = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Diagnosis', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 1, overlap: true)
    @interleave_datapoint_psa_lab = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'PSA Lab', domain_id: Measurement::DOMAIN_ID, cardinality: 0, overlap: false)
    @interleave_datapoint_weight = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Weight', domain_id: Measurement::DOMAIN_ID, cardinality: 0, overlap: false)
    @interleave_datapoint_height = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Height', domain_id: Measurement::DOMAIN_ID, cardinality: 0, overlap: false)
  end

  it 'creates an interleave entity upon save with sub datapoints', focus: false do
    measurement_1 = FactoryGirl.build(:measurement, person:  @person_little_my, measurement_concept: @psa_concept_1, measurement_type_concept: @concept_lab_result, measurement_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_psa_lab.id)
    measurement_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    expect(InterleaveEntity.where(interleave_datapoint_id: @interleave_datapoint_psa_lab, cdm_table: Measurement.table_name, fact_id: measurement_1.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source).count).to eq(1)
  end

  it 'reports measurements by person', focus: false do
    measurement_1 = FactoryGirl.build(:measurement, person:  @person_little_my, measurement_concept: @psa_concept_1, measurement_type_concept: @concept_lab_result, measurement_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_psa_lab.id)
    measurement_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    measurement_2 = FactoryGirl.build(:measurement, person:  @person_moomin, measurement_concept: @psa_concept_2, measurement_type_concept: @concept_lab_result, measurement_date: Date.parse('2/1/2016'), interleave_datapoint_id: @interleave_datapoint_psa_lab.id)
    measurement_2.create_with_sub_datapoints!(@interleave_registry_cdm_source)

    expect(Measurement.by_person(@person_little_my.person_id)).to match_array([measurement_1])
  end

  it 'reports measurements by interleave datapoint', focus: false do
    measurement_1 = FactoryGirl.build(:measurement, person:  @person_little_my, measurement_concept: @psa_concept_1, measurement_type_concept: @concept_lab_result, measurement_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_psa_lab.id)
    measurement_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    measurement_2 = FactoryGirl.build(:measurement, person:  @person_little_my, measurement_concept: @concept_measurement_body_weight_measured, measurement_type_concept: @concept_lab_result, measurement_date: Date.parse('2/1/2016'), interleave_datapoint_id: @interleave_datapoint_weight.id)
    measurement_2.create_with_sub_datapoints!(@interleave_registry_cdm_source)

    expect(Measurement.by_interleave_data_point(@interleave_datapoint_psa_lab.id)).to match_array([measurement_1])
  end

  it 'knows its domain concept', focus: false do
    expect(ConditionOccurrence.domain_concept).to eq(@concept_domain_condition)
  end
end