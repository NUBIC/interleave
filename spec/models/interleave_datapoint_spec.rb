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
    FactoryGirl.create(:interleave_datapoint_concept, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_neoplasam_of_prostate)
    FactoryGirl.create(:interleave_datapoint_concept, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_benign_prostatic_hyperplasia)
  end

  it 'returns the concepts belonging to a datapoint with restricted concepts  ', focus: false do
    expect(@interleave_datapoint_diagnosis.concepts).to match_array([@concept_condition_neoplasam_of_prostate, @concept_condition_benign_prostatic_hyperplasia])
  end

  it 'searches the concepts belonging to a datapoint with restricted concepts case insensitively', focus: false do
    expect(@interleave_datapoint_diagnosis.concepts('plasm')).to match_array([@concept_condition_neoplasam_of_prostate])
    expect(@interleave_datapoint_diagnosis.concepts('PLASM')).to match_array([@concept_condition_neoplasam_of_prostate])
  end

  it 'returns the concepts belonging to a datapoint with unrestricted concepts  ', focus: false do
    expect(@interleave_datapoint_comorbidities.concepts).to match_array([@concept_condition_neoplasam_of_prostate, @concept_condition_benign_prostatic_hyperplasia, @concept_condition_glioblastoma_multiforme, @concept_condition_pituitary_adenoma])
  end

  it 'searches the concepts belonging to a datapoint with restricted concepts case insensitively', focus: false do
    expect(@interleave_datapoint_comorbidities.concepts('adenom')).to match_array([@concept_condition_pituitary_adenoma])
    expect(@interleave_datapoint_comorbidities.concepts('ADENOM')).to match_array([@concept_condition_pituitary_adenoma])
  end
end