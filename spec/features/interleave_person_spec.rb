require 'rails_helper'

RSpec.feature 'Interleave Person', type: :feature do
  before(:each) do
    interleave_spec_setup
    @interleave_registry_prostate = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')

    @interleave_registry_affiliate_northwestern = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry_prostate)
    @person_moomin = FactoryGirl.create(:person, year_of_birth: 1980, month_of_birth: 1, day_of_birth: 1, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_moomin = FactoryGirl.create(:interleave_person, person: @person_moomin, first_name: 'Moomintroll', last_name: 'Moomin', middle_name: nil, interleave_registry_affiliate: @interleave_registry_affiliate_northwestern)
    @person_the_groke = FactoryGirl.create(:person, year_of_birth: 1970, month_of_birth: 1, day_of_birth: 1, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_person_the_groke = FactoryGirl.create(:interleave_person, person: @person_the_groke, first_name: 'The', last_name: 'Groke', middle_name: 'Mister', interleave_registry_affiliate: @interleave_registry_affiliate_northwestern)

    @interleave_registry_cdm_source = FactoryGirl.create(:interleave_registry_cdm_source, cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: @interleave_registry_prostate)
    @interleave_datapoint_diagnosis = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'Diagnosis', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 1, unrestricted: false, overlap: true)
    @interleave_datapoint_comorbidities = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'Comorbidities', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 0, unrestricted: true, overlap: false)
    FactoryGirl.create(:interleave_datapoint_concept, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_neoplasam_of_prostate)
    FactoryGirl.create(:interleave_datapoint_concept, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_benign_prostatic_hyperplasia)

    visit interleave_registries_path

    within("#interleave_registry_#{@interleave_registry_prostate.id}") do
      click_link('People')
    end

    within("#interleave_person_#{@interleave_person_moomin.id}") do
      click_link('Edit')
    end
  end


  scenario 'Visiting breadcrumbs', js: true, focus: false do
    within('.breadcrumbs') do
      click_link('Registries')
    end

    within("#interleave_registry_#{@interleave_registry_prostate.id}") do
      click_link('People')
    end

    within("#interleave_person_#{@interleave_person_moomin.id}") do
      click_link('Edit')
    end

    within('.breadcrumbs') do
      click_link(@interleave_registry_prostate.name)
    end

    within("#interleave_person_#{@interleave_person_moomin.id}") do
      click_link('Edit')
    end

    within('.breadcrumbs') do
      click_link(@interleave_person_moomin.full_name)
    end

    match_person(@interleave_person_moomin)
  end

  scenario 'Displaying multiple datapoints', js: true, focus: false do
    click_link('Conditions')
    click_link('Diagnosis')

    within("#condition_occurrences h3") do
      expect(page).to have_content('Diagnosis')
    end

    click_link('Comorbidities')

    within("#condition_occurrences h3") do
      expect(page).to have_content('Comorbidities')
    end
  end

  scenario 'Adding a condition occurrence with validation', js: true, focus: false do
    click_link('Conditions')
    click_link('Diagnosis')
    click_link('Add')
    click_button('Save')
    expect(page.has_css?('.condition_start_date .field_with_errors'))
    expect(page.has_css?('.condition_concept_id .field_with_errors'))
    expect(page.has_css?('.condition_type_concept_id .field_with_errors'))
  end

  scenario 'Adding a condition occurrence', js: true, focus: false do
    click_link('Conditions')
    click_link('Diagnosis')
    click_link('Add')
    page.find('.select2-selection ').native.send_keys(:return)
    concept_name = 'Neoplasm of prostate'
    find('.select2-dropdown input').set(concept_name)
    find('.select2-results__option--highlighted').click
    condition_type_concept_name = 'EHR problem list entry'
    select(condition_type_concept_name, from: 'Type')
    end_date = '02/01/2016'
    page.execute_script("$('#condition_occurrence_condition_end_date').val('#{end_date}')")
    start_date = '01/01/2016'
    page.execute_script("$('#condition_occurrence_condition_start_date').val('#{start_date}')")
    click_button('Save')
    match_condition(1, concept_name, Date.parse(start_date), Date.parse(end_date), condition_type_concept_name)
  end

  scenario 'Editing a condition occurrence', js: true, focus: false do
    start_date = Date.parse('1/1/2015')
    end_date = Date.parse('2/1/2015')
    condition_occurrence = FactoryGirl.create(:condition_occurrence, person:  @person_moomin, condition_concept: @concept_condition_neoplasam_of_prostate, condition_type_concept: @concept_condition_type_ehr_chief_complaint, interleave_datapoint_id: @interleave_datapoint_diagnosis.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id, condition_start_date: start_date, condition_end_date: end_date)
    click_link('Conditions')
    click_link('Diagnosis')
    match_condition(1, @concept_condition_neoplasam_of_prostate.concept_name, start_date, end_date, @concept_condition_type_ehr_chief_complaint.concept_name)

    within("#condition_occurrence_#{condition_occurrence.id}") do
      click_link('Edit')
    end

    page.find('.select2-selection ').native.send_keys(:return)
    find('.select2-dropdown input').set(@concept_condition_benign_prostatic_hyperplasia.concept_name)
    find('.select2-results__option--highlighted').click

    select(@concept_condition_type_ehr_chief_complaint.concept_name, from: 'Type')
    end_date = '02/01/2016'
    page.execute_script("$('#condition_occurrence_condition_end_date').val('#{end_date}')")
    start_date = '01/01/2016'
    page.execute_script("$('#condition_occurrence_condition_start_date').val('#{start_date}')")
    click_button('Save')
    match_condition(1, @concept_condition_benign_prostatic_hyperplasia.concept_name, Date.parse(start_date), Date.parse(end_date), @concept_condition_type_ehr_chief_complaint.concept_name)
  end

  scenario 'Editing a condition occurrence with validation', js: true, focus: false do
    start_date = Date.parse('1/1/2015')
    end_date = Date.parse('2/1/2015')
    condition_occurrence = FactoryGirl.create(:condition_occurrence, person:  @person_moomin, condition_concept: @concept_condition_neoplasam_of_prostate, condition_type_concept: @concept_condition_type_ehr_chief_complaint, interleave_datapoint_id: @interleave_datapoint_diagnosis.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id, condition_start_date: start_date, condition_end_date: end_date)
    click_link('Conditions')
    click_link('Diagnosis')
    match_condition(1, @concept_condition_neoplasam_of_prostate.concept_name, start_date, end_date, @concept_condition_type_ehr_chief_complaint.concept_name)

    within("#condition_occurrence_#{condition_occurrence.id}") do
      click_link('Edit')
    end

    select('', from: 'Type')
    end_date = ''
    page.execute_script("$('#condition_occurrence_condition_end_date').val('#{end_date}')")
    start_date = ''
    page.execute_script("$('#condition_occurrence_condition_start_date').val('#{start_date}')")
    click_button('Save')
    expect(page.has_css?('.condition_start_date .field_with_errors'))
    #ttd Figure out how to set a select2 to a blank value
    expect(page.has_css?('.condition_concept_id .field_with_errors'))
    expect(page.has_css?('.condition_type_concept_id .field_with_errors'))
  end

  scenario 'Sorting condition occurrences', js: true, focus: true do
    start_date_1 = Date.parse('1/1/2015')
    end_date_1 = Date.parse('2/1/2015')
    condition_occurrence_1 = FactoryGirl.create(:condition_occurrence, person:  @person_moomin, condition_concept: @concept_condition_neoplasam_of_prostate, condition_type_concept: @concept_condition_type_ehr_chief_complaint, interleave_datapoint_id: @interleave_datapoint_diagnosis.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id, condition_start_date: start_date_1, condition_end_date: end_date_1)

    start_date_2 = Date.parse('1/1/2016')
    end_date_2 = Date.parse('2/1/2016')
    condition_occurrence_2 = FactoryGirl.create(:condition_occurrence, person:  @person_moomin, condition_concept: @concept_condition_benign_prostatic_hyperplasia, condition_type_concept: @concept_condition_type_ehr_episode_entry, interleave_datapoint_id: @interleave_datapoint_diagnosis.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source.id, condition_start_date: start_date_2, condition_end_date: end_date_2)

    click_link('Conditions')
    click_link('Diagnosis')

    match_condition(1, @concept_condition_neoplasam_of_prostate.concept_name, start_date_1, end_date_1, @concept_condition_type_ehr_chief_complaint.concept_name)
    match_condition(2, @concept_condition_benign_prostatic_hyperplasia.concept_name, start_date_2, end_date_2, @concept_condition_type_ehr_episode_entry.concept_name)

    within(".condition_occurrences_list") do
      click_link('Condition')
    end

    match_condition(1, @concept_condition_benign_prostatic_hyperplasia.concept_name, start_date_2, end_date_2, @concept_condition_type_ehr_episode_entry.concept_name)
    match_condition(2, @concept_condition_neoplasam_of_prostate.concept_name, start_date_1, end_date_1, @concept_condition_type_ehr_chief_complaint.concept_name)

    within(".condition_occurrences_list") do
      click_link('Condition')
    end

    match_condition(1, @concept_condition_neoplasam_of_prostate.concept_name, start_date_1, end_date_1, @concept_condition_type_ehr_chief_complaint.concept_name)
    match_condition(2, @concept_condition_benign_prostatic_hyperplasia.concept_name, start_date_2, end_date_2, @concept_condition_type_ehr_episode_entry.concept_name)

    within(".condition_occurrences_list") do
      click_link('Start')
    end

    match_condition(1, @concept_condition_neoplasam_of_prostate.concept_name, start_date_1, end_date_1, @concept_condition_type_ehr_chief_complaint.concept_name)
    match_condition(2, @concept_condition_benign_prostatic_hyperplasia.concept_name, start_date_2, end_date_2, @concept_condition_type_ehr_episode_entry.concept_name)


    within(".condition_occurrences_list") do
      click_link('Start')
    end

    match_condition(1, @concept_condition_benign_prostatic_hyperplasia.concept_name, start_date_2, end_date_2, @concept_condition_type_ehr_episode_entry.concept_name)
    match_condition(2, @concept_condition_neoplasam_of_prostate.concept_name, start_date_1, end_date_1, @concept_condition_type_ehr_chief_complaint.concept_name)

    within(".condition_occurrences_list") do
      click_link('End')
    end

    match_condition(1, @concept_condition_neoplasam_of_prostate.concept_name, start_date_1, end_date_1, @concept_condition_type_ehr_chief_complaint.concept_name)
    match_condition(2, @concept_condition_benign_prostatic_hyperplasia.concept_name, start_date_2, end_date_2, @concept_condition_type_ehr_episode_entry.concept_name)

    within(".condition_occurrences_list") do
      click_link('End')
    end

    match_condition(1, @concept_condition_benign_prostatic_hyperplasia.concept_name, start_date_2, end_date_2, @concept_condition_type_ehr_episode_entry.concept_name)
    match_condition(2, @concept_condition_neoplasam_of_prostate.concept_name, start_date_1, end_date_1, @concept_condition_type_ehr_chief_complaint.concept_name)

    within(".condition_occurrences_list") do
      click_link('Condition Type')
    end

    match_condition(1, @concept_condition_benign_prostatic_hyperplasia.concept_name, start_date_2, end_date_2, @concept_condition_type_ehr_episode_entry.concept_name)
    match_condition(2, @concept_condition_neoplasam_of_prostate.concept_name, start_date_1, end_date_1, @concept_condition_type_ehr_chief_complaint.concept_name)

    within(".condition_occurrences_list") do
      click_link('Condition Type')
    end

    match_condition(1, @concept_condition_neoplasam_of_prostate.concept_name, start_date_1, end_date_1, @concept_condition_type_ehr_chief_complaint.concept_name)
    match_condition(2, @concept_condition_benign_prostatic_hyperplasia.concept_name, start_date_2, end_date_2, @concept_condition_type_ehr_episode_entry.concept_name)
  end
