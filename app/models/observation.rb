class Observation < ActiveRecord::Base
  include Interleaveable
  self.table_name = 'observation'
  self.primary_key = 'observation_id'
  belongs_to :observation_concept, class_name: 'Concept', foreign_key: 'observation_concept_id'
  belongs_to :observation_type_concept, class_name: 'Concept', foreign_key: 'observation_type_concept_id'
  belongs_to :value_as_concept, class_name: 'Concept', foreign_key: 'value_as_concept_id'
  belongs_to :qualifier_concept, class_name: 'Concept', foreign_key: 'qualifier_concept_id'
  belongs_to :unit_concept, class_name: 'Concept', foreign_key: 'unit_concept_id'
  belongs_to :person, class_name: 'Person', foreign_key: 'person_id'
  DOMAIN_ID = 'Observation'

  validates_presence_of :observation_concept_id, :observation_date, :observation_type_concept_id

  def self.by_interleave_data_point(interleave_data_point_id, options = {})

    if (options[:sort_column] != 'observation_date')
      sort_interleave_datapoint = InterleaveDatapoint.find(options[:sort_column].to_i)
      options = { sort_direction: 'asc' }.merge(options)
      case sort_interleave_datapoint.value_type
      when InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT
        if interleave_data_point_id == sort_interleave_datapoint.id
          options[:sort_column] = "observation_value_as_concept.concept_name"
        else
          sort_interleave_datapoint_join = "LEFT JOIN interleave_entities sub_datapoint_interleave_entities ON interleave_entities.id = sub_datapoint_interleave_entities.parent_id AND sub_datapoint_interleave_entities.interleave_datapoint_id = #{sort_interleave_datapoint.id} LEFT JOIN observation sub_datapoint_observation ON sub_datapoint_observation.observation_id = sub_datapoint_interleave_entities.fact_id AND sub_datapoint_interleave_entities.cdm_table = 'observation' LEFT JOIN concept AS sub_datapoint_observation_value_as_concept ON sub_datapoint_observation.value_as_concept_id = sub_datapoint_observation_value_as_concept.concept_id"
          options[:sort_column] = "sub_datapoint_observation_value_as_concept.concept_name"
        end
      when InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER, InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_DECIMAL, InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER_LIST
        if interleave_data_point_id == sort_interleave_datapoint.id
          options[:sort_column] = "observations.value_as_number"
        else
          sort_interleave_datapoint_join = "LEFT JOIN interleave_entities sub_datapoint_interleave_entities ON interleave_entities.id = sub_datapoint_interleave_entities.parent_id AND sub_datapoint_interleave_entities.interleave_datapoint_id = #{sort_interleave_datapoint.id} LEFT JOIN observation sub_datapoint_observation ON sub_datapoint_observation.observation_id = sub_datapoint_interleave_entities.fact_id AND sub_datapoint_interleave_entities.cdm_table = 'observation'"
          options[:sort_column] = "sub_datapoint_observation.value_as_number"
        end
      when InterleaveDatapoint::VALUE_TYPE_VALUE_AS_STRING
        if interleave_data_point_id == sort_interleave_datapoint.id
          options[:sort_column] = "observations.value_as_string"
        else
          sort_interleave_datapoint_join = "LEFT JOIN interleave_entities sub_datapoint_interleave_entities ON interleave_entities.id = sub_datapoint_interleave_entities.parent_id AND sub_datapoint_interleave_entities.interleave_datapoint_id = #{sort_interleave_datapoint.id} LEFT JOIN observation sub_datapoint_observation ON sub_datapoint_observation.observation_id = sub_datapoint_interleave_entities.fact_id AND sub_datapoint_interleave_entities.cdm_table = 'observation'"
          options[:sort_column] = "sub_datapoint_observation.value_as_string"
        end
      end
    end

    s = joins("LEFT JOIN concept AS observation_value_as_concept ON observation.value_as_concept_id = observation_value_as_concept.concept_id JOIN interleave_entities ON observation.observation_id = interleave_entities.fact_id AND interleave_entities.cdm_table = 'observation'").where('interleave_entities.interleave_datapoint_id = ?', interleave_data_point_id)
    if sort_interleave_datapoint_join
      s = s.joins(sort_interleave_datapoint_join)
    end
    sort = options[:sort_column] + ' ' + options[:sort_direction]
    s = s.order(sort)

    s
  end

  def interleave_date
    observation_date
  end

  def observation_date
    read_attribute(:observation_date).to_s(:date) if read_attribute(:observation_date).present?
  end

  def value
    if value_as_number.present?
      value_as_number
    elsif value_as_string.present?
      value_as_string
    elsif value_as_concept.present?
      value_as_concept.concept_name
    end
  end
end