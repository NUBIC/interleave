class InterleaveDatapointConcept < ActiveRecord::Base
  belongs_to :concept, class_name: 'Concept', foreign_key: 'concept_id'
end
