class ConditionOccurrence < ActiveRecord::Base
  self.table_name = 'condition_occurrence'
  self.primary_key = 'condition_occurrence_id'
  belongs_to :condition_concept, class_name: 'Concept', foreign_key: 'condition_concept_id'
  belongs_to :condition_type_concept, class_name: 'Concept', foreign_key: 'condition_type_concept_id'

  scope :by_interleave_data_point, -> (interleave_data_point_id) { joins("JOIN interleave_entities ON condition_occurrence.condition_occurrence_id = interleave_entities.fact_id AND interleave_entities.cdm_table = 'condition_occurrence'").where('interleave_entities.interleave_datapoint_id = ?', interleave_data_point_id) }

  def self.icd10cm_vocabulary_concept_id
    Vocabulary.where(vocabulary_id: 'ICD10CM').vocabulary_concept_id
  end
end