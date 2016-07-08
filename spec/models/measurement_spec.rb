require 'rails_helper'
require 'active_support'

RSpec.describe Measurement, type: :model do
  it { should belong_to :person }
end