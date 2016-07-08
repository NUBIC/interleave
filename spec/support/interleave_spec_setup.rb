module InterleaveSpecSetup
  def interleave_spec_setup
    @concept_gender_male = FactoryGirl.create(:concept_gender_male, concept_id: 1)
    @concept_gender_female = FactoryGirl.create(:concept_gender_female, concept_id: 2)

    @concept_race_american_indian_or_alaska_native = FactoryGirl.create(:concept_race_american_indian_or_alaska_native, concept_id: 3)
    @concept_race_asian = FactoryGirl.create(:concept_race_asian, concept_id: 4)
    @concept_race_black_or_african_american = FactoryGirl.create(:concept_race_black_or_african_american, concept_id: 5)
    @concept_race_native_hawaiian_or_other_pacific_islander = FactoryGirl.create(:concept_race_native_hawaiian_or_other_pacific_islander, concept_id: 6)
    @concept_race_white = FactoryGirl.create(:concept_race_white, concept_id: 7)

    @concept_ethnicity_hispanic_or_latino = FactoryGirl.create(:concept_ethnicity_hispanic_or_latino, concept_id: 8)
    @concept_ethnicity_not_hispanic_or_latino = FactoryGirl.create(:concept_ethnicity_not_hispanic_or_latino, concept_id: 9)

    @concept_condition_neoplasam_of_prostate = FactoryGirl.create(:concept_condition, concept_name: 'Neoplasm of prostate', concept_code: '126906006', concept_id: 10)
    @concept_condition_benign_prostatic_hyperplasia = FactoryGirl.create(:concept_condition, concept_name: 'Benign prostatic hyperplasia', concept_code: '266569009', concept_id: 11)
    @concept_condition_glioblastoma_multiforme = FactoryGirl.create(:concept_condition, concept_name: 'Glioblastoma multiforme', concept_code: '393563007', concept_id: 12)
    @concept_condition_pituitary_adenoma = FactoryGirl.create(:concept_condition, concept_name: 'Pituitary adenoma', concept_code: '254956000', concept_id: 13)

    @concept_condition_type_ehr_chief_complaint = FactoryGirl.create(:concept_condition_type, concept_name: 'EHR Chief Complaint' ,concept_id: 14)
    @concept_condition_type_ehr_episode_entry = FactoryGirl.create(:concept_condition_type, concept_name: 'EHR Episode Entry' ,concept_id: 15)
    @concept_condition_type_ehr_problem_list_entry = FactoryGirl.create(:concept_condition_type, concept_name: 'EHR problem list entry' ,concept_id: 16)

    @concept_procedure_ultrasound_transrectal = FactoryGirl.create(:concept_procedure, concept_name: 'Ultrasound, transrectal', concept_code: '76872', concept_id: 17)
    @concept_procedure_biopsy_prostate_needle = FactoryGirl.create(:concept_procedure, concept_name: 'Biopsy, prostate; needle or punch, single or multiple, any approach', concept_code: '55700', concept_id: 18)
    @concept_procedure_biopsy_prostate_incisional = FactoryGirl.create(:concept_procedure, concept_name: 'Biopsy, prostate; incisional, any approach', concept_code: '55705', concept_id: 19)

    @concept_measurement_total_number_of_cores = FactoryGirl.create(:concept_measurement, concept_name: 'Total number of cores in Tissue core by CAP cancer protocols', concept_code: '44652-6', concept_id: 20)
    @concept_measurement_total_number_of_cores_positive = FactoryGirl.create(:concept_measurement, concept_name: 'Tissue cores.positive.carcinoma in Tissue core by CAP cancer protocols', concept_code: '44651-8', concept_id: 21)
    @concept_measurement_gleason_primary = FactoryGirl.create(:concept_measurement, concept_name: 'Gleason pattern.primary in Prostate tumor by CAP cancer protocols', concept_code: '44641-9', concept_id: 22)
    @concept_measurement_perineural_invaison = FactoryGirl.create(:concept_measurement, concept_name: 'Perineural invasion by CAP cancer protocols', concept_code: '33741-0', concept_id: 23)
    @concept_measurement_answer_present = FactoryGirl.create(:concept_measurement_value, concept_name: 'Present', concept_code: 'LA9633-4', concept_id: 24)
    @concept_measurement_answer_absent = FactoryGirl.create(:concept_measurement_value, concept_name: 'Absent', concept_code: 'LA9634-2', concept_id: 25)

    @concept_procedure_type_primary_procedure = FactoryGirl.create(:concept_procedure_type, concept_name: 'Primary Procedure', concept_id: 26)
    @concept_procedure_type_secondary_procedure = FactoryGirl.create(:concept_procedure_type, concept_name: 'Secondary Procedure', concept_id: 27)

    @concept_domain_condition = FactoryGirl.create(:concept_domain, concept_name: 'Condition', concept_id: 28)
    @concept_domain_procedure = FactoryGirl.create(:concept_domain, concept_name: 'Procedure', concept_id: 29)
    @concept_domain_measurement = FactoryGirl.create(:concept_domain, concept_name: 'Measurement', concept_id: 30)

    @concept_pathology_finding = FactoryGirl.create(:concept_type, concept_name: 'Pathology finding', concept_id: 31)

    @concept_relationship_has_asso_finding = FactoryGirl.create(:concept_relationship, concept_name: 'Has associated finding (SNOMED)', concept_id: 32)

    @relationship_has_asso_finding = FactoryGirl.create(:relationship, relationship_id: 'Has asso finding', relationship_name: 'Has asso finding', is_hierarchical: false, defines_ancestry: false, reverse_relationship_id: 'Asso finding of', relationship_concept_id: @concept_relationship_has_asso_finding.id)
  end
end