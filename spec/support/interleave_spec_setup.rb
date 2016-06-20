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

    @concept_domain_condition = FactoryGirl.create(:concept_domain, concept_name: 'Condition', concept_id: 17)
  end
end