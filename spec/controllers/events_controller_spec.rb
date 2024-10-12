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
end
