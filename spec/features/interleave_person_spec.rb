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
    @interleave_datapoint_diagnosis = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'Diagnosis', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 1, overlap: true)
    @interleave_datapoint_comorbidities = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'Comorbidities', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 0, overlap: false)
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_neoplasam_of_prostate, column: 'condition_concept_id')
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_diagnosis, concept: @concept_condition_benign_prostatic_hyperplasia, column: 'condition_concept_id')

    @interleave_datapoint_biopsy = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'Biopsy', domain_id: ProcedureOccurrence::DOMAIN_ID, cardinality: 0, overlap: true)
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_biopsy, concept: @concept_procedure_biopsy_prostate_needle, column: 'procedure_concept_id')
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_biopsy, concept: @concept_procedure_biopsy_prostate_incisional, column: 'procedure_concept_id')

    @interleave_datapoint_biopsy_total_number_of_cores = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'Total number of cores', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores, column: 'measurement_concept_id', concept: @concept_measurement_total_number_of_cores, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_total_number_of_cores, column: 'measurement_type_concept_id', concept: @concept_pathology_finding, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_relationship, interleave_datapoint: @interleave_datapoint_biopsy, interleave_sub_datapoint: @interleave_datapoint_biopsy_total_number_of_cores, relationship_concept_id: @concept_relationship_has_asso_finding.id)

    @interleave_datapoint_biopsy_gleason_primary = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'Gleason primary', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER_LIST)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_gleason_primary, column: 'measurement_concept_id', concept: @concept_measurement_gleason_primary, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_gleason_primary, column: 'measurement_type_concept_id', concept: @concept_pathology_finding, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_biopsy_gleason_primary, column: 'value_as_number', value_as_number: 1)
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_biopsy_gleason_primary, column: 'value_as_number', value_as_number: 2)
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_biopsy_gleason_primary, column: 'value_as_number', value_as_number: 3)
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_biopsy_gleason_primary, column: 'value_as_number', value_as_number: 4)
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_biopsy_gleason_primary, column: 'value_as_number', value_as_number: 5)
    FactoryGirl.create(:interleave_datapoint_relationship, interleave_datapoint: @interleave_datapoint_biopsy, interleave_sub_datapoint: @interleave_datapoint_biopsy_gleason_primary, relationship_concept_id: @concept_relationship_has_asso_finding.id)

    @interleave_datapoint_biopsy_perineural_invaision =  FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'Perineural invasion', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_perineural_invaision, column: 'measurement_concept_id', concept: @concept_measurement_perineural_invaison, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_biopsy_perineural_invaision, column: 'measurement_type_concept_id', concept: @concept_pathology_finding, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_biopsy_perineural_invaision, column: 'value_as_concept_id', concept: @concept_measurement_answer_present)
    FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_biopsy_perineural_invaision, column: 'value_as_concept_id', concept: @concept_measurement_answer_absent)
    FactoryGirl.create(:interleave_datapoint_relationship, interleave_datapoint: @interleave_datapoint_biopsy, interleave_sub_datapoint: @interleave_datapoint_biopsy_perineural_invaision, relationship_concept_id: @concept_relationship_has_asso_finding.id)

    @interleave_datapoint_weight = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'Weight', domain_id: Measurement::DOMAIN_ID, cardinality: 0 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_weight, column: 'measurement_concept_id', concept: @concept_measurement_body_weight_measured, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_weight, column: 'measurement_type_concept_id', concept: @concept_lab_result, hardcoded: false)

    @interleave_datapoint_psa_lab = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'PSA Lab', domain_id: Measurement::DOMAIN_ID, cardinality: 0 , overlap: true, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_DECIMAL)
    @psa_concepts.each do |psa_concept|
      FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_psa_lab, column: 'value_as_concept_id', concept: psa_concept)
    end
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_psa_lab, column: 'measurement_type_concept_id', concept: @concept_lab_result, hardcoded: false)

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

    within('.person_navigation') do
      click_link('Conditions')
    end

    within('.person_navigation') do
      click_link('Diagnosis')
    end

    within('.breadcrumbs') do
      click_link('Condition:Diagnosis')
    end

    within('.person_navigation') do
      click_link('Procedures')
    end

    within('.person_navigation') do
      click_link('Biopsy')
    end

    within('.breadcrumbs') do
      click_link('Procedure:Biopsy')
    end

    sleep(2)
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

  scenario 'Displaying only top level datapoints only', js: true, focus: false do
    within(".measurements") do
      expect(page).to have_content('Weight')
    end

    within(".measurements") do
      expect(page).to have_content('PSA Lab')
    end

    within(".measurements") do
      expect(page).to_not have_content('Total number of cores')
    end
  end

  scenario 'Adding a condition occurrence with validation', js: true, focus: false do
    click_link('Conditions')
    click_link('Diagnosis')
    click_link('Add')
    click_button('Save')
    expect(page.has_css?('.condition_start_date .field_with_errors')).to be_truthy
    expect(page.has_css?('.condition_concept_id .field_with_errors')).to be_truthy
    expect(page.has_css?('.condition_type_concept_id .field_with_errors')).to be_truthy
  end

  scenario 'Adding a procedure occurrence with validation', js: true, focus: false do
    click_link('Procedures')
    click_link('Biopsy')
    click_link('Add')
    click_button('Save')
    expect(page.has_css?('.procedure_date .field_with_errors')).to be_truthy
    expect(page.has_css?('.procedure_concept_id .field_with_errors')).to be_truthy
    expect(page.has_css?('.procedure_type_concept_id .field_with_errors')).to be_truthy
  end

  scenario 'Adding a condition occurrence', js: true, focus: false do
    click_link('Conditions')
    click_link('Diagnosis')
    click_link('Add')
    page.find('.select2-selection ').native.send_keys(:return)
    concept_name = @concept_condition_neoplasam_of_prostate.concept_name
    find('.select2-dropdown input').set(concept_name)
    find('.select2-results__option--highlighted').click
    select(@concept_condition_type_ehr_problem_list_entry.concept_name, from: 'Type')
    end_date = '02/01/2016'
    page.execute_script("$('#condition_occurrence_condition_end_date').val('#{end_date}')")
    start_date = '01/01/2016'
    page.execute_script("$('#condition_occurrence_condition_start_date').val('#{start_date}')")
    sleep(10)
    click_button('Save')
    match_condition(1, concept_name, Date.parse(start_date), Date.parse(end_date), @concept_condition_type_ehr_problem_list_entry.concept_name)
  end

  scenario 'Adding a procedure occurrence', js: true, focus: false do
    click_link('Biopsy')
    click_link('Add')
    page.find('.select2-selection ').native.send_keys(:return)
    concept_name = @concept_procedure_biopsy_prostate_needle.concept_name
    find('.select2-dropdown input').set(concept_name)
    find('.select2-results__option--highlighted').click
    procedure_type_concept_name = @concept_procedure_type_primary_procedure.concept_name
    select(procedure_type_concept_name, from: 'Type')
    procedure_date = '02/01/2016'
    page.execute_script("$('#procedure_occurrence_procedure_date').val('#{procedure_date}')")
    quantity = 1
    fill_in('Quantity', with: quantity)
    total_number_of_cores = 20
    fill_in('Total number of cores', with: total_number_of_cores)
    select('3', from: 'Gleason primary')
    select('Present', from: 'Perineural invasion')
    click_button('Save')
    match_procedure(1, concept_name, Date.parse(procedure_date), procedure_type_concept_name, quantity)

    within("#procedure_occurrence_#{ProcedureOccurrence.last.id}") do
      click_link('Edit')
    end

    within("#edit_procedure_occurrence_#{ProcedureOccurrence.last.id}") do
      expect(page.has_field?('Total number of cores', with: '20.0')).to be_truthy
      expect(page.has_select?('Gleason primary', selected: '3')).to be_truthy
      expect(page.has_select?('Perineural invasion', selected: 'Present')).to be_truthy
    end
  end

  scenario 'Adding a measurement with a hardcoded measurement concept and a defaulted measurment type concept', js: true, focus: false do
    click_link('Weight')
    click_link('Add')
    value_as_number = 200
    fill_in('Value', with: value_as_number)
    measurement_date = '02/01/2016'
    page.execute_script("$('#measurement_measurement_date').val('#{measurement_date}')")
    within(:css, ".measurement_form .measurement_concept_concept_name") do
      expect(page).to have_content(@concept_measurement_body_weight_measured.concept_name)
    end
    expect(find_field('Type').find(:xpath, ".//option[@selected = 'selected'][text() = '#{@concept_lab_result.concept_name}']")).to be_truthy
    click_button('Save')
    sleep(1)
    match_measurement(1, @concept_measurement_body_weight_measured.concept_name, Date.parse(measurement_date), @concept_lab_result.concept_name, value_as_number, nil)
  end

  scenario 'Adding a measurement with a list of measurement concepts and a defaulted measurment type concept', js: true, focus: false do
    click_link('PSA Lab')
    click_link('Add')
    value_as_number = 0.20
    fill_in('Value', with: value_as_number)
    measurement_date = '02/01/2016'
    page.execute_script("$('#measurement_measurement_date').val('#{measurement_date}')")
    expect(find_field('Type').find(:xpath, ".//option[@selected = 'selected'][text() = '#{@concept_lab_result.concept_name}']")).to be_truthy
    expect(find_field('Concept').value).to be_empty
    page.find('.select2-selection ').native.send_keys(:return)
    concept_name = @psa_concept_1.concept_name
    find('.select2-dropdown input').set(concept_name)
    find('.select2-results__option--highlighted').click
    click_button('Save')
    match_measurement(1, @psa_concept_1.concept_name, Date.parse(measurement_date), @concept_lab_result.concept_name, value_as_number, nil)
  end

  scenario 'Editing a condition occurrence', js: true, focus: false do
    start_date = Date.parse('1/1/2015')
    end_date = Date.parse('2/1/2015')
    condition_occurrence = FactoryGirl.build(:condition_occurrence, person:  @person_moomin, condition_concept: @concept_condition_neoplasam_of_prostate, condition_type_concept: @concept_condition_type_ehr_chief_complaint, interleave_datapoint_id: @interleave_datapoint_diagnosis.id, condition_start_date: start_date, condition_end_date: end_date)
    condition_occurrence.create_with_sub_datapoints!(@interleave_registry_cdm_source)
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

  scenario 'Editing a procedure occurrence', js: true, focus: false do
    procedure_date = '1/1/2015'
    quantity = 1
    procedure_occurrence = FactoryGirl.build(:procedure_occurrence, person: @person_moomin, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, interleave_datapoint_id: @interleave_datapoint_biopsy.id, procedure_date: procedure_date, quantity: quantity)
    sub_datapoint_entities = @interleave_datapoint_biopsy.initialize_sub_datapoint_entities
    measurements = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    procedure_occurrence.create_with_sub_datapoints!(@interleave_registry_cdm_source, measurements: measurements)
    click_link('Procedure')
    click_link('Biopsy')
    match_procedure(1, @concept_procedure_biopsy_prostate_needle.concept_name, Date.parse(procedure_date), @concept_procedure_type_primary_procedure.concept_name, quantity)

    within("#procedure_occurrence_#{procedure_occurrence.id}") do
      click_link('Edit')
    end

    page.find('.select2-selection ').native.send_keys(:return)
    find('.select2-dropdown input').set(@concept_procedure_biopsy_prostate_incisional.concept_name)
    find('.select2-results__option--highlighted').click
    select(@concept_procedure_type_secondary_procedure.concept_name, from: 'Type')
    procedure_date = '02/01/2016'
    page.execute_script("$('#procedure_occurrence_procedure_date').val('#{procedure_date}')")
    quantity = 2
    fill_in('Quantity', with: quantity)
    total_number_of_cores = 20
    fill_in('Total number of cores', with: total_number_of_cores)
    select('3', from: 'Gleason primary')
    select('Present', from: 'Perineural invasion')

    click_button('Save')
    match_procedure(1, @concept_procedure_biopsy_prostate_incisional.concept_name, Date.parse(procedure_date), @concept_procedure_type_secondary_procedure.concept_name, quantity)

    within("#procedure_occurrence_#{ProcedureOccurrence.last.id}") do
      click_link('Edit')
    end

    within("#edit_procedure_occurrence_#{procedure_occurrence.id}") do
      expect(page.has_field?('Total number of cores', with: '20.0')).to be_truthy
      expect(page.has_select?('Gleason primary', selected: '3')).to be_truthy
      expect(page.has_select?('Perineural invasion', selected: 'Present')).to be_truthy
    end
  end

  scenario 'Editing a measurment with a hardcoded measurement concept and a defaulted measurment type concept', js: true, focus: false do
    measurement_date = Date.parse('1/1/2015')
    value_as_number = 150
    measurement = FactoryGirl.build(:measurement, person: @person_moomin, measurement_concept: @concept_measurement_body_weight_measured, measurement_type_concept: @concept_lab_result, interleave_datapoint_id: @interleave_datapoint_weight.id, measurement_date: measurement_date, value_as_number: value_as_number)
    measurement.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    click_link('Measurement')
    click_link('Weight')
    match_measurement(1, @concept_measurement_body_weight_measured.concept_name, measurement_date, @concept_lab_result.concept_name, value_as_number, nil)

    within("#measurement_#{measurement.id}") do
      click_link('Edit')
    end

    within(:css, ".measurement_form .measurement_concept_concept_name") do
      expect(page).to have_content(@concept_measurement_body_weight_measured.concept_name)
    end

    select(@concept_pathology_finding.concept_name, from: 'Type')

    value_as_number = 200
    fill_in('Value', with: value_as_number)

    measurement_date = '02/01/2016'
    page.execute_script("$('#measurement_measurement_date').val('#{measurement_date}')")

    click_button('Save')
    match_measurement(1, @concept_measurement_body_weight_measured.concept_name, Date.parse(measurement_date), @concept_pathology_finding.concept_name, value_as_number, nil)
  end

  scenario 'Editing a measurment with a list of measurement concepts and a defaulted measurment type concept', js: true, focus: false do
    measurement_date = Date.parse('1/1/2015')
    value_as_number = 0.30
    measurement = FactoryGirl.build(:measurement, person: @person_moomin, measurement_concept: @psa_concept_1, measurement_type_concept: @concept_lab_result, interleave_datapoint_id: @interleave_datapoint_psa_lab.id, measurement_date: measurement_date, value_as_number: value_as_number)
    measurement.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    click_link('Measurement')
    click_link('PSA Lab')
    match_measurement(1, @psa_concept_1.concept_name, measurement_date, @concept_lab_result.concept_name, value_as_number, nil)

    within("#measurement_#{measurement.id}") do
      click_link('Edit')
    end

    page.find('.select2-selection ').native.send_keys(:return)
    concept_name = @psa_concept_2.concept_name
    find('.select2-dropdown input').set(concept_name)
    find('.select2-results__option--highlighted').click

    select(@concept_pathology_finding.concept_name, from: 'Type')

    value_as_number = 0.50
    fill_in('Value', with: value_as_number)

    measurement_date = '02/01/2016'
    page.execute_script("$('#measurement_measurement_date').val('#{measurement_date}')")
    click_button('Save')
    match_measurement(1, @psa_concept_2.concept_name, Date.parse(measurement_date), @concept_pathology_finding.concept_name, value_as_number, nil)
  end

  scenario 'Editing a condition occurrence with validation', js: true, focus: false do
    start_date = Date.parse('1/1/2015')
    end_date = Date.parse('2/1/2015')
    condition_occurrence = FactoryGirl.build(:condition_occurrence, person:  @person_moomin, condition_concept: @concept_condition_neoplasam_of_prostate, condition_type_concept: @concept_condition_type_ehr_chief_complaint, interleave_datapoint_id: @interleave_datapoint_diagnosis.id, condition_start_date: start_date, condition_end_date: end_date)
    condition_occurrence.create_with_sub_datapoints!(@interleave_registry_cdm_source)
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
    #TTD Figure out how to set a select2 to a blank value
    expect(page.has_css?('.condition_concept_id .field_with_errors'))
    expect(page.has_css?('.condition_type_concept_id .field_with_errors'))
  end

  scenario 'Editing a procedure occurrence with validation', js: true, focus: false do
    procedure_date = '1/1/2015'
    quantity = 1
    procedure_occurrence = FactoryGirl.build(:procedure_occurrence, person: @person_moomin, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, interleave_datapoint_id: @interleave_datapoint_biopsy.id, procedure_date: procedure_date, quantity: quantity)
    procedure_occurrence.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    click_link('Procedure')
    click_link('Biopsy')
    match_procedure(1, @concept_procedure_biopsy_prostate_needle.concept_name, Date.parse(procedure_date), @concept_procedure_type_primary_procedure.concept_name, quantity)

    within("#procedure_occurrence_#{procedure_occurrence.id}") do
      click_link('Edit')
    end
    sleep(1)
    select('', from: 'Type')
    fill_in('Quantity', with: 'foo')
    procedure_date = ''
    page.execute_script("$('#procedure_occurrence_procedure_date').val('#{procedure_date}')")
    page.execute_script("$('#procedure_occurrence_procedure_date').focusout()")
    click_button('Save')
    expect(page.has_css?('.procedure_date .field_with_errors')).to be_truthy
    expect(page.has_css?('.quantity .field_with_errors')).to be_truthy
    #TTD Figure out how to set a select2 to a blank value
    # expect(page.has_css?('.procedure_concept_id .field_with_errors')).to be_truthy
    expect(page.has_css?('.procedure_type_concept_id .field_with_errors')).to be_truthy
  end

  scenario 'Sorting condition occurrences', js: true, focus: false do
    start_date_1 = Date.parse('1/1/2015')
    end_date_1 = Date.parse('2/1/2015')
    condition_occurrence_1 = FactoryGirl.build(:condition_occurrence, person:  @person_moomin, condition_concept: @concept_condition_neoplasam_of_prostate, condition_type_concept: @concept_condition_type_ehr_chief_complaint, interleave_datapoint_id: @interleave_datapoint_diagnosis.id, condition_start_date: start_date_1, condition_end_date: end_date_1)
    condition_occurrence_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    start_date_2 = Date.parse('1/1/2016')
    end_date_2 = Date.parse('2/1/2016')
    condition_occurrence_2 = FactoryGirl.create(:condition_occurrence, person:  @person_moomin, condition_concept: @concept_condition_benign_prostatic_hyperplasia, condition_type_concept: @concept_condition_type_ehr_episode_entry, interleave_datapoint_id: @interleave_datapoint_diagnosis.id, condition_start_date: start_date_2, condition_end_date: end_date_2)
    condition_occurrence_2.create_with_sub_datapoints!(@interleave_registry_cdm_source)

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

    match_condition(1, @concept_condition_neoplasam_of_prostate.concept_name, start_date_1, end_date_1, @concept_condition_type_ehr_chief_complaint.concept_name)
    match_condition(2, @concept_condition_benign_prostatic_hyperplasia.concept_name, start_date_2, end_date_2, @concept_condition_type_ehr_episode_entry.concept_name)


    within(".condition_occurrences_list") do
      click_link('Condition Type')
    end

    match_condition(1, @concept_condition_benign_prostatic_hyperplasia.concept_name, start_date_2, end_date_2, @concept_condition_type_ehr_episode_entry.concept_name)
    match_condition(2, @concept_condition_neoplasam_of_prostate.concept_name, start_date_1, end_date_1, @concept_condition_type_ehr_chief_complaint.concept_name)
  end

  scenario 'Sorting procedure occurrences', js: true, focus: false do
    procedure_date_1 = '1/1/2015'
    quantity_1 = 1
    procedure_occurrence_1 = FactoryGirl.build(:procedure_occurrence, person: @person_moomin, procedure_concept: @concept_procedure_biopsy_prostate_needle, procedure_type_concept: @concept_procedure_type_primary_procedure, interleave_datapoint_id: @interleave_datapoint_biopsy.id, procedure_date: procedure_date_1, quantity: quantity_1)
    procedure_occurrence_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)

    procedure_date_2 = '2/1/2015'
    quantity_2 = 2
    procedure_occurrence_2 = FactoryGirl.build(:procedure_occurrence, person: @person_moomin, procedure_concept: @concept_procedure_biopsy_prostate_incisional, procedure_type_concept: @concept_procedure_type_secondary_procedure, interleave_datapoint_id: @interleave_datapoint_biopsy.id, procedure_date: procedure_date_2, quantity: quantity_2)
    procedure_occurrence_2.create_with_sub_datapoints!(@interleave_registry_cdm_source)

    click_link('Procedures')
    click_link('Biopsy')

    match_procedure(1, @concept_procedure_biopsy_prostate_needle.concept_name, Date.parse(procedure_date_1), @concept_procedure_type_primary_procedure.concept_name, quantity_1)
    match_procedure(2, @concept_procedure_biopsy_prostate_incisional.concept_name, Date.parse(procedure_date_2), @concept_procedure_type_secondary_procedure.concept_name, quantity_2)

    within(".procedure_occurrences_list") do
      click_link('Procedure')
    end

    match_procedure(1, @concept_procedure_biopsy_prostate_incisional.concept_name, Date.parse(procedure_date_2), @concept_procedure_type_secondary_procedure.concept_name, quantity_2)
    match_procedure(2, @concept_procedure_biopsy_prostate_needle.concept_name, Date.parse(procedure_date_1), @concept_procedure_type_primary_procedure.concept_name, quantity_1)

    within(".procedure_occurrences_list") do
      click_link('Procedure')
    end

    match_procedure(1, @concept_procedure_biopsy_prostate_needle.concept_name, Date.parse(procedure_date_1), @concept_procedure_type_primary_procedure.concept_name, quantity_1)
    match_procedure(2, @concept_procedure_biopsy_prostate_incisional.concept_name, Date.parse(procedure_date_2), @concept_procedure_type_secondary_procedure.concept_name, quantity_2)

    within(".procedure_occurrences_list") do
      click_link('Date')
    end

    match_procedure(1, @concept_procedure_biopsy_prostate_needle.concept_name, Date.parse(procedure_date_1), @concept_procedure_type_primary_procedure.concept_name, quantity_1)
    match_procedure(2, @concept_procedure_biopsy_prostate_incisional.concept_name, Date.parse(procedure_date_2), @concept_procedure_type_secondary_procedure.concept_name, quantity_2)

    within(".procedure_occurrences_list") do
      click_link('Date')
    end

    match_procedure(1, @concept_procedure_biopsy_prostate_incisional.concept_name, Date.parse(procedure_date_2), @concept_procedure_type_secondary_procedure.concept_name, quantity_2)
    match_procedure(2, @concept_procedure_biopsy_prostate_needle.concept_name, Date.parse(procedure_date_1), @concept_procedure_type_primary_procedure.concept_name, quantity_1)

    within(".procedure_occurrences_list") do
      click_link('Quantity')
    end

    match_procedure(1, @concept_procedure_biopsy_prostate_needle.concept_name, Date.parse(procedure_date_1), @concept_procedure_type_primary_procedure.concept_name, quantity_1)
    match_procedure(2, @concept_procedure_biopsy_prostate_incisional.concept_name, Date.parse(procedure_date_2), @concept_procedure_type_secondary_procedure.concept_name, quantity_2)

    within(".procedure_occurrences_list") do
      click_link('Quantity')
    end

    match_procedure(1, @concept_procedure_biopsy_prostate_incisional.concept_name, Date.parse(procedure_date_2), @concept_procedure_type_secondary_procedure.concept_name, quantity_2)
    match_procedure(2, @concept_procedure_biopsy_prostate_needle.concept_name, Date.parse(procedure_date_1), @concept_procedure_type_primary_procedure.concept_name, quantity_1)

    within(".procedure_occurrences_list") do
      click_link('Procedure Type')
    end

    match_procedure(1, @concept_procedure_biopsy_prostate_needle.concept_name, Date.parse(procedure_date_1), @concept_procedure_type_primary_procedure.concept_name, quantity_1)
    match_procedure(2, @concept_procedure_biopsy_prostate_incisional.concept_name, Date.parse(procedure_date_2), @concept_procedure_type_secondary_procedure.concept_name, quantity_2)

    within(".procedure_occurrences_list") do
      click_link('Procedure Type')
    end

    match_procedure(1, @concept_procedure_biopsy_prostate_incisional.concept_name, Date.parse(procedure_date_2), @concept_procedure_type_secondary_procedure.concept_name, quantity_2)
    match_procedure(2, @concept_procedure_biopsy_prostate_needle.concept_name, Date.parse(procedure_date_1), @concept_procedure_type_primary_procedure.concept_name, quantity_1)
  end

  scenario 'Sorting measurements', js: true, focus: false do
    measurement_date_1 = '1/1/2015'
    value_as_number_1 = 0.30
    measurement_1 = FactoryGirl.build(:measurement, person: @person_moomin, measurement_concept: @psa_concept_1, measurement_type_concept: @concept_lab_result, interleave_datapoint_id: @interleave_datapoint_psa_lab.id, measurement_date: Date.parse(measurement_date_1), value_as_number: value_as_number_1)
    measurement_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)

    measurement_date_2 = '2/1/2015'
    value_as_number_2 = 0.60
    measurement_2 = FactoryGirl.build(:measurement, person: @person_moomin, measurement_concept: @psa_concept_2, measurement_type_concept: @concept_pathology_finding, interleave_datapoint_id: @interleave_datapoint_psa_lab.id, measurement_date: Date.parse(measurement_date_2), value_as_number: value_as_number_2)
    measurement_2.create_with_sub_datapoints!(@interleave_registry_cdm_source)

    click_link('PSA Lab')

    match_measurement(1, @psa_concept_1.concept_name, Date.parse(measurement_date_1), @concept_lab_result.concept_name, value_as_number_1, nil)
    match_measurement(2, @psa_concept_2.concept_name, Date.parse(measurement_date_2), @concept_pathology_finding.concept_name, value_as_number_2, nil)

    within(".measurements_list") do
      click_link('Date')
    end

    match_measurement(1, @psa_concept_2.concept_name, Date.parse(measurement_date_2), @concept_pathology_finding.concept_name, value_as_number_2, nil)
    match_measurement(2, @psa_concept_1.concept_name, Date.parse(measurement_date_1), @concept_lab_result.concept_name, value_as_number_1, nil)

    within(".measurements_list") do
      click_link('Measurement')
    end

    match_measurement(1, @psa_concept_1.concept_name, Date.parse(measurement_date_1), @concept_lab_result.concept_name, value_as_number_1, nil)
    match_measurement(2, @psa_concept_2.concept_name, Date.parse(measurement_date_2), @concept_pathology_finding.concept_name, value_as_number_2, nil)

    within(".measurements_list") do
      click_link('Measurement')
    end

    match_measurement(1, @psa_concept_2.concept_name, Date.parse(measurement_date_2), @concept_pathology_finding.concept_name, value_as_number_2, nil)
    match_measurement(2, @psa_concept_1.concept_name, Date.parse(measurement_date_1), @concept_lab_result.concept_name, value_as_number_1, nil)

    within(".measurements_list") do
      click_link('Measurement Type')
    end

    match_measurement(1, @psa_concept_1.concept_name, Date.parse(measurement_date_1), @concept_lab_result.concept_name, value_as_number_1, nil)
    match_measurement(2, @psa_concept_2.concept_name, Date.parse(measurement_date_2), @concept_pathology_finding.concept_name, value_as_number_2, nil)

    within(".measurements_list") do
      click_link('Measurement Type')
    end

    match_measurement(1, @psa_concept_2.concept_name, Date.parse(measurement_date_2), @concept_pathology_finding.concept_name, value_as_number_2, nil)
    match_measurement(2, @psa_concept_1.concept_name, Date.parse(measurement_date_1), @concept_lab_result.concept_name, value_as_number_1, nil)

    within(".measurements_list") do
      click_link('Value')
    end

    match_measurement(1, @psa_concept_1.concept_name, Date.parse(measurement_date_1), @concept_lab_result.concept_name, value_as_number_1, nil)
    match_measurement(2, @psa_concept_2.concept_name, Date.parse(measurement_date_2), @concept_pathology_finding.concept_name, value_as_number_2, nil)

    within(".measurements_list") do
      click_link('Value')
    end

    match_measurement(1, @psa_concept_2.concept_name, Date.parse(measurement_date_2), @concept_pathology_finding.concept_name, value_as_number_2, nil)
    match_measurement(2, @psa_concept_1.concept_name, Date.parse(measurement_date_1), @concept_lab_result.concept_name, value_as_number_1, nil)


    within(".measurements_list") do
      click_link('Value')
    end

    match_measurement(1, @psa_concept_1.concept_name, Date.parse(measurement_date_1), @concept_lab_result.concept_name, value_as_number_1, nil)
    match_measurement(2, @psa_concept_2.concept_name, Date.parse(measurement_date_2), @concept_pathology_finding.concept_name, value_as_number_2, nil)
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

