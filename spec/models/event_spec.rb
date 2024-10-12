require 'rails_helper'

RSpec.describe Event do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:participating_users).class_name('Participant') }
    it { is_expected.to have_many(:participants).through(:participating_users).source(:user) }
    it { is_expected.to belong_to(:organizer).class_name('User').with_foreign_key('user_id') }
  end
end
