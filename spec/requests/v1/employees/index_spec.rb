# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "V1::EmployeesController#index", type: :request do
  let(:path) { employees_path }
  let(:token) { AuthenticationService.generate_token[:token] }
  let(:headers) do
    {
      "Accept" => "application/json",
      "Authorization" => "Bearer #{token}"
    }
  end

  before { get path, headers: }

  context "when there are employees to list" do
    let!(:employees) { create_list(:employee, 2) }

    it "returns a success response" do
      expect(response).to be_successful
    end
  end

  context "when there are no employees to list" do
    it "returns a success response" do
      expect(response).to be_successful
    end
  end
end
