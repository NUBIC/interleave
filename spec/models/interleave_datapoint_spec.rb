require 'rails_helper'
include InterleaveSpecSetup
RSpec.describe InterleaveDatapoint, type: :model do
  it { should belong_to :interleave_registry }
  it { should have_many :interleave_datapoint_concepts }

  before(:each) do
    interleave_spec_setup
    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_registry = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_affiliate = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry)
    @interleave_registry_cdm_source = FactoryGirl.create(:interleave_registry_cdm_source, cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: @interleave_registry)
    @interleave_datapoint_diagnosis = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Diagnosis', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 1, unrestricted: false, overlap: true)
    @interleave_datapoint_comorbidities = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Comorbidities', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 0, unrestricted: true, overlap: false)
    FactoryGirl.create(:interleave_datapoint_concept, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_neoplasam_of_prostate, column: 'condition_concept_id')
    FactoryGirl.create(:interleave_datapoint_concept, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_benign_prostatic_hyperplasia, column: 'condition_concept_id')
    FactoryGirl.create(:interleave_datapoint_concept, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_type_ehr_problem_list_entry, column: 'condition_type_concept_id')
  end

  it 'returns the concepts belonging to a datapoint with restricted concepts by column', focus: false do
    expect(@interleave_datapoint_diagnosis.concepts('condition_concept_id')).to match_array([@concept_condition_neoplasam_of_prostate, @concept_condition_benign_prostatic_hyperplasia])
    expect(@interleave_datapoint_diagnosis.concepts('condition_type_concept_id')).to match_array([@concept_condition_type_ehr_problem_list_entry])
  end

  it 'searches the concepts belonging to a datapoint with restricted concepts case insensitively by column', focus: false do
    expect(@interleave_datapoint_diagnosis.concepts('condition_concept_id', 'plasm')).to match_array([@concept_condition_neoplasam_of_prostate])
    expect(@interleave_datapoint_diagnosis.concepts('condition_concept_id','PLASM')).to match_array([@concept_condition_neoplasam_of_prostate])
    expect(@interleave_datapoint_diagnosis.concepts('condition_type_concept_id', 'ehr')).to match_array([@concept_condition_type_ehr_problem_list_entry])
    expect(@interleave_datapoint_diagnosis.concepts('condition_type_concept_id','EHR')).to match_array([@concept_condition_type_ehr_problem_list_entry])
  end

  it 'returns the concepts belonging to a datapoint with unrestricted concepts by column', focus: false do
    expect(@interleave_datapoint_comorbidities.concepts('condition_concept_id')).to match_array([@concept_condition_neoplasam_of_prostate, @concept_condition_benign_prostatic_hyperplasia, @concept_condition_glioblastoma_multiforme, @concept_condition_pituitary_adenoma])
    expect(@interleave_datapoint_comorbidities.concepts('condition_type_concept_id')).to match_array([@concept_condition_type_ehr_chief_complaint, @concept_condition_type_ehr_episode_entry, @concept_condition_type_ehr_problem_list_entry])
  end

  it 'searches the concepts belonging to a datapoint with restricted concepts case insensitively by column', focus: false do
    expect(@interleave_datapoint_comorbidities.concepts('condition_concept_id', 'adenom')).to match_array([@concept_condition_pituitary_adenoma])
    expect(@interleave_datapoint_comorbidities.concepts('condition_concept_id', 'ADENOM')).to match_array([@concept_condition_pituitary_adenoma])

    expect(@interleave_datapoint_comorbidities.concepts('condition_type_concept_id', 'problem')).to match_array([@concept_condition_type_ehr_problem_list_entry])
    expect(@interleave_datapoint_comorbidities.concepts('condition_type_concept_id', 'PROBLEM')).to match_array([@concept_condition_type_ehr_problem_list_entry])
  end
end