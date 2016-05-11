class FactRelationship < ActiveRecord::Base
  self.table_name = 'fact_relationship'
  self.primary_key = 'fact_relationship_id'
end