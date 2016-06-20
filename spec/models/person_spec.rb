require 'rails_helper'
RSpec.describe Person, type: :model do
  it { should belong_to :gender }
  it { should belong_to :race }
  it { should belong_to :ethnicity }

  before(:each) do
    interleave_spec_setup
    @person_little_my = FactoryGirl.create(:person, year_of_birth: 1976, month_of_birth: 7, day_of_birth: 4,  gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
  end

  it 'reports birth date', focus: false do
    expect(@person_little_my.birth_date).to eq(Date.parse('7/4/1976'))
  end
end