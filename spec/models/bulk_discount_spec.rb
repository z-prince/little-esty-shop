require 'rails_helper'

RSpec.describe 'bulk_discounts' do
  describe 'relationships' do
    it { should belong_to :merchant }
  end
end
