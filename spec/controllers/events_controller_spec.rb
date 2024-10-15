require 'rails_helper'

RSpec.describe EventsController do
  describe 'GET #index' do
    let(:user) { create(:user, role: 'employee') }

    context 'when user is logged' do
      before do
        sign_in user
        get :index
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it 'returns a successful response' do
        expect(response).to be_successful
      end
    end

    context 'when user is not logged' do
      before do
        get :index
      end

      it 'does not render the index template' do
        expect(response).not_to render_template(:index)
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    before do
      allow(EventMailer).to receive(:notify_new_event).and_call_original
    end

    context 'when the event is successfully created' do
      before do
        sign_in user
        perform_enqueued_jobs
        post :create,
             params: { event: attributes_for(:event, organizer: user, participating_users: { user_id: [user.id] }) }
      end

      it 'redirects to the events path' do
        expect(response).to redirect_to(events_path)
      end

      it 'returns a notice' do
        expect(flash[:notice]).to eq('Event was successfully created')
      end

      it 'sends a notification email' do
        expect(enqueued_jobs.size).to eq(1)
        expect(enqueued_jobs.first['job_class']).to eq("ActionMailer::MailDeliveryJob")
        expect(enqueued_jobs.first['arguments']).to include('EventMailer')
      end
    end

    context 'when the event is not successfully created' do
      before do
        sign_in user
        post :create, params: { event: attributes_for(:event, title: nil, participating_users: { user_id: [user.id] }) }
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:event) { create(:event, organizer: user) }

    before do
      sign_in user
      delete :destroy, params: { id: event.id }
    end

    it 'redirects to the events path' do
      expect(response).to redirect_to(events_path)
    end

    it 'returns a notice' do
      expect(flash[:notice]).to eq('Event was successfully removed')
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let(:event) { create(:event, organizer: user) }
    let(:participant) { create(:participant, user:, event:) }

    before do
      sign_in user
    end

    context 'when the event is successfully updated' do
      before do
        patch :update,
              params: { id: event.id, event: { title: 'New title', participating_users: { user_id: [user.id] } } }
      end

      it 'redirects to the events path' do
        expect(response).to redirect_to(events_path)
      end

      it 'returns a notice' do
        expect(flash[:notice]).to eq('Event was successfully updated')
      end

      it 'updates the event' do
        event.reload
        expect(event.title).to eq('New title')
      end
    end

    context 'when the event is not successfully updated' do
      before do
        patch :update,
              params: { id: event.id, event: { title: nil, participating_users: { user_id: [user.id] } } }
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
