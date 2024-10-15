require 'rails_helper'

RSpec.describe EventsHelper do
  describe '#event_duration' do
    it 'returns the duration of an event in minutes' do
      event = Event.new(start_time: DateTime.current, end_time: DateTime.current + 2.hours)
      expect(event_duration(event)).to eq(120)
      expect(event_duration(event)).not_to eq(119)
    end
  end
end
