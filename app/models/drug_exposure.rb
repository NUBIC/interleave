class DrugExposure < ActiveRecord::Base
  self.table_name = 'drug_exposure'
  self.primary_key = 'drug_exposure_id'
end
