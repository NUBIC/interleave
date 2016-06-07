class Concept < ActiveRecord::Base
  self.table_name = 'concept'
  self.primary_key = 'concept_id'

  def self.condition_types
    where(vocabulary_id: 'Condition Type', standard_concept: 'S')
  end
end
