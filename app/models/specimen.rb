class Specimen < ActiveRecord::Base
  self.table_name = 'specimen'
  self.primary_key = 'specimen_id'
end
