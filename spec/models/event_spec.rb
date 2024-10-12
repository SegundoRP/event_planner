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

  describe 'methods' do
    describe '#check_for_overlapping_events' do
      let!(:user) { create(:user) }
      let!(:event) { create(:event, organizer: user) }
      let!(:participant) { create(:participant, event:, user:) }

      context 'when there are overlapping events' do
        it 'returns an error message' do
          another_event = build(:event, start_time: event.start_time, end_time: event.end_time, organizer: user)
          another_event.save
          expect(another_event.errors[:start_time]).to include(I18n.t('activerecord.attributes.event.overlapping_events'))
        end
      end

      context 'when there are no overlapping events' do
        it 'does not return an error message' do
          another_event = build(:event, start_time: event.start_time + 5.hours, end_time: event.end_time + 10.hours,
                                        organizer: user)
          another_event.save
          expect(event.errors[:start_time]).not_to include(I18n.t('activerecord.attributes.event.overlapping_events'))
        end
      end
    end

    describe '#start_time_minors_than_end_time' do
      context 'when the start time is greater than the end time' do
        it 'returns an error message' do
          event = build(:event, start_time: DateTime.current, end_time: DateTime.current - 2.hours)
          event.save
          expect(event.errors[:start_time]).to include(I18n.t('activerecord.attributes.event.greater_than_end_time'))
        end
      end

      context 'when the start time is less than the end time' do
        it 'does not return an error message' do
          event = build(:event, start_time: DateTime.current, end_time: DateTime.current + 2.hours)
          event.save
          expect(event.errors[:start_time]).not_to include(I18n.t('activerecord.attributes.event.greater_than_end_time'))
        end
      end
    end

    describe '#end_time_greater_than_start_time' do
      context 'when the end time is less than the start time' do
        it 'returns an error message' do
          event = build(:event, start_time: DateTime.current, end_time: DateTime.current - 2.hours)
          event.save
          expect(event.errors[:end_time]).to include(I18n.t('activerecord.attributes.event.minor_than_start_time'))
        end
      end

      context 'when the end time is greater than the start time' do
        it 'does not return an error message' do
          event = build(:event, start_time: DateTime.current, end_time: DateTime.current + 2.hours)
          event.save
          expect(event.errors[:end_time]).not_to include(I18n.t('activerecord.attributes.event.minor_than_start_time'))
        end
      end
    end
  end
end
