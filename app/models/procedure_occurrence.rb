class ProcedureOccurrence < ActiveRecord::Base
  include Interleaveable
  self.table_name = 'procedure_occurrence'
  self.primary_key = 'procedure_occurrence_id'
  belongs_to :procedure_concept, class_name: 'Concept', foreign_key: 'procedure_concept_id'
  belongs_to :procedure_type_concept, class_name: 'Concept', foreign_key: 'procedure_type_concept_id'
  belongs_to :modifier_concept, class_name: 'Concept', foreign_key: 'modifier_concept_id'
  belongs_to :person, class_name: 'Person', foreign_key: 'person_id'
  DOMAIN_ID = 'Procedure'

  validates_numericality_of :quantity, message: 'is not a number', only_integer: true, greater_than: 0, allow_nil: true
  validates_presence_of :procedure_concept_id, :procedure_date, :procedure_type_concept_id

  def self.by_interleave_data_point(interleave_data_point_id, options = {})
    options = { sort_column: 'procedure_date', sort_direction: 'asc' }.merge(options)
    s = joins("JOIN concept AS procedure_type_concept ON procedure_occurrence.procedure_type_concept_id = procedure_type_concept.concept_id JOIN concept AS procedure_concept ON procedure_occurrence.procedure_concept_id = procedure_concept.concept_id JOIN interleave_entities ON procedure_occurrence.procedure_occurrence_id = interleave_entities.fact_id AND interleave_entities.cdm_table = 'procedure_occurrence'").where('interleave_entities.interleave_datapoint_id = ?', interleave_data_point_id)
    sort = options[:sort_column] + ' ' + options[:sort_direction]
    s = s.order(sort)

    s
  end
end
