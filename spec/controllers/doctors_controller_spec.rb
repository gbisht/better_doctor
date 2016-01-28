require 'rails_helper'

RSpec.describe DoctorsController, type: :controller do
  describe 'GET #search' do
    context 'no params' do
      it 'responds successfully with an HTTP 200 status code' do
        get :search
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end

    context 'with params' do
      before :each do
        @response = xhr :get, :search, {name: 'inna'}
      end

      it 'responds successfully with an HTTP 200 status code' do
        expect(@response).to be_success
        expect(@response).to have_http_status(200)
      end

      it "caches the results of name 'inna'" do
        expect($redis.get('inna').present?).to be(true)
        expect($redis.get('jhonny').present?).to be(false)
      end

      it 'assigns search results to doctor object' do
        expect(assigns['doctors'].present?).to be(true)
      end
    end
  end
end