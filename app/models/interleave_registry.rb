class InterleaveRegistry < ActiveRecord::Base
  has_many :interleave_regsitry_affiliates
  has_many :interleave_registry_cdm_sources

  scope :search_across_fields, ->(search_token, options={}) do
    if search_token
      search_token.downcase!
    end
    options = { sort_column: 'name', sort_direction: 'asc' }.merge(options)

    if search_token
      s = where(['lower(name) like ?', "%#{search_token}%"])
    end

    sort = options[:sort_column] + ' ' + options[:sort_direction]
    s = s.nil? ? order(sort) : s.order(sort)

    s
  end
end