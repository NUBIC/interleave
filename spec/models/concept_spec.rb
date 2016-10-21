require 'rails_helper'

RSpec.describe Concept, type: :model do
  before(:each) do
    @concept_condition_type = FactoryGirl.create(:concept_condition_type, concept_id: 1, concept_name: 'moomin')
    @concept_domain = FactoryGirl.create(:concept_domain, concept_id: 2, concept_name: 'peanut')
    @concept_drug_type = FactoryGirl.create(:concept_drug_type, concept_id: 3, concept_name: 'sniff')
    @concept_measurement_type = FactoryGirl.create(:concept_measurement_type, concept_id: 4, concept_name: 'charlie brown')
    @concept_observation_type = FactoryGirl.create(:concept_observation_type, concept_id: 5, concept_name: 'fillyjonk')
    @concept_procedure_type = FactoryGirl.create(:concept_procedure_type, concept_id: 6, concept_name: 'little my')
    @concept_route = FactoryGirl.create(:concept_route, concept_id: 7, concept_name: 'lucy')
    @concept_unit = FactoryGirl.create(:concept_unit, concept_id: 8, concept_name: 'groke')
  end

  it 'reports standard concepts', focus: false do
    expect(Concept.standard).to match_array([@concept_condition_type, @concept_drug_type, @concept_measurement_type, @concept_procedure_type, @concept_route, @concept_unit, @concept_observation_type])
    @concept_condition_type.standard_concept = nil
    @concept_condition_type.save
    expect(Concept.standard).to match_array([@concept_drug_type, @concept_measurement_type, @concept_procedure_type, @concept_route, @concept_unit, @concept_observation_type])
  end

  it 'reports valid concepts', focus: false do
    expect(Concept.valid).to match_array([@concept_condition_type, @concept_domain, @concept_drug_type, @concept_measurement_type, @concept_procedure_type, @concept_route, @concept_unit, @concept_observation_type])
    @concept_condition_type.invalid_reason = 'U'
    @concept_condition_type.save!
    expect(Concept.valid).to match_array([@concept_domain, @concept_drug_type, @concept_measurement_type, @concept_procedure_type, @concept_route, @concept_unit, @concept_observation_type])
  end

  it 'reports condition type concepts', focus: false do
    expect(Concept.condition_types).to match_array([@concept_condition_type])
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