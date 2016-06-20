require 'rails_helper'
RSpec.describe InterleaveRegistry, type: :model do
  it { should have_many :interleave_registry_affiliates }
  it { should have_many :interleave_registry_cdm_sources }
  it { should have_many :interleave_datapoints }

  before(:each) do
    interleave_spec_setup
    @interleave_registry_prostate = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_breast = FactoryGirl.create(:interleave_registry, name: 'Breast SPORE')
  end

  it 'searches across fields within a registry', focus: false do
    expect(InterleaveRegistry.search_across_fields(nil)).to match_array([@interleave_registry_breast, @interleave_registry_prostate])
  end

  it 'searches across fields within a registry on name case insensitively', focus: false do
    expect(InterleaveRegistry.search_across_fields('breast')).to match_array([@interleave_registry_breast])
    expect(InterleaveRegistry.search_across_fields('BREAST')).to match_array([@interleave_registry_breast])
  end

  it 'searches across fields within a registry and sorts as specified', focus: false do
    expect(InterleaveRegistry.search_across_fields(nil, sort_column: 'name', sort_direction: 'asc')).to eq([@interleave_registry_breast, @interleave_registry_prostate])
    expect(InterleaveRegistry.search_across_fields(nil, sort_column: 'name', sort_direction: 'desc')).to eq([@interleave_registry_prostate, @interleave_registry_breast])
  end
end