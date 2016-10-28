class Concept < ActiveRecord::Base
  self.table_name = 'concept'
  self.primary_key = 'concept_id'

  VOCABULARY_ID_CONDITION_TYPE = 'Condition Type'
  VOCABULARY_ID_CPT4 = 'CPT4'
  VOCABULARY_ID_DOMAIN = 'Domain'
  VOCABULARY_ID_DEATH_TYPE = 'Death Type'
  VOCABULARY_ID_DRUG_TYPE = 'Drug Type'
  VOCABULARY_ID_ETHNICITY = 'Ethnicity'
  VOCABULARY_ID_GENDER = 'Gender'
  VOCABULARY_ID_LOINC = 'LOINC'
  VOCABULARY_ID_MEAS_TYPE = 'Meas Type'
  VOCABULARY_ID_OBSERVATION_TYPE = 'Observation Type'
  VOCABULARY_ID_PROCEDURE_TYPE = 'Procedure Type'
  VOCABULARY_ID_RACE = 'Race'
  VOCABULARY_ID_RELATIONSHIP = 'Relationship'
  VOCABULARY_ID_RXNORM = 'RxNorm'
  VOCABULARY_ID_SNOMED = 'SNOMED'
  VOCABULARY_ID_UCUM = 'UCUM'
  VOCABULARY_IDS = [VOCABULARY_ID_CONDITION_TYPE, VOCABULARY_ID_CPT4, VOCABULARY_ID_DOMAIN, VOCABULARY_ID_DRUG_TYPE, VOCABULARY_ID_ETHNICITY, VOCABULARY_ID_GENDER, VOCABULARY_ID_LOINC, VOCABULARY_ID_MEAS_TYPE, VOCABULARY_ID_PROCEDURE_TYPE, VOCABULARY_ID_RACE, VOCABULARY_ID_RELATIONSHIP, VOCABULARY_ID_RXNORM, VOCABULARY_ID_SNOMED, VOCABULARY_ID_UCUM]

  DOMAIN_ID_CONDITION = 'Condition'
  DOMAIN_ID_DRUG = 'Drug'
  DOMAIN_ID_GENDER = 'Gender'
  DOMAIN_ID_ETHNICITY = 'Ethnicity'
  DOMAIN_ID_MEASUREMENT = 'Measurement'
  DOMAIN_ID_MEAS_VALUE = 'Meas Value'
  DOMAIN_ID_METADATA = 'Metadata'
  DOMAIN_ID_OBSERVATION = 'Observation'
  DOMAIN_ID_PROCEDURE = 'Procedure'
  DOMAIN_ID_RACE = 'Race'
  DOMAIN_ID_RELATIONSHIP = 'Relationship'
  DOMAIN_ID_ROUTE = 'Route'
  DOMAIN_ID_TYPE_CONCEPT = 'Type Concept'
  DOMAIN_ID_UNIT = 'Unit'
  DOMAIN_IDS = [DOMAIN_ID_CONDITION, DOMAIN_ID_GENDER, DOMAIN_ID_ETHNICITY, DOMAIN_ID_MEASUREMENT, DOMAIN_ID_METADATA, DOMAIN_ID_OBSERVATION, DOMAIN_ID_PROCEDURE, DOMAIN_ID_RACE, DOMAIN_ID_RELATIONSHIP, DOMAIN_ID_ROUTE, DOMAIN_ID_TYPE_CONCEPT, DOMAIN_ID_UNIT]

  CONCEPT_CLASS_ANSWER = 'Answer'
  CONCEPT_CLASS_CLINICAL_FINDING = 'Clinical Finding'
  CONCEPT_CLASS_CONDITION_TYPE = 'Condition Type'
  CONCEPT_CLASS_DRUG_TYPE = 'Drug Type'
  CONCEPT_CLASS_CLINICAL_DRUG = 'Clinical Drug'
  CONCEPT_CLASS_CPT4 = 'CPT4'
  CONCEPT_CLASS_DEATH_TYPE = 'Death Type'
  CONCEPT_CLASS_DOMAIN = 'Domain'
  CONCEPT_CLASS_GENDER = 'Gender'
  CONCEPT_CLASS_ETHNICITY = 'Ethnicity'
  CONCEPT_CLASS_INGREDIENT = 'Ingredient'
  CONCEPT_CLASS_LAB_TEST = 'Lab Test'
  CONCEPT_CLASS_MEAS_TYPE = 'Meas Type'
  CONCEPT_CLASS_OBSERVATION_TYPE = 'Observation Type'
  CONCEPT_CLASS_PROCEDURE_TYPE = 'Procedure Type'
  CONCEPT_CLASS_QUALIFIER_VALUE = 'Qualifier Value'
  CONCEPT_CLASS_RACE = 'Race'
  CONCEPT_CLASS_RELATIONSHIP = 'Relationship'
  CONCEPT_CLASS_SURVEY = 'Survey'
  CONCEPT_CLASS_UNIT = 'Unit'
  CONCEPT_CLASSES = [CONCEPT_CLASS_ANSWER, CONCEPT_CLASS_CLINICAL_FINDING, CONCEPT_CLASS_CONDITION_TYPE, CONCEPT_CLASS_DRUG_TYPE, CONCEPT_CLASS_CPT4, CONCEPT_CLASS_DOMAIN, CONCEPT_CLASS_GENDER, CONCEPT_CLASS_ETHNICITY, CONCEPT_CLASS_LAB_TEST, CONCEPT_CLASS_MEAS_TYPE, CONCEPT_CLASS_PROCEDURE_TYPE, CONCEPT_CLASS_QUALIFIER_VALUE, CONCEPT_CLASS_RACE, CONCEPT_CLASS_RELATIONSHIP, CONCEPT_CLASS_UNIT]

  def self.standard
    where(standard_concept: 'S')
  end

  def self.valid
    where(invalid_reason: nil)
  end

  def self.condition_types
    valid.where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, vocabulary_id: Concept::VOCABULARY_ID_CONDITION_TYPE , concept_class_id: Concept::CONCEPT_CLASS_CONDITION_TYPE)
  end

  def self.domain_concepts
    valid.where(domain_id: Concept::DOMAIN_ID_METADATA, vocabulary_id: Concept::VOCABULARY_ID_DOMAIN, concept_class_id: Concept::CONCEPT_CLASS_DOMAIN)
  end

  def self.death_types
    valid.where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, vocabulary_id: Concept::VOCABULARY_ID_DEATH_TYPE , concept_class_id: Concept::CONCEPT_CLASS_DEATH_TYPE)
  end

  def self.drug_types
    valid.where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, vocabulary_id: Concept::VOCABULARY_ID_DRUG_TYPE , concept_class_id: Concept::CONCEPT_CLASS_DRUG_TYPE)
  end

  def self.measurement_types
    valid.where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, vocabulary_id: Concept::VOCABULARY_ID_MEAS_TYPE , concept_class_id: Concept::CONCEPT_CLASS_MEAS_TYPE)
  end

  def self.observation_types
    valid.where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, vocabulary_id: Concept::VOCABULARY_ID_OBSERVATION_TYPE , concept_class_id: Concept::CONCEPT_CLASS_OBSERVATION_TYPE)
  end

  def self.procedure_types
    valid.where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, vocabulary_id: Concept::VOCABULARY_ID_PROCEDURE_TYPE , concept_class_id: Concept::CONCEPT_CLASS_PROCEDURE_TYPE)
  end

  def self.routes
    valid.where(domain_id: Concept::DOMAIN_ID_ROUTE, vocabulary_id: Concept::VOCABULARY_ID_SNOMED , concept_class_id: Concept::CONCEPT_CLASS_QUALIFIER_VALUE)
  end

  def self.units
    valid.where(domain_id: Concept::DOMAIN_ID_UNIT, vocabulary_id: Concept::VOCABULARY_ID_UCUM , concept_class_id: Concept::CONCEPT_CLASS_UNIT)
  end
end