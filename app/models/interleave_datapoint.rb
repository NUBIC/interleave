class InterleaveDatapoint < ActiveRecord::Base
  belongs_to :interleave_registry
  has_many :interleave_datapoint_concepts

  def concepts(search_token = nil)
    if unrestricted
      results = Concept.standard.where(domain_id: domain_id)
    else
      results = Concept.standard.where(concept_id: interleave_datapoint_concepts.map(&:concept_id))
    end

    if search_token
      results = results.where('lower(concept.concept_name) LIKE ?', "%#{search_token.downcase}%").order('concept_name ASC')
    end

    results
  end
end