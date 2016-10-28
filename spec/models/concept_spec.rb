require 'rails_helper'

RSpec.describe Concept, type: :model do
  before(:each) do
    concept_id = 0
    @concepts = []
    @concepts << @concept_condition_type = FactoryGirl.create(:concept_condition_type, concept_id: concept_id+=1, concept_name: 'moomin')
    @concepts << @concept_death_type = FactoryGirl.create(:concept_death_type, concept_id: concept_id+=1, concept_name: 'tove')
    @concepts << @concept_domain = FactoryGirl.create(:concept_domain, concept_id: concept_id+=1, concept_name: 'peanut')
    @concepts << @concept_drug_type = FactoryGirl.create(:concept_drug_type, concept_id: concept_id+=1, concept_name: 'sniff')
    @concepts << @concept_measurement_type = FactoryGirl.create(:concept_measurement_type, concept_id: concept_id+=1, concept_name: 'charlie brown')
    @concepts << @concept_observation_type = FactoryGirl.create(:concept_observation_type, concept_id: concept_id+=1, concept_name: 'fillyjonk')
    @concepts << @concept_procedure_type = FactoryGirl.create(:concept_procedure_type, concept_id: concept_id+=1, concept_name: 'little my')
    @concepts << @concept_route = FactoryGirl.create(:concept_route, concept_id: concept_id+=1, concept_name: 'lucy')
    @concepts << @concept_unit = FactoryGirl.create(:concept_unit, concept_id: concept_id+=1, concept_name: 'groke')
  end

  it 'reports standard concepts', focus: false do
    expect(Concept.standard).to match_array(@concepts - [@concept_domain])
    @concept_condition_type.standard_concept = nil
    @concept_condition_type.save
    expect(Concept.standard).to match_array(@concepts - [@concept_condition_type, @concept_domain])
  end

  it 'reports valid concepts', focus: false do
    expect(Concept.valid).to match_array(@concepts)
    @concept_condition_type.invalid_reason = 'U'
    @concept_condition_type.save!
    expect(Concept.valid).to match_array(@concepts - [@concept_condition_type])
  end

  it 'reports condition type concepts', focus: false do
    expect(Concept.condition_types).to match_array([@concept_condition_type])
  end

  it 'reports death type concepts', focus: false do
    expect(Concept.death_types).to match_array([@concept_death_type])
  end

  it 'reports domain concepts', focus: false do
    expect(Concept.domain_concepts).to match_array([@concept_domain])
  end

  it 'reports drug types', focus: false do
    expect(Concept.drug_types).to match_array([@concept_drug_type])
  end

  it 'reports measurement types', focus: false do
    expect(Concept.measurement_types).to match_array([@concept_measurement_type])
  end

  it 'reports observation type concepts', focus: false do
    expect(Concept.observation_types).to match_array([@concept_observation_type])
  end

  it 'reports procedure type concepts', focus: false do
    expect(Concept.procedure_types).to match_array([@concept_procedure_type])
  end

  it 'reports route concepts', focus: false do
    expect(Concept.routes).to match_array([@concept_route])
  end

  it 'reports unit concepts', focus: false do
    expect(Concept.units).to match_array([@concept_unit])
  end
end