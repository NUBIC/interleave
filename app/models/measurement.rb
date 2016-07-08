class Measurement < ActiveRecord::Base
  include Interleaveable
  self.table_name = 'measurement'
  self.primary_key = 'measurement_id'
  belongs_to :person, class_name: 'Person', foreign_key: 'person_id'
  DOMAIN_ID = 'Measurement'
end
