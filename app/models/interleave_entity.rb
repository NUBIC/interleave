class InterleaveEntity < ActiveRecord::Base
  has_many :children, class_name: 'InterleaveEntity', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'InterleaveEntity'
  belongs_to :interleave_datapoint
end
