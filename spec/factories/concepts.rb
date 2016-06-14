FactoryGirl.define do
  factory :concept_condition_type, class: Concept do
    domain_id Concept::DOMAIN_ID_TYPE_CONCEPT
    vocabulary_id Concept::VOCABULARY_ID_CONDITION_TYPE
    concept_class_id Concept::CONCEPT_CLASS_CONDITION_TYPE
    standard_concept 'S'
    concept_code 'OMOP generated'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
  end

  factory :concept_domain, class: Concept do
    domain_id Concept::DOMAIN_ID_METADATA
    vocabulary_id Concept::VOCABULARY_ID_DOMAIN
    concept_class_id Concept::CONCEPT_CLASS_DOMAIN
    standard_concept nil
    concept_code 'OMOP generated'
    valid_start_date Date.parse('1970-01-01')
    valid_end_date Date.parse('2099-12-31')
  end
end
