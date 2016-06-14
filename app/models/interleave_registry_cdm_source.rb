class InterleaveRegistryCdmSource < ActiveRecord::Base
  belongs_to :interleave_registry
  CDM_SOURCE_EX_NIHILO = 'Ex nihilo'
end
