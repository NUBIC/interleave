require 'rails_helper'
include InterleaveSpecSetup
RSpec.describe InterleaveDatapointValue, type: :model do
  it { should belong_to :interleave_datapoint }
  it { should belong_to :concept }
end