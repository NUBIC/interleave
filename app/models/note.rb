class Note < ActiveRecord::Base
  self.table_name = 'note'
  self.primary_key = 'note_id'
end
