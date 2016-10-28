module InterleaveSpecSetup
  def interleave_spec_setup
    concept_id = 0
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

    @concept_observation_relationship_to_patient_family_member = FactoryGirl.create(:concept_observation, concept_name: 'Relationship to patient family member [USSG-FHT]', concept_code: '54136-7', concept_id: concept_id+=1)
    @concept_observation_relationship_to_patient_family_member_answers = []

    [{ concept_name: 'Paternal Grandmother', concept_code: 'LA10424-2' },
    { concept_name: 'Maternal Cousin', concept_code: 'LA10411-9' },
    { concept_name: 'Paternal Grandfather', concept_code: 'LA10423-4' },
    { concept_name: 'Father', concept_code: 'LA10416-8' },
    { concept_name: 'Maternal Aunt', concept_code: 'LA10410-1' },
    { concept_name: 'Niece', concept_code: 'LA10420-0' },
    { concept_name: 'Maternal Grandfather', concept_code: 'LA10412-7' },
    { concept_name: 'Brother', concept_code: 'LA10415-0' },
    { concept_name: 'Daughter', concept_code: 'LA10405-1' },
    { concept_name: 'Granddaughter', concept_code: 'LA10406-9' },
    { concept_name: 'Half-sister', concept_code: 'LA10409-3' },
    { concept_name: 'Half-brother', concept_code: 'LA10408-5' },
    { concept_name: 'Son', concept_code: 'LA10426-7' },
    { concept_name: 'Paternal Cousin', concept_code: 'LA10422-6' },
    { concept_name: 'Paternal Aunt', concept_code: 'LA10421-8' },
    { concept_name: 'Paternal Uncle', concept_code: 'LA10425-9' },
    { concept_name: 'Nephew', concept_code: 'LA10419-2' },
    { concept_name: 'Sister', concept_code: 'LA10418-4' },
    { concept_name: 'Mother', concept_code: 'LA10417-6' },
    { concept_name: 'Maternal Uncle', concept_code: 'LA10414-3' },
    { concept_name: 'Grandson', concept_code: 'LA10407-7' },
    { concept_name: 'Maternal Grandmother', concept_code: 'LA10413-5' }].each do |answer|
      @concept_observation_relationship_to_patient_family_member_answers <<  FactoryGirl.create(:concept_meas_value, concept_name: answer[:concept_name], concept_code: answer[:concept_code], concept_id: concept_id+=1)
    end

    @concept_observation_relationship_to_patient_family_member_disease= FactoryGirl.create(:concept_observation, concept_name: 'History of diseases family member [USSG-FHT]', concept_code: '54116-9', concept_id: concept_id+=1)
    @concept_observation_relationship_to_patient_family_member_disease_answers = []

    [{ concept_name: "Sudden Infant Death Syndrome", concept_code: "LA10530-6"},
    { concept_name: "-- Diabetes Type 1", concept_code: "LA10551-2"},
    { concept_name: "Cancer", concept_code: "LA10524-9"},
    { concept_name: "Osteoporosis", concept_code: "LA10527-2"},
    { concept_name: "-- Bone Cancer", concept_code: "LA10549-6"},
    { concept_name: "-- Crohn's Disease", concept_code: "LA10554-6"},
    { concept_name: "-- Panic Disorder", concept_code: "LA10582-7"},
    { concept_name: "-- Nephritis", concept_code: "LA10568-6"},
    { concept_name: "Hypertension", concept_code: "LA7444-8"},
    { concept_name: "-- Dementia", concept_code: "LA10586-8"},
    { concept_name: "-- Attention Deficit Hyper Activity", concept_code: "LA10577-7"},
    { concept_name: "Stroke/Brain Attack", concept_code: "LA10522-3"},
    { concept_name: "-- Uterine Cancer", concept_code: "LA10544-7"},
    { concept_name: "-- Gestational Diabetes", concept_code: "LA10553-8"},
    { concept_name: "-- Irritable Bowel Syndrome", concept_code: "LA10555-3"},
    { concept_name: "Blood Clots", concept_code: "LA10533-0"},
    { concept_name: "-- Leukemia", concept_code: "LA10545-4"},
    { concept_name: "-- Thyroid Cancer", concept_code: "LA10540-5"},
    { concept_name: "-- Other Cancer", concept_code: "LA10550-4"},
    { concept_name: "-- Influenza/Pneumonia", concept_code: "LA10563-7"},
    { concept_name: "Neurological Disorders", concept_code: "LA10590-0"},
    { concept_name: "Kidney Disease", concept_code: "LA10528-0"},
    { concept_name: "-- Esophageal Cancer", concept_code: "LA10548-8"},
    { concept_name: "-- Post Traumatic Stress Disorder", concept_code: "LA10583-5"},
    { concept_name: "-- Chronic Bronchitis", concept_code: "LA10560-3"},
    { concept_name: "-- Autism", concept_code: "LA10578-5"},
    { concept_name: "-- Blood Clot in Lungs", concept_code: "LA10573-6"},
    { concept_name: "-- Other/Unknown", concept_code: "LA10571-0"},
    { concept_name: "-- Emphysema", concept_code: "LA10561-1"},
    { concept_name: "-- Cystic Kidney Disease", concept_code: "LA10565-2"},
    { concept_name: "-- Kidney Disease Present From Birth", concept_code: "LA10566-0"},
    { concept_name: "-- Social Phobia", concept_code: "LA10585-0"},
    { concept_name: "-- Nephrosis", concept_code: "LA10567-8"},
    { concept_name: "-- Ovarian Cancer", concept_code: "LA10539-7"},
    { concept_name: "-- Gastric Cancer", concept_code: "LA10547-0"},
    { concept_name: "-- Personality Disorder", concept_code: "LA10579-3"},
    { concept_name: "-- Anxiety", concept_code: "LA10574-4"},
    { concept_name: "-- Muscle Cancer", concept_code: "LA10546-2"},
    { concept_name: "Heart Disease", concept_code: "LA10523-1"},
    { concept_name: "-- Bipolar/Manic Depressive Disorder", concept_code: "LA10575-1"},
    { concept_name: "-- Blood Clot in Leg", concept_code: "LA10572-8"},
    { concept_name: "Gastrointestinal Disease", concept_code: "LA10532-2"},
    { concept_name: "-- Ulceritive Colitis", concept_code: "LA10556-1"},
    { concept_name: "-- Chronic Lower Respiratory Disease", concept_code: "LA10562-9"},
    { concept_name: "Lung Disease", concept_code: "LA10531-4"},
    { concept_name: "-- Colon Polyps", concept_code: "LA10557-9"},
    { concept_name: "-- Eating Disorder", concept_code: "LA10580-1"},
    { concept_name: "-- COPD", concept_code: "LA10559-5"},
    { concept_name: "-- Diabetic Kidney Disease", concept_code: "LA10570-2"},
    { concept_name: "-- Lung Cancer", concept_code: "LA10542-1"},
    { concept_name: "Diabetes", concept_code: "LA10529-8"},
    { concept_name: "-- Heart Attack", concept_code: "LA10558-7"},
    { concept_name: "-- Obsessive Compulsive Disorder", concept_code: "LA10581-9"},
    { concept_name: "Psychological Disorders", concept_code: "LA10535-5"},
    { concept_name: "-- Skin Cancer", concept_code: "LA10543-9"},
    { concept_name: "-- Nephrotic Syndrome", concept_code: "LA10569-4"},
    { concept_name: "-- Prostate Cancer", concept_code: "LA10538-9"},
    { concept_name: "-- Kidney Cancer", concept_code: "LA10541-3"},
    { concept_name: "-- Schizophrenia", concept_code: "LA10584-3"},
    { concept_name: "Septicemia", concept_code: "LA10591-8"},
    { concept_name: "-- Asthma", concept_code: "LA10564-5"},
    { concept_name: "-- Diabetes Type 2", concept_code: "LA10552-0"},
    { concept_name: "-- Depression", concept_code: "LA10576-9"},
    { concept_name: "-- Colon Cancer", concept_code: "LA10537-1"},
    { concept_name: "-- Breast Cancer", concept_code: "LA10536-3"},
    { concept_name: "High Cholesterol/Hyperlipidemia", concept_code: "LA10526-4"}].each do |answer|
      @concept_observation_relationship_to_patient_family_member_disease_answers <<  FactoryGirl.create(:concept_meas_value, concept_name: answer[:concept_name], concept_code: answer[:concept_code], concept_id: concept_id+=1)
    end

    @concept_observation_age_range_at_onset_of_disease_family_member= FactoryGirl.create(:concept_observation, concept_name: 'Age range at onset of disease family member [USSG-FHT]', concept_code: '54115-1', concept_id: concept_id+=1)
    @concept_observation_age_range_at_onset_of_disease_family_member_answers = []

    [{ concept_name: "Childhood", concept_code: "LA10395-4"},
    { concept_name: "50-59", concept_code: "LA10399-6"},
    { concept_name: "Pre-Birth", concept_code: "LA10402-8"},
    { concept_name: "40-49", concept_code: "LA10398-8"},
    { concept_name: "Infancy", concept_code: "LA10394-7"},
    { concept_name: "Newborn", concept_code: "LA10403-6"},
    { concept_name: "20-29", concept_code: "LA10396-2"},
    { concept_name: "OVER 60", concept_code: "LA10400-2"},
    { concept_name: "Adolescence", concept_code: "LA10404-4"},
    { concept_name: "30-39", concept_code: "LA10397-0"},
    { concept_name: "Unknown", concept_code: "LA4489-6"}].each do |answer|
      @concept_observation_age_range_at_onset_of_disease_family_member_answers <<  FactoryGirl.create(:concept_meas_value, concept_name: answer[:concept_name], concept_code: answer[:concept_code], concept_id: concept_id+=1)
    end

    @concept_observation_type_patient_reported = FactoryGirl.create(:concept_observation_type, concept_name: 'Patient reported', concept_id: concept_id+=1)

    @concept_procedure_type_primary_procedure = FactoryGirl.create(:concept_procedure_type, concept_name: 'Primary Procedure', concept_id: concept_id+=1)
    @concept_procedure_type_secondary_procedure = FactoryGirl.create(:concept_procedure_type, concept_name: 'Secondary Procedure', concept_id: concept_id+=1)

    @concept_domain_condition = FactoryGirl.create(:concept_domain, concept_name: 'Condition', concept_id: concept_id+=1)
    @concept_domain_drug_exposure = FactoryGirl.create(:concept_domain, concept_name: 'Drug', concept_id: concept_id+=1)
    @concept_domain_measurement = FactoryGirl.create(:concept_domain, concept_name: 'Measurement', concept_id: concept_id+=1)
    @concept_domain_observation = FactoryGirl.create(:concept_domain, concept_name: 'Observation', concept_id: concept_id+=1)
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
      @psa_concepts <<  psa_concept = FactoryGirl.create(:concept_measurement, concept_name: psa_concept[:concept_name], concept_code: psa_concept[:concept_code], concept_id: concept_id+=1)
      instance_variable_set("@psa_concept_#{i}", psa_concept)
    end

    @death_types_concepts = []

    ['Death Certificate contributory cause',
    'Death Certificate immediate cause',
    'Death Certificate underlying cause',
    'EHR Record contributory cause',
    'EHR Record immediate cause',
    'EHR Record underlying cause',
    'EHR discharge status "Expired"',
    'EHR record patient status "Deceased"',
    'Medical claim DRG code indicating death',
    'Medical claim diagnostic code indicating death',
    'Medical claim discharge status "Died"',
    'Other government reported or identified death',
    'Payer enrollment status "Deceased"',
    'US Social Security Death Master File record'
     ].each do |death_type_concept|
       @death_types_concepts <<  FactoryGirl.create(:concept_death_type, concept_name: death_type_concept, concept_id: concept_id+=1)
     end
  end
end