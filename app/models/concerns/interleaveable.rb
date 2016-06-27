require 'active_support/concern'

module Interleaveable
  extend ActiveSupport::Concern

  included do
    attr_accessor :interleave_datapoint_id, :interleave_registry_cdm_source_id
    validates_presence_of :interleave_datapoint_id, :interleave_registry_cdm_source_id, on: :create
    after_create :create_interleave_entity
  end

  def create_interleave_entity
    InterleaveEntity.create(interleave_datapoint_id: interleave_datapoint_id, cdm_table: self.class.table_name, domain_concept_id: self.class.domain_concept.id, fact_id: id, interleave_registry_cdm_source_id: interleave_registry_cdm_source_id)
  end

  class_methods do
    def by_person(person_id)
      where(person_id: person_id)
    end

    def domain_concept
      Concept.domain_concepts.valid.where(concept_name: self::DOMAIN_ID).first
    end
  end
end