class InterleaveDatapointRelationship < ActiveRecord::Base
  belongs_to :interleave_datapoint
  belongs_to :interleave_sub_datapoint, class_name: 'InterleaveDatapoint', foreign_key: 'interleave_sub_datapoint_id'
end
