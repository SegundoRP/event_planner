require 'rails_helper'

RSpec.describe Api::V1::EventsController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, role: 'employee', email: 'example@gmail.com') }
  let!(:event) { create(:event, organizer: user) }
  let!(:participant) { create(:participant, user:, event:) }
  let!(:other_participant) { create(:participant, user: other_user, event:) }

  describe 'GET #index' do
    context "without participant_id" do
      before { get api_v1_events_path, as: :json }

      it "returns all events ordered by start time" do
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response['data']).not_to be_empty
        expect(json_response['data'].count).to eq(1)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with participant_id" do
      it "returns events where the participant is involved" do
        get api_v1_events_path, params: { participant_id: other_user.id }

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response['data']).not_to be_empty
        expect(json_response['data'].first['id']).to eq(event.id.to_s)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it "returns an empty array if no events match the participant" do
        get api_v1_events_path, params: { participant_id: -1 }

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response['data']).to be_empty
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'GET #show' do
    context "when event exists" do
      it "returns the event" do
        get api_v1_event_path(event)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response['data']['id']).to eq(event.id.to_s)
      end
    end

    context "when event does not exist" do
      it "returns a not found error" do
        get api_v1_event_path(0)

        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Event not found')
      end
    end
  end
end