end

def match_person(interleave_person)
  within('.person_header .basic_information .name') do
    expect(page).to have_content(interleave_person.full_name)
  end

  within('.person_header .basic_information .gender') do
    expect(page).to have_content(interleave_person.person.gender.concept_name)
  end

  within('.person_header .basic_information .birth_date') do
    expect(page).to have_content(interleave_person.person.birth_date.to_s(:date))
  end

  within('.person_header .basic_information .race') do
    expect(page).to have_content(interleave_person.person.race.concept_name)
  end

  within('.person_header .basic_information .ethnicity') do
    expect(page).to have_content(interleave_person.person.ethnicity.concept_name)
  end

  # ttd
  # within('.person_header .basic_information .identifiers') do
  #   expect(page).to have_content(?)
  # end
end


def match_condition(index, concept_name, start_date, end_date, condition_type_concept_name)
  within(".condition_occurrence:nth-of-type(#{index}) .condition_occurrence_concept_name") do
    expect(page).to have_content(concept_name)
  end

  within(".condition_occurrence:nth-of-type(#{index}) .condition_occurrence_start_date") do
    expect(page).to have_content(start_date.to_s(:date))
  end

  within(".condition_occurrence:nth-of-type(#{index}) .condition_occurrence_end_date") do
    expect(page).to have_content(end_date.to_s(:date)) if end_date
  end

  within(".condition_occurrence:nth-of-type(#{index}) .condition_occurrence_condition_type_concept_name") do
    expect(page).to have_content(condition_type_concept_name)
  end
end