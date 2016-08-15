class DrugExposure < ActiveRecord::Base
  include Interleaveable
  self.table_name = 'drug_exposure'
  self.primary_key = 'drug_exposure_id'
  belongs_to :drug_concept, class_name: 'Concept', foreign_key: 'drug_concept_id'
  belongs_to :drug_type_concept, class_name: 'Concept', foreign_key: 'drug_type_concept_id'
  belongs_to :person, class_name: 'Person', foreign_key: 'person_id'
  belongs_to :route_concept, class_name: 'Concept', foreign_key: 'route_concept_id'
  belongs_to :dose_unit_concept, class_name: 'Concept', foreign_key: 'dose_unit_concept_id'

  DOMAIN_ID = 'Drug'

  validates_presence_of :drug_concept_id, :drug_exposure_start_date, :drug_type_concept_id

  def self.by_interleave_data_point(interleave_data_point_id, options = {})
    options = { sort_column: 'drug_exposure_start_date', sort_direction: 'asc' }.merge(options)
    s = joins("JOIN concept AS drug_type_concept ON drug_exposure.drug_type_concept_id = drug_type_concept.concept_id JOIN concept AS drug_concept ON drug_exposure.drug_concept_id = drug_concept.concept_id JOIN interleave_entities ON drug_exposure.drug_exposure_id = interleave_entities.fact_id AND interleave_entities.cdm_table = 'drug_exposure'").where('interleave_entities.interleave_datapoint_id = ?', interleave_data_point_id)
    sort = options[:sort_column] + ' ' + options[:sort_direction]
    s = s.order(sort)

    s
  end
end
