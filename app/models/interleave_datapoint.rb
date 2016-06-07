class InterleaveDatapoint < ActiveRecord::Base
  belongs_to :interleave_registry
  has_many :interleave_datapoint_concepts

  scope :by_domain, ->(domain_id) do
    where(domain_id: domain_id)
  end

  def concepts(search_token = nil)
    if unrestricted
      results = Concept.where(domain_id: domain_id, standard_concept: 'S').order('concept_name ASC')
    else
      results = interleave_datapoint_concepts.joins(:concept).order('concept.concept_name ASC')
    end

    if search_token
      results = results.where('lower(concept.concept_name) LIKE ?', "%#{search_token}%")
    end

    results
  end
end