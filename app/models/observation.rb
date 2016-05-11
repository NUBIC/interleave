class Observation < ActiveRecord::Base
  self.table_name = 'observation'
  self.primary_key = 'observation_id'
end
