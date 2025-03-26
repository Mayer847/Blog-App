require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /signup' do
    it 'creates a new user' do
      post '/signup', params: { name: 'Test User', email: 'test@example.com', password: 'password' }
      expect(response).to have_http_status(:created)
    end

    it 'returns error for invalid data' do
      post '/signup', params: { name: '', email: 'test@example.com', password: 'password' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /login' do
    let(:user) { create(:user, email: 'test@example.com', password: 'password') }

    it 'authenticates the user' do
      post '/login', params: { email: user.email, password: user.password }
      expect(response).to have_http_status(:ok)
    end

    it 'returns error for invalid credentials' do
      post '/login', params: { email: user.email, password: 'wrongpassword' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
