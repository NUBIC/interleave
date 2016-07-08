require 'rails_helper'
include InterleaveSpecSetup
RSpec.describe InterleaveEntity, type: :model do
  it { should have_many :children }
  it { should belong_to :parent }
end