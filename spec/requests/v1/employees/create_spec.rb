# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "V1::EmployeesController#create", type: :request do
  let(:path) { employees_path }
  let(:token) { AuthenticationService.generate_token[:token] }
  let(:headers) do
    {
      "Accept" => "application/json",
      "Authorization" => "Bearer #{token}"
    }
  end

  let(:params) { attributes_for(:employee) }

  before { post path, headers:, params: }

  context "when the employee is created successfully" do
    it "returns a success response" do
      expect(response).to be_successful
    end
  end

  context "when the employee is not created successfully" do
    let(:params) { {} }

    it "returns a unprocessable entity response" do
      expect(response).to be_unprocessable
    end
  end
end
