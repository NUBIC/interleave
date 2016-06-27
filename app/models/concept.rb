class Concept < ActiveRecord::Base
  self.table_name = 'concept'
  self.primary_key = 'concept_id'

  VOCABULARY_ID_CONDITION_TYPE = 'Condition Type'
  VOCABULARY_ID_CPT4 = 'CPT4'
  VOCABULARY_ID_DOMAIN = 'Domain'
  VOCABULARY_ID_ETHNICITY = 'Ethnicity'
  VOCABULARY_ID_GENDER = 'Gender'
  VOCABULARY_ID_PROCEDURE_TYPE = 'Procedure Type'
  VOCABULARY_ID_RACE = 'Race'
  VOCABULARY_ID_SNOMED = 'SNOMED'
  VOCABULARY_IDS = [VOCABULARY_ID_CONDITION_TYPE, VOCABULARY_ID_DOMAIN, VOCABULARY_ID_ETHNICITY, VOCABULARY_ID_GENDER, VOCABULARY_ID_RACE, VOCABULARY_ID_SNOMED]

  DOMAIN_ID_CONDITION = 'Condition'
  DOMAIN_ID_GENDER = 'Gender'
  DOMAIN_ID_ETHNICITY = 'Ethnicity'
  DOMAIN_ID_METADATA = 'Metadata'
  DOMAIN_ID_PROCEDURE = 'Procedure'
  DOMAIN_ID_RACE = 'Race'
  DOMAIN_ID_TYPE_CONCEPT = 'Type Concept'
  DOMAIN_IDS = [DOMAIN_ID_CONDITION, DOMAIN_ID_GENDER, DOMAIN_ID_ETHNICITY, DOMAIN_ID_METADATA, DOMAIN_ID_PROCEDURE, DOMAIN_ID_RACE, DOMAIN_ID_TYPE_CONCEPT]

  CONCEPT_CLASS_CLINICAL_FINDING = 'Clinical Finding'
  CONCEPT_CLASS_CONDITION_TYPE = 'Condition Type'
  CONCEPT_CLASS_CPT4 = 'CPT4'
  CONCEPT_CLASS_DOMAIN = 'Domain'
  CONCEPT_CLASS_GENDER = 'Gender'
  CONCEPT_CLASS_ETHNICITY = 'Ethnicity'
  CONCEPT_CLASS_PROCEDURE_TYPE = 'Procedure Type'
  CONCEPT_CLASS_RACE = 'Race'
  CONCEPT_CLASSES = [CONCEPT_CLASS_CONDITION_TYPE, CONCEPT_CLASS_DOMAIN, CONCEPT_CLASS_GENDER, CONCEPT_CLASS_ETHNICITY, CONCEPT_CLASS_RACE]

  def self.standard
    where(standard_concept: 'S')
  end

  def self.valid
    where(invalid_reason: nil)
  end

  def self.condition_types
    where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, vocabulary_id: Concept::VOCABULARY_ID_CONDITION_TYPE , concept_class_id: Concept::CONCEPT_CLASS_CONDITION_TYPE)
  end

  def self.procedure_types
    where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, vocabulary_id: Concept::VOCABULARY_ID_PROCEDURE_TYPE , concept_class_id: Concept::CONCEPT_CLASS_PROCEDURE_TYPE)
  end

  def self.domain_concepts
    where(domain_id: Concept::DOMAIN_ID_METADATA, vocabulary_id: Concept::VOCABULARY_ID_DOMAIN, concept_class_id: Concept::CONCEPT_CLASS_DOMAIN)
  end
end
