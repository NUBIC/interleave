class InterleaveDatapoint < ActiveRecord::Base
  belongs_to :interleave_registry
  has_many :interleave_datapoint_values
  has_many :interleave_datapoint_default_values
  has_many :interleave_datapoint_relationships
  has_many :interleave_sub_datapoints, through: :interleave_datapoint_relationships

  VALUE_TYPE_VALUE_AS_NOT_APPICABLE = 'Not applicable'
  VALUE_TYPE_VALUE_AS_CONCEPT = 'Value as concept'
  VALUE_TYPE_VALUE_AS_NUMBER_INTEGER = 'Value as number integer'
  VALUE_TYPE_VALUE_AS_NUMBER_INTEGER_LIST = 'Value as number integer list'
  VALUE_TYPE_VALUE_AS_NUMBER_DECIMAL = 'Value as number decimal'
  VALUE_TYPE_VALUE_AS_STRING = 'Value as string'
  VALUE_TYPES = [VALUE_TYPE_VALUE_AS_CONCEPT, VALUE_TYPE_VALUE_AS_NUMBER_INTEGER, VALUE_TYPE_VALUE_AS_NUMBER_DECIMAL, VALUE_TYPE_VALUE_AS_NUMBER_INTEGER_LIST, VALUE_TYPE_VALUE_AS_STRING]

  def integer_values(column, search_token = nil)
    results = interleave_datapoint_values.where(column: column).map { |interleave_datapoint_value| interleave_datapoint_value.value_as_number.to_i }
  end

  def concept_values(column, search_token = nil)
    results = []
    if interleave_datapoint_values.where(column: column).count > 0
      results = Concept.standard.valid.where(concept_id: interleave_datapoint_values.where(column: column).map(&:value_as_concept_id))
    else
      results = case column
      when 'condition_concept_id', 'procedure_concept_id'
        Concept.standard.valid.where(domain_id: domain_id)
      when 'condition_type_concept_id'
        Concept.standard.valid.condition_types
      when 'procedure_type_concept_id'
        Concept.standard.valid.procedure_types
      else
        raise ArgumentError.new('Unknown column.')
      end
    end

    if search_token
      results = results.where('lower(concept.concept_name) LIKE ?', "%#{search_token.downcase}%").order('concept_name ASC')
    end

    results
  end

  def initialize_sub_datapoint_entities(interleave_entity=nil)
    sub_datapoint_entities = []
    if interleave_entity
      interleave_entity.children.each do |child|
        sub_datapoint_entity = child.cdm_table.classify.constantize.find(child.fact_id)
        sub_datapoint_entity.interleave_datapoint_id = child.interleave_datapoint_id
        sub_datapoint_entity.interleave_datapoint = child.interleave_datapoint
        sub_datapoint_entities << sub_datapoint_entity
      end
    else
      interleave_sub_datapoints.each do |interleave_sub_datapoint|
        sub_datapoint_entity = interleave_sub_datapoint.domain_id.constantize.new
        sub_datapoint_entity.interleave_datapoint_id = interleave_sub_datapoint.id
        sub_datapoint_entity.interleave_datapoint = interleave_sub_datapoint
        interleave_sub_datapoint.interleave_datapoint_default_values.each do |interleave_datapoint_default_value|
          sub_datapoint_entity[interleave_datapoint_default_value.column] = interleave_datapoint_default_value.value_as
        end
        sub_datapoint_entities << sub_datapoint_entity
      end
    end
    sub_datapoint_entities
  end
end