require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{user.token}" } }

  describe 'GET /posts' do
    it 'returns all posts' do
      get '/posts', headers: headers
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /posts' do
    let(:valid_attributes) { { title: 'Test Post', body: 'This is a test post', tags: 'test' } }

    it 'creates a new post' do
      post '/posts', params: valid_attributes, headers: headers
      expect(response).to have_http_status(:created)
    end
  end

  # Add more tests for other endpoints
  # end