def match_procedure(index, concept_name, procedure_date, procedure_type_concept_name, quantity)
  within(".procedure_occurrence:nth-of-type(#{index}) .procedure_occurrence_concept_name") do
    expect(page).to have_content(concept_name)
  end

  within(".procedure_occurrence:nth-of-type(#{index}) .procedure_occurrence_procedure_date") do
    expect(page).to have_content(procedure_date.to_s(:date))
  end

  within(".procedure_occurrence:nth-of-type(#{index}) .procedure_occurrence_procedure_type_concept_name") do
    expect(page).to have_content(procedure_type_concept_name)
  end

  within(".procedure_occurrence:nth-of-type(#{index}) .procedure_occurrence_quantity") do
    expect(page).to have_content(quantity)
  end
end

def match_measurement(index, concept_name, measurement_date, measurement_type_concept_name, value_as_number, value_as_concept_id)
  within(".measurement:nth-of-type(#{index}) .measurement_concept_concept_name") do
    expect(page).to have_content(concept_name)
  end

  within(".measurement:nth-of-type(#{index}) .measurement_date") do
    expect(page).to have_content(measurement_date.to_s(:date))
  end

  within(".measurement:nth-of-type(#{index}) .measurement_type_concept_concept_name") do
    expect(page).to have_content(measurement_type_concept_name)
  end

  within(".measurement:nth-of-type(#{index}) .value_as_number") do
    expect(page).to have_content(value_as_number)
  end
end