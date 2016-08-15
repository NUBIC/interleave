require 'rails_helper'

RSpec.feature 'Interleave People', type: :feature do
  before(:each) do
    interleave_spec_setup
    @interleave_registry_prostate = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')

    @interleave_registry_affiliate_north_shore = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northshore', interleave_registry: @interleave_registry_prostate)
    @interleave_registry_affiliate_northwestern = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry_prostate)

    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_moomin = FactoryGirl.create(:interleave_person, person: @person_moomin, first_name: 'Moomintroll', last_name: 'Moomin', middle_name: 'Mister', interleave_registry_affiliate: @interleave_registry_affiliate_north_shore)
    @person_the_groke = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_the_groke = FactoryGirl.create(:interleave_person, person: @person_the_groke, first_name: 'The', last_name: 'Groke', middle_name: 'Mister', interleave_registry_affiliate: @interleave_registry_affiliate_north_shore)

    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_little_my = FactoryGirl.create(:interleave_person, person: @person_little_my, first_name: 'Little', last_name: 'My', middle_name: 'Miss', interleave_registry_affiliate: @interleave_registry_affiliate_northwestern)
    @person_sniff = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_sniff = FactoryGirl.create(:interleave_person, person: @person_sniff, first_name: 'Sniff', last_name: 'Rodent', middle_name: 'Greedy', interleave_registry_affiliate: @interleave_registry_affiliate_northwestern)

    @interleave_registry_breast = FactoryGirl.create(:interleave_registry, name: 'Breast SPORE')
    @interleave_registry_affiliate_northwestern_2 = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry_breast)
    @interleave_registry_affiliate_north_shore_2 = FactoryGirl.create(:interleave_registry_affiliate, name: 'NorthShore', interleave_registry: @interleave_registry_breast)
    @person_chrlie_brown = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_charilie_brown = FactoryGirl.create(:interleave_person, person: @person_chrlie_brown, first_name: 'Charlie', last_name: 'Brown', middle_name: 'Mister', interleave_registry_affiliate: @interleave_registry_affiliate_northwestern_2)

    visit interleave_registries_path
    within("#interleave_registry_#{@interleave_registry_prostate.id}") do
      click_link('People')
    end
  end

  scenario 'Visiting breadcrumbs', js: true, focus: false do
    within('.breadcrumbs') do
      click_link('Registries')
    end

    sleep(1)

    within('.interleave_registry:nth-of-type(1) .registry_name') do
      expect(page).to have_content('Breast SPORE')
    end

    within('.interleave_registry:nth-of-type(2) .registry_name') do
      expect(page).to have_content('Prostate SPORE')
    end

    within("#interleave_registry_#{@interleave_registry_prostate.id}") do
      click_link('People')
    end

    within('.breadcrumbs') do
      click_link(@interleave_registry_prostate.name)
    end

    match_row(@interleave_person_the_groke, 1)
    match_row(@interleave_person_moomin, 2)
    match_row(@interleave_person_little_my, 3)
    match_row(@interleave_person_sniff, 4)
  end

  scenario 'Visiting interleave people', js: true, focus: false do
    match_row(@interleave_person_the_groke, 1)
    match_row(@interleave_person_moomin, 2)
    match_row(@interleave_person_little_my, 3)
    match_row(@interleave_person_sniff, 4)
  end

  scenario 'Visiting interleave people and sorting', js: true, focus: false do
    click_link('Affiliate')

    within(".interleave_person:nth-of-type(1) .registry_affiliate_name") do
      expect(page).to have_content(@interleave_registry_affiliate_north_shore.name)
    end

    within(".interleave_person:nth-of-type(2) .registry_affiliate_name") do
      expect(page).to have_content(@interleave_registry_affiliate_north_shore.name)
    end

    within(".interleave_person:nth-of-type(3) .registry_affiliate_name") do
      expect(page).to have_content(@interleave_registry_affiliate_northwestern.name)
    end

    within(".interleave_person:nth-of-type(4) .registry_affiliate_name") do
      expect(page).to have_content(@interleave_registry_affiliate_northwestern.name)
    end

    click_link('Affiliate')

    within(".interleave_person:nth-of-type(1) .registry_affiliate_name") do
      expect(page).to have_content(@interleave_registry_affiliate_northwestern.name)
    end

    within(".interleave_person:nth-of-type(2) .registry_affiliate_name") do
      expect(page).to have_content(@interleave_registry_affiliate_northwestern.name)
    end

    within(".interleave_person:nth-of-type(3) .registry_affiliate_name") do
      expect(page).to have_content(@interleave_registry_affiliate_north_shore.name)
    end

    within(".interleave_person:nth-of-type(4) .registry_affiliate_name") do
      expect(page).to have_content(@interleave_registry_affiliate_north_shore.name)
    end


    click_link('First Name')

    match_row(@interleave_person_little_my, 1)
    match_row(@interleave_person_moomin, 2)
    match_row(@interleave_person_sniff, 3)
    match_row(@interleave_person_the_groke, 4)

    click_link('First Name')

    match_row(@interleave_person_little_my, 4)
    match_row(@interleave_person_moomin, 3)
    match_row(@interleave_person_sniff, 2)
    match_row(@interleave_person_the_groke, 1)

    click_link('Last Name')

    match_row(@interleave_person_the_groke, 1)
    match_row(@interleave_person_moomin, 2)
    match_row(@interleave_person_little_my, 3)
    match_row(@interleave_person_sniff, 4)

    click_link('Last Name')

    match_row(@interleave_person_the_groke, 4)
    match_row(@interleave_person_moomin, 3)
    match_row(@interleave_person_little_my, 2)
    match_row(@interleave_person_sniff, 1)
  end

  scenario 'Visiting interleave people and searching', js: true, focus: false  do
    select @interleave_registry_affiliate_northwestern.name, from: 'Affiliate'

    click_button('Search')

    match_row(@interleave_person_little_my, 1)
    match_row(@interleave_person_sniff, 2)

    expect(page.has_css?('.interleave_person:nth-of-type(3) .registry_affiliate_name')).to be_falsey

    click_link('Last Name')

    match_row(@interleave_person_little_my, 2)
    match_row(@interleave_person_sniff, 1)

    expect(page.has_css?('.interleave_person:nth-of-type(3) .registry_affiliate_name')).to be_falsey

    fill_in 'Search', with: 'Little'

    click_button('Search')

    match_row(@interleave_person_little_my, 1)

    expect(page.has_css?('.interleave_person:nth-of-type(2) .registry_affiliate_name')).to be_falsey

    fill_in 'Search', with: 'Rodent'

    click_button('Search')

    match_row(@interleave_person_sniff, 1)

    expect(page.has_css?('.interleave_person:nth-of-type(2) .registry_affiliate_name')).to be_falsey

    click_link('Clear')

    match_row(@interleave_person_the_groke, 1)
    match_row(@interleave_person_moomin, 2)
    match_row(@interleave_person_little_my, 3)
    match_row(@interleave_person_sniff, 4)
  end
end

def match_row(interleave_person, index)
  within(".interleave_person:nth-of-type(#{index}) .registry_affiliate_name") do
    expect(page).to have_content(interleave_person.interleave_registry_affiliate.name)
  end

  within(".interleave_person:nth-of-type(#{index}) .people_first_name") do
    expect(page).to have_content(interleave_person.first_name)
  end

  within(".interleave_person:nth-of-type(#{index}) .people_last_name") do
    expect(page).to have_content(interleave_person.last_name)
  end
end