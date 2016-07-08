class InterleaveDatapointDefaultValue < ActiveRecord::Base
  belongs_to :interleave_datapoint
  belongs_to :concept, class_name: 'Concept', foreign_key: 'default_value_as_concept_id'

  def value_as
    default_value_as_number || default_value_as_string || default_value_as_concept_id
  end
end
