class InterleaveRegistry < ActiveRecord::Base
  has_many :interleave_registry_affiliates
  has_many :interleave_registry_cdm_sources
  has_many :interleave_datapoints

  def self.search_across_fields(search, options={})
    options = { sort_column: 'name', sort_direction: 'asc' }.merge(options)

    if search
      s = where(['lower(name) like ?', "%#{search.downcase}%"])
    end

    sort = options[:sort_column] + ' ' + options[:sort_direction]
    s = s.nil? ? order(sort) : s.order(sort)

    s
  end
end