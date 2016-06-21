require 'rails_helper'

RSpec.feature 'Interleave Registires', type: :feature do
  before(:each) do
    interleave_spec_setup
    @interleave_registry_breast = FactoryGirl.create(:interleave_registry, name: 'Breast SPORE')
    @interleave_registry_prostate = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
  end

  scenario 'Visiting interleave registries', js: true, focus: false do
    visit interleave_registries_path
    within("#interleave_registry_#{@interleave_registry_breast.id} .registry_name") do
      expect(page).to have_content('Breast SPORE')
    end

    within("#interleave_registry_#{@interleave_registry_prostate.id} .registry_name") do
      expect(page).to have_content('Prostate SPORE')
    end
  end

  scenario 'Visiting interleave registries and sorting', js: true, focus: false do
    visit interleave_registries_path

    within('.interleave_registry:nth-of-type(1) .registry_name') do
      expect(page).to have_content('Breast SPORE')
    end

    within('.interleave_registry:nth-of-type(2) .registry_name') do
      expect(page).to have_content('Prostate SPORE')
    end

    click_link('Name')

    within('.interleave_registry:nth-of-type(1) .registry_name') do
      expect(page).to have_content('Prostate SPORE')
    end

    within('.interleave_registry:nth-of-type(2) .registry_name') do
      expect(page).to have_content('Breast SPORE')
    end
  end

  scenario 'Visiting interleave registries and searching', js: true, focus: false  do
    visit interleave_registries_path

    fill_in('Search', :with => 'Breast')
    click_button('Search')

    within('.interleave_registry:nth-of-type(1) .registry_name') do
      expect(page).to have_content('Breast SPORE')
    end

    expect(page.has_css?('.interleave_registry:nth-of-type(2) .registry_name')).to be_falsey

    click_link('Clear')

    within('.interleave_registry:nth-of-type(1) .registry_name') do
      expect(page).to have_content('Breast SPORE')
    end

    within('.interleave_registry:nth-of-type(2) .registry_name') do
      expect(page).to have_content('Prostate SPORE')
    end
  end
end