require 'rails_helper'

RSpec.describe EventMailer do
  describe '#notify_new_event' do
    let(:user) { create(:user) }
    let(:event) { create(:event, organizer: user) }
    let(:mail) { EventMailer.notify_new_event(event) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New event created')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['postmaster@sandboxffa43982922a4d369a861cc65c72c297.mailgun.org'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('Event title')
    end
  end
end
