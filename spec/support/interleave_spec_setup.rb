module InterleaveSpecSetup
  def interleave_spec_setup
    concept_id = 1
    @concept_gender_male = FactoryGirl.create(:concept_gender_male, concept_id: concept_id+=1)
    @concept_gender_female = FactoryGirl.create(:concept_gender_female, concept_id: concept_id+=1)

    @concept_race_american_indian_or_alaska_native = FactoryGirl.create(:concept_race_american_indian_or_alaska_native, concept_id: concept_id+=1)
    @concept_race_asian = FactoryGirl.create(:concept_race_asian, concept_id: concept_id+=1)
    @concept_race_black_or_african_american = FactoryGirl.create(:concept_race_black_or_african_american, concept_id: concept_id+=1)
    @concept_race_native_hawaiian_or_other_pacific_islander = FactoryGirl.create(:concept_race_native_hawaiian_or_other_pacific_islander, concept_id: concept_id+=1)
    @concept_race_white = FactoryGirl.create(:concept_race_white, concept_id: concept_id+=1)

    @concept_ethnicity_hispanic_or_latino = FactoryGirl.create(:concept_ethnicity_hispanic_or_latino, concept_id: concept_id+=1)
    @concept_ethnicity_not_hispanic_or_latino = FactoryGirl.create(:concept_ethnicity_not_hispanic_or_latino, concept_id: concept_id+=1)

    @concept_condition_neoplasam_of_prostate = FactoryGirl.create(:concept_condition, concept_name: 'Neoplasm of prostate', concept_code: '126906006', concept_id: concept_id+=1)
    @concept_condition_benign_prostatic_hyperplasia = FactoryGirl.create(:concept_condition, concept_name: 'Benign prostatic hyperplasia', concept_code: '266569009', concept_id: concept_id+=1)
    @concept_condition_glioblastoma_multiforme = FactoryGirl.create(:concept_condition, concept_name: 'Glioblastoma multiforme', concept_code: '393563007', concept_id: concept_id+=1)
    @concept_condition_pituitary_adenoma = FactoryGirl.create(:concept_condition, concept_name: 'Pituitary adenoma', concept_code: '254956000', concept_id: concept_id+=1)

    @concept_condition_type_ehr_chief_complaint = FactoryGirl.create(:concept_condition_type, concept_name: 'EHR Chief Complaint' ,concept_id: concept_id+=1)
    @concept_condition_type_ehr_episode_entry = FactoryGirl.create(:concept_condition_type, concept_name: 'EHR Episode Entry' ,concept_id: concept_id+=1)
    @concept_condition_type_ehr_problem_list_entry = FactoryGirl.create(:concept_condition_type, concept_name: 'EHR problem list entry' ,concept_id: concept_id+=1)

    @concept_procedure_ultrasound_transrectal = FactoryGirl.create(:concept_procedure, concept_name: 'Ultrasound, transrectal', concept_code: '76872', concept_id: concept_id+=1)
    @concept_procedure_biopsy_prostate_needle = FactoryGirl.create(:concept_procedure, concept_name: 'Biopsy, prostate; needle or punch, single or multiple, any approach', concept_code: '55700', concept_id: concept_id+=1)
    @concept_procedure_biopsy_prostate_incisional = FactoryGirl.create(:concept_procedure, concept_name: 'Biopsy, prostate; incisional, any approach', concept_code: '55705', concept_id: concept_id+=1)

    @concept_measurement_total_number_of_cores = FactoryGirl.create(:concept_measurement, concept_name: 'Total number of cores in Tissue core by CAP cancer protocols', concept_code: '44652-6', concept_id: concept_id+=1)
    @concept_measurement_total_number_of_cores_positive = FactoryGirl.create(:concept_measurement, concept_name: 'Tissue cores.positive.carcinoma in Tissue core by CAP cancer protocols', concept_code: '44651-8', concept_id: concept_id+=1)
    @concept_measurement_gleason_primary = FactoryGirl.create(:concept_measurement, concept_name: 'Gleason pattern.primary in Prostate tumor by CAP cancer protocols', concept_code: '44641-9', concept_id: concept_id+=1)
    @concept_measurement_perineural_invaison = FactoryGirl.create(:concept_measurement, concept_name: 'Perineural invasion by CAP cancer protocols', concept_code: '33741-0', concept_id: concept_id+=1)
    @concept_measurement_answer_present = FactoryGirl.create(:concept_measurement_value, concept_name: 'Present', concept_code: 'LA9633-4', concept_id: concept_id+=1)
    @concept_measurement_answer_absent = FactoryGirl.create(:concept_measurement_value, concept_name: 'Absent', concept_code: 'LA9634-2', concept_id: concept_id+=1)
    @concept_measurement_body_weight_measured = FactoryGirl.create(:concept_measurement, concept_name: 'Body weight Measured', concept_code: '3141-9', concept_id: concept_id+=1)
    @concept_measurement_body_height_measured = FactoryGirl.create(:concept_measurement, concept_name: 'Body height Measured', concept_code: '3137-7', concept_id: concept_id+=1)

    @concept_procedure_type_primary_procedure = FactoryGirl.create(:concept_procedure_type, concept_name: 'Primary Procedure', concept_id: concept_id+=1)
    @concept_procedure_type_secondary_procedure = FactoryGirl.create(:concept_procedure_type, concept_name: 'Secondary Procedure', concept_id: concept_id+=1)

    @concept_domain_condition = FactoryGirl.create(:concept_domain, concept_name: 'Condition', concept_id: concept_id+=1)
    @concept_domain_drug_exposure = FactoryGirl.create(:concept_domain, concept_name: 'Drug', concept_id: concept_id+=1)
    @concept_domain_measurement = FactoryGirl.create(:concept_domain, concept_name: 'Measurement', concept_id: concept_id+=1)
    @concept_domain_procedure = FactoryGirl.create(:concept_domain, concept_name: 'Procedure', concept_id: concept_id+=1)

    @concept_pathology_finding = FactoryGirl.create(:concept_type, concept_name: 'Pathology finding', concept_id: concept_id+=1)
    @concept_lab_result = FactoryGirl.create(:concept_type, concept_name: 'Lab result', concept_id: concept_id+=1)

    @concept_drug_carbidopa = FactoryGirl.create(:concept_drug_ingredient, concept_name: 'Carbidopa', concept_code: '2019', concept_id: concept_id+=1)
    @concept_drug_carbidopa_25mg_oral_tablet = FactoryGirl.create(:concept_drug_clinical_drug, concept_name: 'Carbidopa 25 MG Oral Tablet', concept_code: '260260', concept_id: concept_id+=1)

    @concept_drug_prescription_written = FactoryGirl.create(:concept_drug_type, concept_name: 'Prescription written', concept_id: concept_id+=1)
    @concept_drug_inpatient_administration = FactoryGirl.create(:concept_drug_type, concept_name: 'Inpatient administration', concept_id: concept_id+=1)

    @concept_relationship_has_asso_finding = FactoryGirl.create(:concept_relationship, concept_name: 'Has associated finding (SNOMED)', concept_id: concept_id+=1)
    @relationship_has_asso_finding = FactoryGirl.create(:relationship, relationship_id: 'Has asso finding', relationship_name: 'Has asso finding', is_hierarchical: false, defines_ancestry: false, reverse_relationship_id: 'Asso finding of', relationship_concept_id: @concept_relationship_has_asso_finding.id)

    @psa_concepts = []
    [{ concept_name: 'Prostate Specific Ag Free [Mass/volume] in Body fluid' , concept_code: '59239-4' },
    { concept_name: 'Prostate Specific Ag Free [Mass/volume] in Cerebral spinal fluid' , concept_code: '59231-1' },
    { concept_name: 'Prostate Specific Ag Free [Mass/volume] in Peritoneal fluid' , concept_code: '59224-6' },
    { concept_name: 'Prostate Specific Ag Free [Mass/volume] in Pleural fluid' , concept_code: '59232-9' },
    { concept_name: 'Prostate Specific Ag Free [Mass/volume] in Semen' , concept_code: '19205-4' },
    { concept_name: 'Prostate Specific Ag Free [Moles/volume] in Semen' , concept_code: '19206-2' },
    { concept_name: 'Prostate Specific Ag Free [Moles/volume] in Serum or Plasma' , concept_code: '19203-9' },
    { concept_name: 'Prostate Specific Ag Free [Units/volume] in Semen' , concept_code: '19204-7' },
    { concept_name: 'Prostate Specific Ag Free [Units/volume] in Serum or Plasma' , concept_code: '19201-3' },
    { concept_name: 'Prostate Specific Ag Free/Prostate specific Ag.total [Pure mass fraction] in Serum or Plasma' , concept_code: '72576-2' },
    { concept_name: 'Prostate Specific Ag Free/Prostate specific Ag.total in Body fluid' , concept_code: '59238-6' },
    { concept_name: 'Prostate Specific Ag Free/Prostate specific Ag.total in Cerebral spinal fluid' , concept_code: '59235-2' },
    { concept_name: 'Prostate Specific Ag Free/Prostate specific Ag.total in Peritoneal fluid' , concept_code: '59236-0' },
    { concept_name: 'Prostate Specific Ag Free/Prostate specific Ag.total in Pleural fluid' , concept_code: '59237-8' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Body fluid' , concept_code: '47738-0' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Cerebral spinal fluid' , concept_code: '59230-3' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Peritoneal fluid' , concept_code: '59223-8' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Pleural fluid' , concept_code: '59221-2' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Semen' , concept_code: '19199-9' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Serum or Plasma by Detection limit <= 0.01 ng/mL' , concept_code: '35741-8' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Urine' , concept_code: '34611-4' },
    { concept_name: 'Prostate specific Ag [Moles/volume] in Semen' , concept_code: '19200-5' },
    { concept_name: 'Prostate specific Ag [Moles/volume] in Serum or Plasma' , concept_code: '19197-3' },
    { concept_name: 'Prostate specific Ag [Presence] in Tissue by Immune stain' , concept_code: '10508-0' },
    { concept_name: 'Prostate specific Ag [Units/volume] in Semen' , concept_code: '19198-1' },
    { concept_name: 'Prostate specific Ag [Units/volume] in Serum or Plasma' , concept_code: '19195-7' },
    { concept_name: 'Prostate specific Ag.protein bound [Mass/volume] in Serum or Plasma' , concept_code: '33667-7' },
    { concept_name: 'Prostate specific Ag/Creatinine [Mass Ratio] in Urine' , concept_code: '48167-1' }].each_with_index do |psa_concept, i|
      @psa_concepts <<  psa_concept = FactoryGirl.create(:concept_measurement, concept_name: psa_concept[:concept_name], concept_code: psa_concept[:concept_code], concept_id: concept_id + i)
      instance_variable_set("@psa_concept_#{i}", psa_concept)
    end
  end
end