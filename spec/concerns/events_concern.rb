require 'rails_helper'

RSpec.describe EventsConcern do
  describe '#events_filtered' do
    let(:dummy_class) do
      Class.new do
        include EventsConcern
      end
    end

    let(:organizer) { create(:user) }
    let(:attendant) { create(:user, email: 'anotheruser@gmail.com') }
    let!(:event) { create(:event, title: 'Onboarding session', organizer:) }
    let!(:participant) { create(:participant, user: attendant, event:) }
    let(:dummy_instance) { dummy_class.new }

    it 'returns the filtered events' do
      query = 'Onboarding'
      expect(dummy_instance.events_filtered(query, 1)).to include(event)
    end
  end
end
