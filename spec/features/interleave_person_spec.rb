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
    @interleave_datapoint_comorbidities = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'Comorbidity', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 0, overlap: false)
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

    @interleave_datapoint_drug_exposure = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, name: 'Drug Exposure', domain_id: DrugExposure::DOMAIN_ID, cardinality: 0, overlap: true)

    #datapoint
    @interleave_datapoint_family_history_of_disease_relationship = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, group_name: 'Family History of Disease', name: 'Family Relationship', domain_id: Observation::DOMAIN_ID, cardinality: 0, overlap: true, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_relationship, column: 'observation_concept_id', concept: @concept_observation_relationship_to_patient_family_member, hardcoded: true)

    @concept_observation_relationship_to_patient_family_member_answers.each do |answer|
      FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_relationship, column: 'value_as_concept_id', concept: answer)
    end

    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_relationship, column: 'observation_type_concept_id', concept: @concept_observation_type_patient_reported, hardcoded: true)

    #sub datapoint
    @interleave_datapoint_family_history_of_disease_disease = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, group_name: nil, name: 'Disease', domain_id: Observation::DOMAIN_ID, cardinality: 0, overlap: true, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_disease, column: 'observation_concept_id', concept: @concept_observation_relationship_to_patient_family_member_disease, hardcoded: true)

    @concept_observation_relationship_to_patient_family_member_disease_answers.each do |answer|
      FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_disease, column: 'value_as_concept_id', concept: answer)
    end

    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_disease, column: 'observation_type_concept_id', concept: @concept_observation_type_patient_reported, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_relationship, interleave_datapoint: @interleave_datapoint_family_history_of_disease_relationship, interleave_sub_datapoint: @interleave_datapoint_family_history_of_disease_disease, relationship_concept_id: @concept_relationship_has_asso_finding.id)

    #sub datapoint
    @interleave_datapoint_family_history_of_disease_age_range = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry_prostate, group_name: nil, name: 'Age range at diagnosis', domain_id: Observation::DOMAIN_ID, cardinality: 0, overlap: true, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT)
    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_age_range, column: 'observation_concept_id', concept: @concept_observation_age_range_at_onset_of_disease_family_member, hardcoded: true)

    @concept_observation_age_range_at_onset_of_disease_family_member_answers.each do |answer|
      FactoryGirl.create(:interleave_datapoint_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_age_range, column: 'value_as_concept_id', concept: answer)
    end

    FactoryGirl.create(:interleave_datapoint_default_value, interleave_datapoint: @interleave_datapoint_family_history_of_disease_age_range, column: 'observation_type_concept_id', concept: @concept_observation_type_patient_reported, hardcoded: true)
    FactoryGirl.create(:interleave_datapoint_relationship, interleave_datapoint: @interleave_datapoint_family_history_of_disease_relationship, interleave_sub_datapoint: @interleave_datapoint_family_history_of_disease_age_range, relationship_concept_id: @concept_relationship_has_asso_finding.id)

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
      click_link('Diagnosis')
    end

    within('.breadcrumbs') do
      click_link('Condition:Diagnosis')
    end

    within('.person_navigation') do
      click_link('Biopsy')
    end

    within('.breadcrumbs') do
      click_link('Procedure:Biopsy')
    end

    within('.person_navigation') do
      click_link('Drug Exposure')
    end

    within('.breadcrumbs') do
      click_link('Drug:Drug Exposure')
    end

    sleep(1)
  end

  scenario 'Displaying multiple datapoints', js: true, focus: false do
    click_link('Conditions')
    click_link('Diagnosis')

    within("#condition_occurrences h3") do
      expect(page).to have_content('Diagnosis')
    end

    click_link('Comorbidity')

    within("#condition_occurrences h3") do
      expect(page).to have_content('Comorbidity')
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
    click_link('Diagnosis')
    click_link('Add')
    click_button('Save')
    expect(page.has_css?('.condition_start_date .field_with_errors')).to be_truthy
    expect(page.has_css?('.condition_concept_id .field_with_errors')).to be_truthy
    expect(page.has_css?('.condition_type_concept_id .field_with_errors')).to be_truthy
  end

  scenario 'Adding a procedure occurrence with validation', js: true, focus: false do
    click_link('Biopsy')
    click_link('Add')
    click_button('Save')
    expect(page.has_css?('.procedure_date .field_with_errors')).to be_truthy
    expect(page.has_css?('.procedure_concept_id .field_with_errors')).to be_truthy
    expect(page.has_css?('.procedure_type_concept_id .field_with_errors')).to be_truthy
  end

  scenario 'Adding a condition occurrence', js: true, focus: false do
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
    sleep(1)
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

  scenario 'Adding a drug exposure', js: true, focus: false do
    click_link('Drug Exposure')
    click_link('Add')
    page.find('.select2-selection ').native.send_keys(:return)
    find('.select2-dropdown input').set(@concept_drug_carbidopa.concept_name)
    find('.select2-results__option--highlighted').click
    select(@concept_drug_prescription_written.concept_name, from: 'Type')
    start_date = '01/01/2016'
    page.execute_script("$('#drug_exposure_drug_exposure_start_date').val('#{start_date}')")
    end_date = '02/01/2016'
    page.execute_script("$('#drug_exposure_drug_exposure_end_date').val('#{end_date}')")
    click_button('Save')
    match_drug_exposure(1, @concept_drug_carbidopa.concept_name, Date.parse(start_date), Date.parse(end_date), @concept_drug_prescription_written.concept_name)
  end

  scenario 'Adding an observation', js: true, focus: false do
    interleave_datapoints = []
    click_link('Family History of Disease')
    click_link('Add')
    concept_brother = Concept.where(concept_code: 'LA10415-0').first
    interleave_datapoints << { concept: concept_brother, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id}
    select(concept_brother.concept_name, from: 'Family Relationship')
    concept_heart_diseases = Concept.where(concept_code: 'LA10523-1').first
    interleave_datapoints << { concept: concept_heart_diseases, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_disease.id}
    select(concept_heart_diseases.concept_name, from: 'Disease')
    concept_40_to_49 = Concept.where(concept_code: 'LA10398-8').first
    select(concept_40_to_49.concept_name, from: 'Age range at diagnosis')
    observation_date = '02/01/2016'
    page.execute_script("$('#observation_observation_date').val('#{observation_date}')")
    click_button('Save')
    match_observation(1, Date.parse(observation_date), interleave_datapoints)
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

  scenario 'Editing a drug exposure', js: true, focus: false do
    start_date = '1/1/2015'
    end_date = '2/1/2015'
    durg_exposure = FactoryGirl.build(:drug_exposure, person: @person_moomin, drug_concept: @concept_drug_carbidopa, drug_type_concept: @concept_drug_prescription_written, drug_exposure_start_date: Date.parse(start_date), drug_exposure_end_date: Date.parse(end_date), interleave_datapoint_id: @interleave_datapoint_drug_exposure.id)
    durg_exposure.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    click_link('Drug Exposure')
    match_drug_exposure(1, @concept_drug_carbidopa.concept_name, Date.parse(start_date), Date.parse(end_date), @concept_drug_prescription_written.concept_name)

    within("#drug_exposure_#{durg_exposure.id}") do
      click_link('Edit')
    end

    page.find('.select2-selection ').native.send_keys(:return)
    find('.select2-dropdown input').set(@concept_drug_carbidopa_25mg_oral_tablet.concept_name)
    find('.select2-results__option--highlighted').click
    select(@concept_drug_inpatient_administration.concept_name, from: 'Type')
    start_date = '01/01/2016'
    page.execute_script("$('#drug_exposure_drug_exposure_start_date').val('#{start_date}')")
    end_date = '02/01/2016'
    page.execute_script("$('#drug_exposure_drug_exposure_end_date').val('#{end_date}')")
    click_button('Save')
    match_drug_exposure(1, @concept_drug_carbidopa_25mg_oral_tablet.concept_name, Date.parse(start_date), Date.parse(end_date), @concept_drug_inpatient_administration.concept_name)
    sleep(1)
  end

  scenario 'Editing an observation', js: true, focus: false do
    interleave_datapoints = []
    observation_date = '1/1/2015'
    concept_brother = Concept.where(concept_code: 'LA10415-0').first
    interleave_datapoints << { concept: concept_brother, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id}
    observation_1 = FactoryGirl.build(:observation, person: @person_moomin, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse(observation_date), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id, value_as_concept: concept_brother)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    concept_lung_disease = Concept.where(concept_code: 'LA10531-4').first
    interleave_datapoints << { concept: concept_lung_disease, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_disease.id}
    observations.detect { |observation| observation[:interleave_datapoint_id] == @interleave_datapoint_family_history_of_disease_disease.id }[:value_as_concept_id] = concept_lung_disease.id
    concept_20_to_29 = Concept.where(concept_code: 'LA10396-2').first
    interleave_datapoints << { concept: concept_20_to_29, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_age_range.id}
    observations.detect { |observation| observation[:interleave_datapoint_id] == @interleave_datapoint_family_history_of_disease_age_range.id }[:value_as_concept_id] = concept_20_to_29.id
    observation_1.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)

    click_link('Family History of Disease')
    match_observation(1, Date.parse(observation_date), interleave_datapoints)

    within("#observation_#{observation_1.id}") do
      click_link('Edit')
    end

    within("#edit_observation_#{observation_1.id}") do
      expect(page.has_field?('Date', with: Date.parse(observation_date).to_s)).to be_truthy
      expect(page.has_select?('Type', selected: @concept_observation_type_patient_reported.concept_name)).to be_truthy
      expect(page.has_select?('Family Relationship', selected: concept_brother.concept_name)).to be_truthy
      expect(page.has_select?('Disease', selected: concept_lung_disease.concept_name)).to be_truthy
      expect(page.has_select?('Age range at diagnosis', selected: concept_20_to_29.concept_name)).to be_truthy
    end

    interleave_datapoints = []
    concept_mother = Concept.where(concept_code: 'LA10417-6').first
    interleave_datapoints << { concept: concept_mother, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id}
    select(concept_mother.concept_name, from: 'Family Relationship')
    concept_cancer = Concept.where(concept_code: 'LA10524-9').first
    interleave_datapoints << { concept: concept_cancer, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_disease.id}
    select(concept_cancer.concept_name, from: 'Disease')
    concept_40_to_49 = Concept.where(concept_code: 'LA10398-8').first
    interleave_datapoints << { concept: concept_40_to_49, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_age_range.id}
    select(concept_40_to_49.concept_name, from: 'Age range at diagnosis')
    observation_date = '02/01/2016'
    page.execute_script("$('#observation_observation_date').val('#{observation_date}')")
    click_button('Save')
    match_observation(1, Date.parse(observation_date), interleave_datapoints)
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

  scenario 'Sorting drug exposures', js: true, focus: false do
    start_date_1 = Date.parse('1/1/2015')
    end_date_1 = Date.parse('2/1/2015')
    durg_exposure_1 = FactoryGirl.build(:drug_exposure, person: @person_moomin, drug_concept: @concept_drug_carbidopa, drug_type_concept: @concept_drug_prescription_written, drug_exposure_start_date: start_date_1, drug_exposure_end_date: end_date_1, interleave_datapoint_id: @interleave_datapoint_drug_exposure.id)
    durg_exposure_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    start_date_2 = Date.parse('1/1/2016')
    end_date_2 = Date.parse('2/1/2016')
    durg_exposure_2 = FactoryGirl.build(:drug_exposure, person: @person_moomin, drug_concept: @concept_drug_carbidopa_25mg_oral_tablet, drug_type_concept: @concept_drug_inpatient_administration, drug_exposure_start_date: start_date_2, drug_exposure_end_date: end_date_2, interleave_datapoint_id: @interleave_datapoint_drug_exposure.id)
    durg_exposure_2.create_with_sub_datapoints!(@interleave_registry_cdm_source)

    click_link('Drug Exposure')
    match_drug_exposure(1, @concept_drug_carbidopa.concept_name, start_date_1, end_date_1, @concept_drug_prescription_written.concept_name)
    match_drug_exposure(2, @concept_drug_carbidopa_25mg_oral_tablet.concept_name, start_date_2, end_date_2, @concept_drug_inpatient_administration.concept_name)

    within(".drug_exposures_list") do
      click_link('Drug')
    end

    match_drug_exposure(1, @concept_drug_carbidopa.concept_name, start_date_1, end_date_1, @concept_drug_prescription_written.concept_name)
    match_drug_exposure(2, @concept_drug_carbidopa_25mg_oral_tablet.concept_name, start_date_2, end_date_2, @concept_drug_inpatient_administration.concept_name)

    within(".drug_exposures_list") do
      click_link('Drug')
    end

    match_drug_exposure(1, @concept_drug_carbidopa_25mg_oral_tablet.concept_name, start_date_2, end_date_2, @concept_drug_inpatient_administration.concept_name)
    match_drug_exposure(2, @concept_drug_carbidopa.concept_name, start_date_1, end_date_1, @concept_drug_prescription_written.concept_name)


    within(".drug_exposures_list") do
      click_link('Start')
    end

    match_drug_exposure(1, @concept_drug_carbidopa.concept_name, start_date_1, end_date_1, @concept_drug_prescription_written.concept_name)
    match_drug_exposure(2, @concept_drug_carbidopa_25mg_oral_tablet.concept_name, start_date_2, end_date_2, @concept_drug_inpatient_administration.concept_name)

    within(".drug_exposures_list") do
      click_link('Start')
    end

    match_drug_exposure(1, @concept_drug_carbidopa_25mg_oral_tablet.concept_name, start_date_2, end_date_2, @concept_drug_inpatient_administration.concept_name)
    match_drug_exposure(2, @concept_drug_carbidopa.concept_name, start_date_1, end_date_1, @concept_drug_prescription_written.concept_name)

    within(".drug_exposures_list") do
      click_link('End')
    end

    match_drug_exposure(1, @concept_drug_carbidopa.concept_name, start_date_1, end_date_1, @concept_drug_prescription_written.concept_name)
    match_drug_exposure(2, @concept_drug_carbidopa_25mg_oral_tablet.concept_name, start_date_2, end_date_2, @concept_drug_inpatient_administration.concept_name)

    within(".drug_exposures_list") do
      click_link('End')
    end

    match_drug_exposure(1, @concept_drug_carbidopa_25mg_oral_tablet.concept_name, start_date_2, end_date_2, @concept_drug_inpatient_administration.concept_name)
    match_drug_exposure(2, @concept_drug_carbidopa.concept_name, start_date_1, end_date_1, @concept_drug_prescription_written.concept_name)

    within(".drug_exposures_list") do
      click_link('Drug Type')
    end

    match_drug_exposure(1, @concept_drug_carbidopa_25mg_oral_tablet.concept_name, start_date_2, end_date_2, @concept_drug_inpatient_administration.concept_name)
    match_drug_exposure(2, @concept_drug_carbidopa.concept_name, start_date_1, end_date_1, @concept_drug_prescription_written.concept_name)

    within(".drug_exposures_list") do
      click_link('Drug Type')
    end

    match_drug_exposure(1, @concept_drug_carbidopa.concept_name, start_date_1, end_date_1, @concept_drug_prescription_written.concept_name)
    match_drug_exposure(2, @concept_drug_carbidopa_25mg_oral_tablet.concept_name, start_date_2, end_date_2, @concept_drug_inpatient_administration.concept_name)
  end

  scenario 'Sorting observations', js: true, focus: false do
    interleave_datapoints_1 = []
    observation_date_1 = '1/1/2015'
    concept_brother = Concept.where(concept_code: 'LA10415-0').first
    interleave_datapoints_1 << { concept: concept_brother, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id}
    observation_1 = FactoryGirl.build(:observation, person: @person_moomin, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse(observation_date_1), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id, value_as_concept: concept_brother)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    concept_lung_disease = Concept.where(concept_code: 'LA10531-4').first
    interleave_datapoints_1 << { concept: concept_lung_disease, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_disease.id}
    observations.detect { |observation| observation[:interleave_datapoint_id] == @interleave_datapoint_family_history_of_disease_disease.id }[:value_as_concept_id] = concept_lung_disease.id
    concept_20_to_29 = Concept.where(concept_code: 'LA10396-2').first
    interleave_datapoints_1 << { concept: concept_20_to_29, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_age_range.id}
    observations.detect { |observation| observation[:interleave_datapoint_id] == @interleave_datapoint_family_history_of_disease_age_range.id }[:value_as_concept_id] = concept_20_to_29.id
    observation_1.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)

    interleave_datapoints_2 = []
    observation_date_2 = '1/1/2016'
    concept_nephew = Concept.where(concept_code: 'LA10419-2').first
    interleave_datapoints_2 << { concept: concept_nephew, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id}
    observation_2 = FactoryGirl.build(:observation, person: @person_moomin, observation_concept: @concept_observation_relationship_to_patient_family_member, observation_type_concept: @concept_observation_type_patient_reported, observation_date: Date.parse(observation_date_2), interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_relationship.id, value_as_concept: concept_nephew)
    sub_datapoint_entities = @interleave_datapoint_family_history_of_disease_relationship.initialize_sub_datapoint_entities
    observations = sub_datapoint_entities.map { |sub_datapoint_entity| sub_datapoint_entity.attributes.merge(interleave_datapoint_id: sub_datapoint_entity.interleave_datapoint_id).symbolize_keys }
    concept_septicemia = Concept.where(concept_code: 'LA10591-8').first
    interleave_datapoints_2 << { concept: concept_septicemia, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_disease.id}
    observations.detect { |observation| observation[:interleave_datapoint_id] == @interleave_datapoint_family_history_of_disease_disease.id }[:value_as_concept_id] = concept_septicemia.id
    concept_50_to_59 = Concept.where(concept_code: 'LA10399-6').first
    interleave_datapoints_2 << { concept: concept_50_to_59, interleave_datapoint_id: @interleave_datapoint_family_history_of_disease_age_range.id}
    observations.detect { |observation| observation[:interleave_datapoint_id] == @interleave_datapoint_family_history_of_disease_age_range.id }[:value_as_concept_id] = concept_50_to_59.id
    observation_2.create_with_sub_datapoints!(@interleave_registry_cdm_source, observations: observations)

    click_link('Family History of Disease')
    match_observation(1, Date.parse(observation_date_1), interleave_datapoints_1)
    match_observation(2, Date.parse(observation_date_2), interleave_datapoints_2)

    within(".observations_list") do
      click_link('Date')
    end

    match_observation(1, Date.parse(observation_date_1), interleave_datapoints_1)
    match_observation(2, Date.parse(observation_date_2), interleave_datapoints_2)

    within(".observations_list") do
      click_link('Date')
    end

    match_observation(1, Date.parse(observation_date_2), interleave_datapoints_2)
    match_observation(2, Date.parse(observation_date_1), interleave_datapoints_1)

    within(".observations_list") do
      click_link('Family Relationship')
    end

    match_observation(1, Date.parse(observation_date_1), interleave_datapoints_1)
    match_observation(2, Date.parse(observation_date_2), interleave_datapoints_2)

    within(".observations_list") do
      click_link('Family Relationship')
    end

    match_observation(1, Date.parse(observation_date_2), interleave_datapoints_2)
    match_observation(2, Date.parse(observation_date_1), interleave_datapoints_1)

    within(".observations_list") do
      click_link('Disease')
    end

    match_observation(1, Date.parse(observation_date_1), interleave_datapoints_1)
    match_observation(2, Date.parse(observation_date_2), interleave_datapoints_2)

    within(".observations_list") do
      click_link('Disease')
    end

    match_observation(1, Date.parse(observation_date_2), interleave_datapoints_2)
    match_observation(2, Date.parse(observation_date_1), interleave_datapoints_1)

    within(".observations_list") do
      click_link('Age range at diagnosis')
    end

    match_observation(1, Date.parse(observation_date_1), interleave_datapoints_1)
    match_observation(2, Date.parse(observation_date_2), interleave_datapoints_2)

    within(".observations_list") do
      click_link('Age range at diagnosis')
    end

    match_observation(1, Date.parse(observation_date_2), interleave_datapoints_2)
    match_observation(2, Date.parse(observation_date_1), interleave_datapoints_1)
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

def match_drug_exposure(index, concept_name, start_date, end_date, drug_type_concept_name)
  within(".drug_exposure:nth-of-type(#{index}) .drug_exposure_concept_name") do
    expect(page).to have_content(concept_name)
  end

  within(".drug_exposure:nth-of-type(#{index}) .drug_exposure_start_date") do
    expect(page).to have_content(start_date.to_s(:date))
  end

  within(".drug_exposure:nth-of-type(#{index}) .drug_exposure_end_date") do
    expect(page).to have_content(end_date.to_s(:date)) if end_date
  end

  within(".drug_exposure:nth-of-type(#{index}) .drug_exposurer_drug_type_concept_name") do
    expect(page).to have_content(drug_type_concept_name)
  end
end

def match_observation(index, observation_date, interleave_datapoints)
  within(".observation:nth-of-type(#{index}) .observation_observation_date") do
    expect(page).to have_content(observation_date.to_s(:date))
  end

  interleave_datapoints.each do |interleave_datapoint|
    within(".observation:nth-of-type(#{index}) .interleave_sub_datapoint_#{interleave_datapoint[:interleave_datapoint_id]}") do
      expect(page).to have_content(interleave_datapoint[:concept].concept_name)
    end
  end
end