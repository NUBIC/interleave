class InterleavePerson < ActiveRecord::Base
  belongs_to :interleave_registry_affiliate
  belongs_to :person
  has_many :interleave_person_identifiers

  def self.search_across_fields(registry, options={})
    options = { search: nil, affiliate_id: [], sort_column: 'last_name', sort_direction: 'asc' }.merge(options)
    if options[:affiliate_id].blank?
      options[:affiliate_id] = registry.interleave_registry_affiliates.map(&:id)
    end

    s = joins(:interleave_registry_affiliate).where('interleave_registry_affiliates.interleave_registry_id = ? AND interleave_registry_affiliate_id IN(?)', registry.id, options[:affiliate_id])

    if options[:search]
      options[:search] = options[:search].downcase
      s = s.where(['(lower(first_name) like ? OR lower(last_name) like ?)', "%#{options[:search]}%", "%#{options[:search]}%"])
    end

    sort = options[:sort_column] + ' ' + options[:sort_direction]
    s = s.order(sort)

    s
  end

  def full_name
    [first_name, middle_name, last_name].compact.map(&:titleize).join(' ')
  end
end