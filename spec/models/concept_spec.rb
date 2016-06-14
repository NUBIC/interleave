require 'rails_helper'

RSpec.describe Concept, type: :model do
  before(:all) do
    @concept_condition_type = FactoryGirl.create(:concept_condition_type, concept_id: 1, concept_name: 'moomin')
    @concept_domain = FactoryGirl.create(:concept_domain, concept_id: 2, concept_name: 'peanut')
  end
  it 'reports condition type concepts', focus: false do
    expect(Concept.condition_types).to match_array([@concept_condition_type])
  end

  it 'reports domain concepts', focus: false do
    expect(Concept.domain_concepts).to match_array([@concept_domain])
  end

  it 'reports standard concepts', focus: false do
    expect(Concept.standard).to match_array([@concept_condition_type])
    @concept_condition_type.standard_concept = nil
    @concept_condition_type.save
    expect(Concept.standard).to be_empty
  end

  it 'reports valid concepts', focus: true do
    expect(Concept.valid).to match_array([@concept_condition_type, @concept_domain])
    @concept_condition_type.invalid_reason = 'U'
    @concept_condition_type.save!
    expect(Concept.valid).to match_array([@concept_domain])
  end
end
