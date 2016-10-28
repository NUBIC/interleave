class Measurement < ActiveRecord::Base
  include Interleaveable
  self.table_name = 'measurement'
  self.primary_key = 'measurement_id'
  belongs_to :measurement_concept, class_name: 'Concept', foreign_key: 'measurement_concept_id'
  belongs_to :measurement_type_concept, class_name: 'Concept', foreign_key: 'measurement_type_concept_id'
  belongs_to :person, class_name: 'Person', foreign_key: 'person_id'
  DOMAIN_ID = 'Measurement'

  validates_presence_of :measurement_concept_id, :measurement_date, :measurement_type_concept_id

  def self.by_interleave_data_point(interleave_data_point_id, options = {})
    options = { sort_column: 'measurement_date', sort_direction: 'asc' }.merge(options)
    s = joins("JOIN concept AS measurement_type_concept ON measurement.measurement_type_concept_id = measurement_type_concept.concept_id JOIN concept AS measurement_concept ON measurement.measurement_concept_id = measurement_concept.concept_id JOIN interleave_entities ON measurement.measurement_id = interleave_entities.fact_id AND interleave_entities.cdm_table = 'measurement'").where('interleave_entities.interleave_datapoint_id = ?', interleave_data_point_id)
    sort = options[:sort_column] + ' ' + options[:sort_direction]
    s = s.order(sort)

    s
  end

  def measurement_date
    read_attribute(:measurement_date).to_s(:date) if read_attribute(:measurement_date).present?
  end
end