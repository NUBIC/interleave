class ConditionOccurrence < ActiveRecord::Base
  self.table_name = 'condition_occurrence'
  self.primary_key = 'condition_occurrence_id'
  belongs_to :condition_concept, class_name: 'Concept', foreign_key: 'condition_concept_id'
  belongs_to :condition_type_concept, class_name: 'Concept', foreign_key: 'condition_type_concept_id'
  belongs_to :person, class_name: 'Person', foreign_key: 'person_id'
  DOMAIN_ID = 'Condition'

  validates_presence_of :condition_concept_id, :condition_start_date, :condition_type_concept_id
  validates_presence_of :interleave_datapoint_id, :interleave_registry_cdm_source_id, on: :create

  attr_accessor :interleave_datapoint_id, :interleave_registry_cdm_source_id

  after_create :create_interleave_entity

  def create_interleave_entity
    InterleaveEntity.create(interleave_datapoint_id: interleave_datapoint_id, cdm_table: self.class.table_name, domain_concept_id: self.class.domain_concept.id, fact_id: id, interleave_registry_cdm_source_id: interleave_registry_cdm_source_id)
  end

  def self.by_person(person_id)
    where(person_id: person_id)
  end

  def self.by_interleave_data_point(interleave_data_point_id, options = {})
    options = { sort_column: 'condition_start_date', sort_direction: 'asc' }.merge(options)
    s = joins("JOIN concept AS condition_type_concept ON condition_occurrence.condition_concept_id = condition_type_concept.concept_id JOIN concept AS condition_concept ON condition_occurrence.condition_concept_id = condition_concept.concept_id JOIN interleave_entities ON condition_occurrence.condition_occurrence_id = interleave_entities.fact_id AND interleave_entities.cdm_table = 'condition_occurrence'").where('interleave_entities.interleave_datapoint_id = ?', interleave_data_point_id)
    sort = options[:sort_column] + ' ' + options[:sort_direction]
    s = s.order(sort)

    s
  end

  def self.domain_concept
    Concept.domain_concepts.valid.where(concept_name: DOMAIN_ID).first
  end
end