class InterleaveDatapointValue < ActiveRecord::Base
  belongs_to :interleave_datapoint
  belongs_to :concept, class_name: 'Concept', foreign_key: 'value_as_concept_id'
end
