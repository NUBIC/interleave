class Person < ActiveRecord::Base
  self.table_name = 'person'
  self.primary_key = 'person_id'
  belongs_to :gender, class_name: 'Concept', foreign_key: 'gender_concept_id'
  belongs_to :race, class_name: 'Concept', foreign_key: 'race_concept_id'
  belongs_to :ethnicity, class_name: 'Concept', foreign_key: 'ethnicity_concept_id'
end
