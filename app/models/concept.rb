class Concept < ActiveRecord::Base
  self.table_name = 'concept'
  self.primary_key = 'concept_id'

  VOCABULARY_ID_CONDITION_TYPE = 'Condition Type'
  VOCABULARY_ID_DOMAIN = 'Domain'
  VOCABULARY_IDS = [VOCABULARY_ID_CONDITION_TYPE, VOCABULARY_ID_DOMAIN]

  DOMAIN_ID_METADATA = 'Metadata'
  DOMAIN_ID_TYPE_CONCEPT = 'Type Concept'
  DOMAIN_IDS = [DOMAIN_ID_METADATA, DOMAIN_ID_TYPE_CONCEPT]

  CONCEPT_CLASS_CONDITION_TYPE = 'Condition Type'
  CONCEPT_CLASS_DOMAIN = 'Domain'
  CONCEPT_CLASSES = [CONCEPT_CLASS_CONDITION_TYPE, CONCEPT_CLASS_DOMAIN]

  def self.standard
    where(standard_concept: 'S')
  end

  def self.valid
    where(invalid_reason: nil)
  end

  def self.condition_types
    where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, vocabulary_id: Concept::VOCABULARY_ID_CONDITION_TYPE , concept_class_id: Concept::CONCEPT_CLASS_CONDITION_TYPE)
  end

  def self.domain_concepts
    where(domain_id: Concept::DOMAIN_ID_METADATA, vocabulary_id: Concept::VOCABULARY_ID_DOMAIN, concept_class_id: Concept::CONCEPT_CLASS_DOMAIN)
  end
end
