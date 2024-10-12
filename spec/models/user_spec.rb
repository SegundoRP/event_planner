require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2) }
    it { is_expected.to validate_length_of(:last_name).is_at_least(2) }
    it { is_expected.to define_enum_for(:role).with_values(admin: 0, employee: 1) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:organized_events).class_name('Event').with_foreign_key('user_id') }
    it { is_expected.to have_many(:participations).class_name('Participant') }
    it { is_expected.to have_many(:events).through(:participations) }
  end
end
