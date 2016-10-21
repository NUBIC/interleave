require 'active_support/concern'

module Interleaveable
  extend ActiveSupport::Concern

  included do
    attr_accessor :interleave_datapoint, :interleave_datapoint_id
    validates_presence_of :interleave_datapoint_id, on: :create
  end

  def create_interleave_entity!(interleave_datapoint_id, interleave_registry_cdm_source_id)
    InterleaveEntity.create!(interleave_datapoint_id: interleave_datapoint_id, cdm_table: self.class.table_name, domain_concept_id: self.class.domain_concept.id, fact_id: id, interleave_registry_cdm_source_id: interleave_registry_cdm_source_id)
  end

  def interleave_entity
    InterleaveEntity.where(cdm_table: self.class.table_name, fact_id: self.id).first
  end

  def create_with_sub_datapoints!(interleave_registry_cdm_source, sub_datapoints = {})
    saved = nil
    parent_domain_concept_id = self.class.domain_concept.concept_id
    measurment_domain_concept_id = Measurement.domain_concept.concept_id
    observation_domain_concept_id = Observation.domain_concept.concept_id
    begin
      if !sub_datapoints[:measurements].blank?
        sub_datapoints[:measurements].each do |measurement|
          interleave_datapoint_relationship = InterleaveDatapointRelationship.where(interleave_datapoint_id: interleave_datapoint_id, interleave_sub_datapoint_id: measurement[:interleave_datapoint_id]).first
          measurement[:relationship_concept_id] = interleave_datapoint_relationship.relationship_concept_id
        end
      end
      if !sub_datapoints[:observations].blank?
        sub_datapoints[:observations].each do |observation|
          interleave_datapoint_relationship = InterleaveDatapointRelationship.where(interleave_datapoint_id: interleave_datapoint_id, interleave_sub_datapoint_id: observation[:interleave_datapoint_id]).first
          observation[:relationship_concept_id] = interleave_datapoint_relationship.relationship_concept_id
        end
      end
      InterleaveDatapoint.transaction do
        save!
        parent_interleave_entity = create_interleave_entity!(interleave_datapoint_id, interleave_registry_cdm_source.id)
        if !sub_datapoints[:measurements].blank?
          sub_datapoints[:measurements].each do |measurement|
            m = Measurement.create!(person: person, measurement_concept_id: measurement[:measurement_concept_id], measurement_date: interleave_date, value_as_concept_id: measurement[:value_as_concept_id], value_as_number: measurement[:value_as_number],  measurement_type_concept_id: measurement[:measurement_type_concept_id], interleave_datapoint_id: measurement[:interleave_datapoint_id])
            interleave_entity = m.create_interleave_entity!(measurement[:interleave_datapoint_id], interleave_registry_cdm_source.id)
            interleave_entity.parent_id = parent_interleave_entity.id
            interleave_entity.save!
            FactRelationship.create!(domain_concept_id_1: parent_domain_concept_id, fact_id_1: self.id, domain_concept_id_2: measurment_domain_concept_id, fact_id_2: m.id, relationship_concept_id: measurement[:relationship_concept_id])
          end
        end
        if !sub_datapoints[:observations].blank?
          sub_datapoints[:observations].each do |observation|
            o = Observation.create!(person: person, observation_concept_id: observation[:observation_concept_id], observation_date: interleave_date, value_as_concept_id: observation[:value_as_concept_id], value_as_number: observation[:value_as_number],  observation_type_concept_id: observation[:observation_type_concept_id], interleave_datapoint_id: observation[:interleave_datapoint_id])
            interleave_entity = o.create_interleave_entity!(observation[:interleave_datapoint_id], interleave_registry_cdm_source.id)
            interleave_entity.parent_id = parent_interleave_entity.id
            interleave_entity.save!
            FactRelationship.create!(domain_concept_id_1: parent_domain_concept_id, fact_id_1: self.id, domain_concept_id_2: observation_domain_concept_id, fact_id_2: o.id, relationship_concept_id: observation[:relationship_concept_id])
          end
        end
      end
      saved = true
    rescue Exception => e
      Rails.logger.info(e.message)
      Rails.logger.info(e.class)
      saved = false
    end
    saved
  end

  def update_with_sub_datapoints!(datapoint, sub_datapoints = {})
    saved = nil
    measurements = []
    observations = []
    begin
      if !sub_datapoints[:measurements].blank?
        sub_datapoints[:measurements].each_pair do |index, measurement|
          m =  Measurement.find(measurement[:measurement_id].to_i)
          m.person =  person
          m.measurement_concept_id = measurement[:measurement_concept_id]
          m.measurement_date = interleave_date
          m.value_as_concept_id = measurement[:value_as_concept_id]
          m.value_as_number = measurement[:value_as_number]
          m.measurement_type_concept_id = measurement[:measurement_type_concept_id]
          measurements << m
        end
      end

      if !sub_datapoints[:observations].blank?
        sub_datapoints[:observations].each_pair do |index, observation|
          o =  Observation.find(observation[:observation_id].to_i)
          o.person = person
          o.observation_concept_id = observation[:observation_concept_id] unless observation[:observation_concept_id].nil?
          o.observation_date = interleave_date
          o.value_as_concept_id = observation[:value_as_concept_id] unless observation[:value_as_concept_id].nil?
          o.value_as_number = observation[:value_as_number] unless observation[:value_as_number].nil?
          o.observation_type_concept_id = observation[:measurement_type_concept_id] unless observation[:measurement_type_concept_id].nil?
          observations << o
        end
      end

      InterleaveDatapoint.transaction do
        update_attributes(datapoint)
        measurements.each do |measurement|
          measurement.save!
        end

        observations.each do |observation|
          observation.save!
        end
      end
      saved = true
    rescue Exception => e
      Rails.logger.info(e.message)
      Rails.logger.info(e.class)
      saved = false
    end
    saved
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