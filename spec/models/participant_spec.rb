require 'rails_helper'

RSpec.describe Participant do
  describe 'validations' do
    it { is_expected.to define_enum_for(:role).with_values(organizer: 0, attendant: 1) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:event) }
  end
end
