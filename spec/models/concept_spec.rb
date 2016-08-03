require 'rails_helper'

RSpec.describe Concept, type: :model do
  before(:each) do
    @concept_condition_type = FactoryGirl.create(:concept_condition_type, concept_id: 1, concept_name: 'moomin')
    @concept_procedure_type = FactoryGirl.create(:concept_procedure_type, concept_id: 2, concept_name: 'little my')
    @concept_measurement_type = FactoryGirl.create(:concept_measurement_type, concept_id: 4, concept_name: 'charlie brown')
    @concept_domain = FactoryGirl.create(:concept_domain, concept_id: 3, concept_name: 'peanut')
  end

  it 'reports condition type concepts', focus: false do
    expect(Concept.condition_types).to match_array([@concept_condition_type])
  end

  it 'reports procedure type concepts', focus: false do
    expect(Concept.procedure_types).to match_array([@concept_procedure_type])
  end

  it 'reports domain concepts', focus: false do
    expect(Concept.domain_concepts).to match_array([@concept_domain])
  end

  it 'reports measurement types', focus: false do
    expect(Concept.measurement_types).to match_array([@concept_measurement_type])
  end

  it 'reports standard concepts', focus: false do
    expect(Concept.standard).to match_array([@concept_condition_type, @concept_procedure_type, @concept_measurement_type])
    @concept_condition_type.standard_concept = nil
    @concept_condition_type.save
    expect(Concept.standard).to match_array([@concept_procedure_type, @concept_measurement_type])
  end

  it 'reports valid concepts', focus: false do
    expect(Concept.valid).to match_array([@concept_condition_type, @concept_procedure_type, @concept_domain, @concept_measurement_type])
    @concept_condition_type.invalid_reason = 'U'
    @concept_condition_type.save!
    expect(Concept.valid).to match_array([@concept_procedure_type, @concept_domain, @concept_measurement_type])
  end
end