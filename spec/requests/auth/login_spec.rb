require 'rails_helper'

RSpec.describe "AuthenticationController#create", type: :request do
  let(:path) { "/auth/login" }
  let(:headers) { { 'Accept' => 'application/json' } }

  let(:action) { post path, headers: }

  before do
    allow(Rails.application).to receive(:secret_key_base).and_return('1234567890')

    action
  end

  context "when an user request a token" do
    it { expect(response).to be_created }

    it "returns token and expires_at" do
      data = JSON.parse(response.body)

      expect(data).to have_key('token')
      expect(data['token']).to be_present

      expect(data).to have_key('expires_at')
      expect(data['expires_at']).to be_present
    end
  end
end
