class InterleaveDatapoint < ActiveRecord::Base
  belongs_to :interleave_registry
  has_many :interleave_datapoint_concepts
  VALUE_TYPE_VALUE_AS_CONCEPT = 'Value as concept'
  VALUE_TYPE_VALUE_AS_NUMBER = 'Value as number'
  VALUE_TYPE_VALUE_AS_STRING = 'Value as string'
  VALUE_TYPES = [VALUE_TYPE_VALUE_AS_CONCEPT, VALUE_TYPE_VALUE_AS_NUMBER, VALUE_TYPE_VALUE_AS_STRING]

  def concepts(column, search_token = nil)
    if interleave_datapoint_concepts.where(column: column).count > 0
      results = Concept.standard.valid.where(concept_id: interleave_datapoint_concepts.where(column: column).map(&:concept_id))
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
end