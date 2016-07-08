require 'rails_helper'
include InterleaveSpecSetup
RSpec.describe InterleaveDatapointDefaultValue, type: :model do
  it { should belong_to :interleave_datapoint }
  it { should belong_to :concept }

  before(:each) do
    interleave_spec_setup
    @interleave_registry = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_datapoint_biopsy_total_number_of_cores_positive = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Total number of cores positive', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER)
  end

  it 'reports its value as a concept id', focus: false do
    interleave_datapoint_default_value = FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores_positive, column: 'measurement_concept_id', concept: @concept_measurement_total_number_of_cores_positive, hardcoded: true)
    expect(interleave_datapoint_default_value.value_as).to eq(@concept_measurement_total_number_of_cores_positive.concept_id)
  end

  it 'reports its value as a string', focus: false do
    string_value = 'moomin'
    interleave_datapoint_default_value = FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores_positive, column: 'measurement_concept_id', default_value_as_string: string_value, hardcoded: true)
    expect(interleave_datapoint_default_value.value_as).to eq(string_value)
  end

  it 'reports its value as a number', focus: false do
    number_value = 20
    interleave_datapoint_default_value = FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores_positive, column: 'measurement_concept_id', default_value_as_number: number_value, hardcoded: true)
    expect(interleave_datapoint_default_value.value_as).to eq(number_value)
  end
end