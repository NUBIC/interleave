require 'rails_helper'
include InterleaveSpecSetup
RSpec.describe InterleaveDatapointRelationship, type: :model do
  it { should belong_to :interleave_datapoint }
  it { should belong_to :interleave_sub_datapoint }
end