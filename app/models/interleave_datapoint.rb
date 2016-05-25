class InterleaveDatapoint < ActiveRecord::Base
  belongs_to :interleave_registry

  scope :by_domain, ->(domain_id) do
    where(domain_id: domain_id)
  end
end