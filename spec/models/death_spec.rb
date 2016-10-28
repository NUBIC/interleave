require 'rails_helper'
require 'active_support'

RSpec.describe Death, type: :model do
  it { should belong_to :death_type_concept }
  it { should belong_to :cause_concept }
  it { should belong_to :person }

  it { should validate_presence_of :death_date }
  it { should validate_presence_of :death_type_concept_id }
  it { should validate_presence_of :cause_concept_id }

  before(:each) do
    interleave_spec_setup
    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_registry = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_affiliate = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry)
    @interleave_registry_cdm_source = FactoryGirl.create(:interleave_registry_cdm_source, cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: @interleave_registry)
    @interleave_datapoint_death = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, group_name: nil, name: 'Death', domain_id: Death::DOMAIN_ID, cardinality: 0, overlap: true)
  end

  it 'creates an interleave entity upon save with sub datapoints', focus: false do
    death_1 = FactoryGirl.build(:death, person: @person_little_my, death_date: Date.parse('1/1/2016'), death_type_concept_id: @death_types_concepts.first.concept_id, cause_concept_id: @concept_condition_neoplasam_of_prostate.concept_id, interleave_datapoint_id: @interleave_datapoint_death.id)
    death_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    expect(InterleaveEntity.where(interleave_datapoint_id: @interleave_datapoint_death, cdm_table: Death.table_name, fact_id: death_1.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source).count).to eq(1)
  end
end