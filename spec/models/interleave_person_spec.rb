require 'rails_helper'
RSpec.describe InterleavePerson, type: :model do
  it { should belong_to :interleave_registry_affiliate }
  it { should belong_to :person }
  it { should have_many :interleave_person_identifiers }

  before(:each) do
    interleave_spec_setup
    @interleave_registry_prostate = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_affiliate_northwestern = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry_prostate)
    @interleave_registry_affiliate_north_shore = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northshore', interleave_registry: @interleave_registry_prostate)
    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_little_my = FactoryGirl.create(:interleave_person, person: @person_little_my, first_name: 'Little', last_name: 'My', middle_name: 'Miss', interleave_registry_affiliate: @interleave_registry_affiliate_northwestern)
    @person_sniff = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_sniff = FactoryGirl.create(:interleave_person, person: @person_sniff, first_name: 'Sniff', last_name: 'Sniff', middle_name: 'Mister', interleave_registry_affiliate: @interleave_registry_affiliate_northwestern)
    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_moomin = FactoryGirl.create(:interleave_person, person: @person_moomin, first_name: 'Moomintroll', last_name: 'Moomin', middle_name: 'Mister', interleave_registry_affiliate: @interleave_registry_affiliate_north_shore)
    @person_the_groke = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_the_groke = FactoryGirl.create(:interleave_person, person: @person_the_groke, first_name: 'The', last_name: 'Groke', middle_name: 'Mister', interleave_registry_affiliate: @interleave_registry_affiliate_north_shore)

    @interleave_registry_breast = FactoryGirl.create(:interleave_registry, name: 'Breast SPORE')
    @interleave_registry_affiliate_northwestern_2 = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry_breast)
    @interleave_registry_affiliate_north_shore_2 = FactoryGirl.create(:interleave_registry_affiliate, name: 'NorthShore', interleave_registry: @interleave_registry_breast)
    @person_chrlie_brown = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_charilie_brown = FactoryGirl.create(:interleave_person, person: @person_chrlie_brown, first_name: 'Charlie', last_name: 'Brown', middle_name: 'Mister', interleave_registry_affiliate: @interleave_registry_affiliate_northwestern_2)
  end

  it 'reports a full name', focus: false do
    expect(@interleave_person_little_my.full_name).to eq('Little Miss My')
  end

  it 'searches across fields within a registry', focus: false do
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate)).to match_array([@interleave_person_little_my, @interleave_person_sniff, @interleave_person_moomin, @interleave_person_the_groke])
  end

  it 'searches across fields within a registry on an affliate', focus: false do
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate, affiliate_id: @interleave_registry_affiliate_northwestern.id)).to match_array([@interleave_person_little_my, @interleave_person_sniff])
  end

  it 'searches across fields within a registry on first name case insensitively', focus: false do
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate, search: 'sniff')).to match_array([@interleave_person_sniff])
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate, search: 'SNIFF')).to match_array([@interleave_person_sniff])
  end

  it 'searches across fields within a registry on last name case insensitively', focus: false do
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate, search: 'My')).to match_array([@interleave_person_little_my])
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate, search: 'MY')).to match_array([@interleave_person_little_my])
  end

  it 'searches across fields within a registry and sorts as specified', focus: false do
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate, sort_column: 'last_name', sort_direction: 'asc')).to eq([ @interleave_person_the_groke, @interleave_person_moomin, @interleave_person_little_my, @interleave_person_sniff])
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate, sort_column: 'last_name', sort_direction: 'desc')).to eq([@interleave_person_sniff, @interleave_person_little_my, @interleave_person_moomin, @interleave_person_the_groke])
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate, sort_column: 'first_name', sort_direction: 'asc')).to eq([@interleave_person_little_my, @interleave_person_moomin, @interleave_person_sniff, @interleave_person_the_groke])
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate, sort_column: 'first_name', sort_direction: 'desc')).to eq([@interleave_person_the_groke, @interleave_person_sniff, @interleave_person_moomin, @interleave_person_little_my])
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate, sort_column: 'interleave_registry_affiliates.name', sort_direction: 'asc')).to eq([@interleave_person_moomin, @interleave_person_the_groke, @interleave_person_little_my, @interleave_person_sniff])
    expect(InterleavePerson.search_across_fields(@interleave_registry_prostate, sort_column: 'interleave_registry_affiliates.name', sort_direction: 'desc')).to eq([@interleave_person_little_my, @interleave_person_sniff, @interleave_person_moomin, @interleave_person_the_groke])
  end
end