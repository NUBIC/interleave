FactoryGirl.define do
  factory :concept_procedure, class: Concept do
    domain_id Concept::DOMAIN_ID_PROCEDURE
    vocabulary_id Concept::VOCABULARY_ID_CPT4
    concept_class_id Concept::CONCEPT_CLASS_CPT4
    standard_concept 'S'
    concept_code nil
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_procedure_type, class: Concept do
    domain_id Concept::DOMAIN_ID_TYPE_CONCEPT
    vocabulary_id Concept::VOCABULARY_ID_PROCEDURE_TYPE
    concept_class_id Concept::CONCEPT_CLASS_PROCEDURE_TYPE
    standard_concept 'S'
    concept_code 'OMOP generated'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_condition, class: Concept do
    domain_id Concept::DOMAIN_ID_CONDITION
    vocabulary_id Concept::VOCABULARY_ID_SNOMED
    concept_class_id Concept::CONCEPT_CLASS_CLINICAL_FINDING
    standard_concept 'S'
    concept_code nil
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_condition_type, class: Concept do
    domain_id Concept::DOMAIN_ID_TYPE_CONCEPT
    vocabulary_id Concept::VOCABULARY_ID_CONDITION_TYPE
    concept_class_id Concept::CONCEPT_CLASS_CONDITION_TYPE
    standard_concept 'S'
    concept_code 'OMOP generated'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_domain, class: Concept do
    domain_id Concept::DOMAIN_ID_METADATA
    vocabulary_id Concept::VOCABULARY_ID_DOMAIN
    concept_class_id Concept::CONCEPT_CLASS_DOMAIN
    standard_concept nil
    concept_code 'OMOP generated'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_gender_male, class: Concept do
    concept_name 'Male'
    domain_id Concept::DOMAIN_ID_GENDER
    vocabulary_id Concept::VOCABULARY_ID_GENDER
    concept_class_id Concept::CONCEPT_CLASS_GENDER
    standard_concept 'S'
    concept_code 'M'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_gender_female, class: Concept do
    concept_name 'Female'
    domain_id Concept::DOMAIN_ID_GENDER
    vocabulary_id Concept::VOCABULARY_ID_GENDER
    concept_class_id Concept::CONCEPT_CLASS_GENDER
    standard_concept 'S'
    concept_code 'F'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_race_american_indian_or_alaska_native, class: Concept do
    concept_name 'American Indian or Alaska Native'
    domain_id Concept::DOMAIN_ID_RACE
    vocabulary_id Concept::VOCABULARY_ID_RACE
    concept_class_id Concept::CONCEPT_CLASS_RACE
    standard_concept 'S'
    concept_code '1'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_race_asian, class: Concept do
    concept_name 'Asian'
    domain_id Concept::DOMAIN_ID_RACE
    vocabulary_id Concept::VOCABULARY_ID_RACE
    concept_class_id Concept::CONCEPT_CLASS_RACE
    standard_concept 'S'
    concept_code '2'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_race_black_or_african_american, class: Concept do
    concept_name 'Black or African American'
    domain_id Concept::DOMAIN_ID_RACE
    vocabulary_id Concept::VOCABULARY_ID_RACE
    concept_class_id Concept::CONCEPT_CLASS_RACE
    standard_concept 'S'
    concept_code '3'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_race_native_hawaiian_or_other_pacific_islander, class: Concept do
    concept_name 'Native Hawaiian or Other Pacific Islander'
    domain_id Concept::DOMAIN_ID_RACE
    vocabulary_id Concept::VOCABULARY_ID_RACE
    concept_class_id Concept::CONCEPT_CLASS_RACE
    standard_concept 'S'
    concept_code '4'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_race_white, class: Concept do
    concept_name 'White'
    domain_id Concept::DOMAIN_ID_RACE
    vocabulary_id Concept::VOCABULARY_ID_RACE
    concept_class_id Concept::CONCEPT_CLASS_RACE
    standard_concept 'S'
    concept_code '5'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_ethnicity_hispanic_or_latino, class: Concept do
    concept_name 'Hispanic or Latino'
    domain_id Concept::DOMAIN_ID_ETHNICITY
    vocabulary_id Concept::VOCABULARY_ID_ETHNICITY
    concept_class_id Concept::CONCEPT_CLASS_ETHNICITY
    standard_concept 'S'
    concept_code 'Hispanic'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end

  factory :concept_ethnicity_not_hispanic_or_latino, class: Concept do
    concept_name 'Not Hispanic or Latino'
    domain_id Concept::DOMAIN_ID_ETHNICITY
    vocabulary_id Concept::VOCABULARY_ID_ETHNICITY
    concept_class_id Concept::CONCEPT_CLASS_ETHNICITY
    standard_concept 'S'
    concept_code 'Not Hispanic'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
    invalid_reason nil
  end
end