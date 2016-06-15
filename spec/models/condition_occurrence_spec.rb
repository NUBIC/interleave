require 'rails_helper'

RSpec.describe ConditionOccurrence, type: :model do
  it { should belong_to :condition_concept }
  it { should belong_to :condition_type_concept }
  it { should belong_to :person }
  it { should validate_presence_of :condition_concept_id }
  it { should validate_presence_of :condition_start_date }
  it { should validate_presence_of :condition_end_date }
  it { should validate_presence_of :condition_type_concept_id }
  it { should validate_presence_of :interleave_datapoint_id }
  it { should validate_presence_of :interleave_registry_cdm_source_id }

  before(:all) do
    @concept_gender_male = FactoryGirl.create(:concept_gender_male, concept_id: 1)
    @concept_gender_female = FactoryGirl.create(:concept_gender_female, concept_id: 2)

    @concept_race_american_indian_or_alaska_native = FactoryGirl.create(:concept_race_american_indian_or_alaska_native, concept_id: 3)
    @concept_race_asian = FactoryGirl.create(:concept_race_asian, concept_id: 4)
    @concept_race_black_or_african_american = FactoryGirl.create(:concept_race_black_or_african_american, concept_id: 5)
    @concept_race_native_hawaiian_or_other_pacific_islander = FactoryGirl.create(:concept_race_native_hawaiian_or_other_pacific_islander, concept_id: 6)
    @concept_race_white = FactoryGirl.create(:concept_race_white, concept_id: 7)

    @concept_ethnicity_hispanic_or_latino = FactoryGirl.create(:concept_ethnicity_hispanic_or_latino, concept_id: 8)
    @concept_ethnicity_not_hispanic_or_latino = FactoryGirl.create(:concept_ethnicity_not_hispanic_or_latino, concept_id: 9)

    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)

    @concept_condition_neoplasam_of_prostate = FactoryGirl.create(:concept_condition, concept_name: 'Neoplasm of prostate', concept_code: '126906006', concept_id: 10)
    @concept_condition_benign_prostatic_hyperplasia = FactoryGirl.create(:concept_condition, concept_name: 'Benign prostatic hyperplasia', concept_code: '266569009', concept_id: 11)
    @concept_condition_glioblastoma_multiforme = FactoryGirl.create(:concept_condition, concept_name: 'Glioblastoma multiforme', concept_code: '393563007', concept_id: 12)
    @concept_condition_pituitary_adenoma = FactoryGirl.create(:concept_condition, concept_name: 'Pituitary adenoma', concept_code: '254956000', concept_id: 13)

    @concept_condition_type_ehr_chief_complaint = FactoryGirl.create(:concept_condition_type, concept_name: 'EHR Chief Complaint' ,concept_id: 14)
    @concept_condition_type_ehr_episode_entry = FactoryGirl.create(:concept_condition_type, concept_name: 'EHR Episode Entry' ,concept_id: 15)
    @concept_condition_type_ehr_problem_list_entry = FactoryGirl.create(:concept_condition_type, concept_name: 'EHR problem list entry' ,concept_id: 16)

    @concept_domain_condition = FactoryGirl.create(:concept_domain, concept_name: 'Condition', concept_id: 17)

    @interleave_registry = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_affiliate = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry)
    @interleave_registry_cdm_source = FactoryGirl.create(:interleave_registry_cdm_source, cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: @interleave_registry)
    @interleave_datapoint_diagnosis = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Diagnosis', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 1, unrestricted: false, overlap: true)
    @interleave_datapoint_comorbidities = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Comorbidities', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 0, unrestricted: true, overlap: false)
  end

  it 'creates an interleave entity upon creation', focus: false do
    condition_occurrence_1 = FactoryGirl.create(:condition_occurrence, person:  @person_little_my, condition_concept: @concept_condition_glioblastoma_multiforme, condition_type_concept: @concept_condition_type_ehr_chief_complaint, condition_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_diagnosis.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id)
    expect(InterleaveEntity.where(interleave_datapoint_id: @interleave_datapoint_diagnosis, cdm_table: ConditionOccurrence.table_name, domain_concept_id: ConditionOccurrence.domain_concept.id, fact_id: condition_occurrence_1.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source).count).to eq(1)
  end

  it 'reports condition occurrences by person', focus: false do
    condition_occurrence_1 = FactoryGirl.create(:condition_occurrence, person:  @person_little_my, condition_concept: @concept_condition_glioblastoma_multiforme, condition_type_concept: @concept_condition_type_ehr_chief_complaint, condition_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_diagnosis.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id)
    condition_occurrence_2 = FactoryGirl.create(:condition_occurrence, person:  @person_moomin, condition_concept: @concept_condition_neoplasam_of_prostate, condition_type_concept: @concept_condition_type_ehr_chief_complaint, condition_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_diagnosis.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id)

    expect(ConditionOccurrence.by_person(@person_little_my.person_id)).to match_array([condition_occurrence_1])
  end

  it 'reports condition occurrences by interleave datapoint', focus: false do
    condition_occurrence_1 = FactoryGirl.create(:condition_occurrence, person:  @person_little_my, condition_concept: @concept_condition_glioblastoma_multiforme, condition_type_concept: @concept_condition_type_ehr_chief_complaint, condition_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_diagnosis.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id)
    condition_occurrence_2 = FactoryGirl.create(:condition_occurrence, person:  @person_little_my, condition_concept: @concept_condition_neoplasam_of_prostate, condition_type_concept: @concept_condition_type_ehr_chief_complaint, condition_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_comorbidities.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id)
    expect(ConditionOccurrence.by_interleave_data_point(@interleave_datapoint_diagnosis.id)).to match_array([condition_occurrence_1])
  end

  it 'knows its domain concept', focus: false do
    expect(ConditionOccurrence.domain_concept).to eq(@concept_domain_condition)
  end
end