require 'rails_helper'
require 'active_support'

RSpec.describe Observation, type: :model do
  it { should belong_to :observation_concept }
  it { should belong_to :observation_type_concept }
  it { should belong_to :value_as_concept }
  it { should belong_to :qualifier_concept }
  it { should belong_to :unit_concept }
  it { should belong_to :person }
  it { should validate_presence_of :observation_concept_id }
  it { should validate_presence_of :observation_date }
  it { should validate_presence_of :observation_type_concept_id }


  before(:each) do
    interleave_spec_setup
    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_registry = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_affiliate = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry)
    @interleave_registry_cdm_source = FactoryGirl.create(:interleave_registry_cdm_source, cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: @interleave_registry)

    #datapoint
    @interleave_datapoint_family_history_of_disease_relationship = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, group_name: 'Family History of Disease', name: 'Family Relationship', domain_id: Observation::DOMAIN_ID, cardinality: 0, overlap: true, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_relationship, column: 'observation_concept_id', concept: @concept_observation_relationship_to_patient_family_member, hardcoded: true)

    @concept_observation_relationship_to_patient_family_member_answers.each do |answer|
      FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_relationship, column: 'value_as_concept_id', concept: answer)
    end

    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_relationship, column: 'observation_type_concept_id', concept: @concept_observation_type_patient_reported, hardcoded: true)

    #sub datapoint
    @interleave_datapoint_family_history_of_disease_disease = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, group_name: nil, name: 'Disease', domain_id: Observation::DOMAIN_ID, cardinality: 0, overlap: true, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_disease, column: 'observation_concept_id', concept: @concept_observation_relationship_to_patient_family_member_disease, hardcoded: true)

    @concept_observation_relationship_to_patient_family_member_disease_answers.each do |answer|
      FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_disease, column: 'value_as_concept_id', concept: answer)
    end

    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_disease, column: 'observation_type_concept_id', concept: @concept_observation_type_patient_reported, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_relationship, interleave_datapoint: @interleave_datapoint_family_history_of_disease_relationship, interleave_sub_datapoint: @interleave_datapoint_family_history_of_disease_disease, relationship_concept_id: @concept_relationship_has_asso_finding.id)

    #sub datapoint
    @interleave_datapoint_family_history_of_disease_age_range = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, group_name: nil, name: 'Age range at diagnosis', domain_id: Observation::DOMAIN_ID, cardinality: 0, overlap: true, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_age_range, column: 'observation_concept_id', concept: @concept_observation_age_range_at_onset_of_disease_family_member, hardcoded: true)

    @concept_observation_age_range_at_onset_of_disease_family_member_answers.each do |answer|
      FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_age_range, column: 'value_as_concept_id', concept: answer)
    end

    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_age_range, column: 'observation_type_concept_id', concept: @concept_observation_type_patient_reported, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_relationship, interleave_datapoint: @interleave_datapoint_family_history_of_disease_relationship, interleave_sub_datapoint: @interleave_datapoint_family_history_of_disease_age_range, relationship_concept_id: @concept_relationship_has_asso_finding.id)
  end

  it 'creates an interleave entity upon create with sub datapoints', focus: false do
    observation_1 = FactoryGirl.create(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id)
    observation_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    expect(InterleaveEntity.where(interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id, cdm_table: Observation.table_name, domain_concept_id: Observation.domain_concept.id, fact_id: observation_1.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source).count).to eq(1)
  end

  it 'creates sub datapoints upon create with sub datapoints', focus: false do
    observation_1 = FactoryGirl.build(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    expect(Observation.count).to eq(0)
    observation_1.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)
    interleave_entity = InterleaveEntity.where(interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship, cdm_table: Observation.table_name, domain_concept_id: Observation.domain_concept.id, fact_id: observation_1.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source).first
    expect(Observation.count).to eq(3)
    expect(interleave_entity.children.count).to eq(2)
    expected_observations = sub_datapoint_entities.map  do |e|
      { person_id: @person_little_my.person_id, observation_concept_id: e.observation_concept_id, observation_date: observation_1.observation_date, value_as_concept_id: e.value_as_concept_id, value_as_number: e.value_as_number, observation_type_concept_id: e.observation_type_concept_id }
    end

    saved_observations = []
    actual_observations = interleave_entity.children.map do |ie|
      saved_observations << o = Observation.find(ie.fact_id)
      { person_id: o.person_id, observation_concept_id: o.observation_concept_id, observation_date: o.observation_date, value_as_concept_id: o.value_as_concept_id, value_as_number: o.value_as_number, observation_type_concept_id: o.observation_type_concept_id }
    end
    expect(expected_observations).to match_array(actual_observations)
    expect(FactRelationship.where(domain_concept_id_1: Observation.domain_concept.concept_id, fact_id_1: observation_1.id, domain_concept_id_2: Observation.domain_concept.concept_id, fact_id_2: saved_observations.map(&:id), relationship_concept_id: @concept_relationship_has_asso_finding.id).count).to eq(2)
  end

  it 'updates sub datapoints upon update with sub datapoints', focus: false do
    concept_brother = Concept.where(concept_code: 'LA10415-0').first
    observation_1 = FactoryGirl.build(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id, value_as_concept: concept_brother)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    expect(Observation.count).to eq(0)
    concept_lung_disease = Concept.where(concept_code: 'LA10531-4').first
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    observations.detect { |observation| observation[:interleave_datapoint_id] == @interleave_datapoint_family_history_of_disease_disease.id }[:value_as_concept_id] = concept_lung_disease.id
    observation_1.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)
    expect(observation_1.reload.value_as_concept).to eq(concept_brother)
    observation_2 = Observation.find(observation_1.interleave_entity.children.detect { |child| child.interleave_datapoint_id ==  @interleave_datapoint_family_history_of_disease_disease.id }.fact_id)
    expect(observation_2.reload.value_as_concept).to eq(concept_lung_disease)
    concept_daughter = Concept.where(concept_code: 'LA10405-1').first
    concept_diabetes = Concept.where(concept_code: 'LA10415-0').first
    observation_1.update_with_sub_datapoints!({ value_as_concept_id: concept_daughter.id }, observations: { observation_2.id => { observation_id: observation_2.id, value_as_concept_id: concept_diabetes.id }})
    expect(observation_1.reload.value_as_concept).to eq(concept_daughter)
    expect(observation_2.reload.value_as_concept).to eq(concept_diabetes)
  end

  it 'reports observations by person', focus: false do
    observation_1 = FactoryGirl.create(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id)
    observation_2 = FactoryGirl.create(:observation, person: @person_moomin, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id)

    expect(Observation.by_person(@person_little_my.person_id)).to match_array([observation_1])
  end

  it 'reports observations by interleave datapoint', focus: false do
    observation_1 = FactoryGirl.build(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    observation_1.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)
    observation_2 = Observation.find(observation_1.reload.interleave_entity.children.detect { |child| child.interleave_datapoint == @interleave_datapoint_family_history_of_disease_disease }.fact_id)

    expect(Observation.by_interleave_data_point(@interleave_datapoint_family_history_of_disease_relationship.id, sort_column: @interleave_datapoint_family_history_of_disease_relationship.id.to_s)).to match_array([observation_1])
    expect(Observation.by_interleave_data_point(@interleave_datapoint_family_history_of_disease_disease.id, sort_column: @interleave_datapoint_family_history_of_disease_relationship.id.to_s)).to match_array([observation_2])
  end

  it 'reports observations by interleave datapoint and can sort by the root observation value', focus: false do
    concept_brother = Concept.where(concept_code: 'LA10415-0').first
    observation_1 = FactoryGirl.build(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id, value_as_concept: concept_brother)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    observation_1.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)

    concept_daughter = Concept.where(concept_code: 'LA10405-1').first
    observation_2 = FactoryGirl.build(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id, value_as_concept: concept_daughter)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    observation_2.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)


    concept_sister = Concept.where(concept_code: 'LA10418-4').first
    observation_3 = FactoryGirl.build(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id, value_as_concept: concept_sister)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    observation_3.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)

    expect(Observation.by_interleave_data_point(@interleave_datapoint_family_history_of_disease_relationship.id, sort_column: @interleave_datapoint_family_history_of_disease_relationship.id.to_s, sort_direction: 'asc')).to eq([observation_1, observation_2, observation_3])
    expect(Observation.by_interleave_data_point(@interleave_datapoint_family_history_of_disease_relationship.id, sort_column: @interleave_datapoint_family_history_of_disease_relationship.id.to_s, sort_direction: 'desc')).to eq([observation_3, observation_2, observation_1])
  end


  it 'reports observations by interleave datapoint and can sort by a non-root observation value', focus: false do
    concept_brother = Concept.where(concept_code: 'LA10415-0').first
    observation_1 = FactoryGirl.build(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id, value_as_concept: concept_brother)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    concept_lung_disease = Concept.where(concept_code: 'LA10531-4').first
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    observations.detect { |observation| observation[:interleave_datapoint_id] == @interleave_datapoint_family_history_of_disease_disease.id }[:value_as_concept_id] = concept_lung_disease.id
    observation_1.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)

    concept_daughter = Concept.where(concept_code: 'LA10405-1').first
    observation_2 = FactoryGirl.build(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id, value_as_concept: concept_daughter)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    concept_heart_disease = Concept.where(concept_code: 'LA10523-1').first
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    observations.detect { |observation| observation[:interleave_datapoint_id] == @interleave_datapoint_family_history_of_disease_disease.id }[:value_as_concept_id] = concept_heart_disease.id
    observation_2.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)

    concept_sister = Concept.where(concept_code: 'LA10418-4').first
    observation_3 = FactoryGirl.build(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id, value_as_concept: concept_sister)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    concept_diabetes = Concept.where(concept_code: 'LA10415-0').first
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    observations.detect { |observation| observation[:interleave_datapoint_id] == @interleave_datapoint_family_history_of_disease_disease.id }[:value_as_concept_id] = concept_diabetes.id
    observation_3.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)

    expect(Observation.by_interleave_data_point(@interleave_datapoint_family_history_of_disease_relationship.id, sort_column: @interleave_datapoint_family_history_of_disease_disease.id.to_s, sort_direction: 'asc')).to eq([observation_3, observation_2, observation_1])
    expect(Observation.by_interleave_data_point(@interleave_datapoint_family_history_of_disease_relationship.id, sort_column: @interleave_datapoint_family_history_of_disease_disease.id.to_s, sort_direction: 'desc')).to eq([observation_1, observation_2, observation_3])
  end


  it 'knows its domain concept', focus: false do
    expect(Observation.domain_concept).to eq(@concept_domain_observation)
  end

  it 'knows its interleave date', focus: false do
    observation_date = Date.parse('1/1/2016')
    observation_1 = FactoryGirl.create(:observation, person: @person_little_my, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: observation_date, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id)
    expect(observation_1.interleave_date).to eq(observation_date)
  end
end