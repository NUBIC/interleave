require 'rails_helper'

RSpec.describe ConditionOccurrence, type: :model do
  it { should belong_to :condition_concept }
  it { should belong_to :condition_type_concept }
  it { should belong_to :person }
  it { should validate_presence_of :condition_concept_id }
  it { should validate_presence_of :condition_start_date }
  it { should validate_presence_of :condition_type_concept_id }
  it { should validate_presence_of :interleave_datapoint_id }

  before(:each) do
    interleave_spec_setup
    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_registry = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_affiliate = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry)
    @interleave_registry_cdm_source = FactoryGirl.create(:interleave_registry_cdm_source, cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: @interleave_registry)
    @interleave_datapoint_diagnosis = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Diagnosis', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 1, overlap: true)
    @interleave_datapoint_comorbidities = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Comorbidities', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 0, overlap: false)
  end

  it 'creates an interleave entity upon save with sub datapoints', focus: false do
    condition_occurrence_1 = FactoryGirl.build(:condition_occurrence, person:  @person_little_my, condition_concept: @concept_condition_glioblastoma_multiforme, condition_type_concept: @concept_condition_type_ehr_chief_complaint, condition_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_diagnosis.id)
    condition_occurrence_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    expect(InterleaveEntity.where(interleave_datapoint_id: @interleave_datapoint_diagnosis, cdm_table: ConditionOccurrence.table_name, domain_concept_id: ConditionOccurrence.domain_concept.id, fact_id: condition_occurrence_1.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source).count).to eq(1)
  end

  it 'reports condition occurrences by person', focus: false do
    condition_occurrence_1 = FactoryGirl.create(:condition_occurrence, person:  @person_little_my, condition_concept: @concept_condition_glioblastoma_multiforme, condition_type_concept: @concept_condition_type_ehr_chief_complaint, condition_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_diagnosis.id)
    condition_occurrence_2 = FactoryGirl.create(:condition_occurrence, person:  @person_moomin, condition_concept: @concept_condition_neoplasam_of_prostate, condition_type_concept: @concept_condition_type_ehr_chief_complaint, condition_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_diagnosis.id)

    expect(ConditionOccurrence.by_person(@person_little_my.person_id)).to match_array([condition_occurrence_1])
  end

  it 'reports condition occurrences by interleave datapoint', focus: false do
    condition_occurrence_1 = FactoryGirl.create(:condition_occurrence, person:  @person_little_my, condition_concept: @concept_condition_glioblastoma_multiforme, condition_type_concept: @concept_condition_type_ehr_chief_complaint, condition_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_diagnosis.id)
    condition_occurrence_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    condition_occurrence_2 = FactoryGirl.create(:condition_occurrence, person:  @person_little_my, condition_concept: @concept_condition_neoplasam_of_prostate, condition_type_concept: @concept_condition_type_ehr_chief_complaint, condition_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_comorbidities.id)
    condition_occurrence_2.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    expect(ConditionOccurrence.by_interleave_data_point(@interleave_datapoint_diagnosis.id)).to match_array([condition_occurrence_1])
  end

  it 'knows its domain concept', focus: false do
    expect(ConditionOccurrence.domain_concept).to eq(@concept_domain_condition)
  end
end