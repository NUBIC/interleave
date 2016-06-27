class ConditionOccurrence < ActiveRecord::Base
  include Interleaveable
  self.table_name = 'condition_occurrence'
  self.primary_key = 'condition_occurrence_id'
  belongs_to :condition_concept, class_name: 'Concept', foreign_key: 'condition_concept_id'
  belongs_to :condition_type_concept, class_name: 'Concept', foreign_key: 'condition_type_concept_id'
  belongs_to :person, class_name: 'Person', foreign_key: 'person_id'
  DOMAIN_ID = 'Condition'

  validates_presence_of :condition_concept_id, :condition_start_date, :condition_type_concept_id

  def self.by_interleave_data_point(interleave_data_point_id, options = {})
    options = { sort_column: 'condition_start_date', sort_direction: 'asc' }.merge(options)
    s = joins("JOIN concept AS condition_type_concept ON condition_occurrence.condition_concept_id = condition_type_concept.concept_id JOIN concept AS condition_concept ON condition_occurrence.condition_concept_id = condition_concept.concept_id JOIN interleave_entities ON condition_occurrence.condition_occurrence_id = interleave_entities.fact_id AND interleave_entities.cdm_table = 'condition_occurrence'").where('interleave_entities.interleave_datapoint_id = ?', interleave_data_point_id)
    sort = options[:sort_column] + ' ' + options[:sort_direction]
    s = s.order(sort)

    s
  end
end
