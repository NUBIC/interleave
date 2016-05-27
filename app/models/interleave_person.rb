class InterleavePerson < ActiveRecord::Base
  belongs_to :interleave_registry_affiliate
  belongs_to :person
  has_many :interleave_person_identifiers

  scope :search_across_fields, ->(search_token, registry, affiliate_id, options={}) do
    options = { sort_column: 'name', sort_direction: 'asc' }.merge(options)
    affiliate_ids = []
    if affiliate_id == 'all'
      affiliate_ids = registry.interleave_registry_affiliates.map(&:id)
    else
      affiliate_ids << affiliate_id.to_i
    end

    s = joins(:interleave_registry_affiliate)

    if search_token
      search_token.downcase!
      s = s.where(['interleave_registry_affiliate_id IN(?) AND (lower(first_name) like ? OR lower(last_name) like ?)', affiliate_ids, "%#{search_token}%", "%#{search_token}%"])
    end

    sort = options[:sort_column] + ' ' + options[:sort_direction]
    s = s.nil? ? order(sort) : s.order(sort)

    s
  end

  def full_name
    [first_name, middle_name, last_name].compact.map(&:titleize).join(' ')
  end
end