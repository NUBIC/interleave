class ProcedureOccurrence < ActiveRecord::Base
  self.table_name = 'procedure_occurrence'
  self.primary_key = 'procedure_occurrence_id'
  DOMAIN_ID = 'Procedure'
end
