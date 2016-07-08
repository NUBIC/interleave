class Relationship < ActiveRecord::Base
  self.table_name = 'relationship'
  self.primary_key = 'relationship_id'
end
