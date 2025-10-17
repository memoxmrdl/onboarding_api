# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "V1::EmployeesController#update", type: :request do
  let(:employee) { create(:employee) }
  let(:id) { employee.id }
  let(:path) { employee_path(id) }
  let(:token) { AuthenticationService.generate_token[:token] }
  let(:headers) do
    {
      "Accept" => "application/json",
      "Authorization" => "Bearer #{token}"
    }
  end

  let(:params) { {} }

  before { put path, headers:, params: }

  context "when the employee exists" do
    context "and is updated successfully" do
      let(:params) do
        {
          first_name: "John",
          last_name: "Doe",
        }
      end

      it "returns a success response" do
        expect(response).to be_successful
      end
    end

    context "and is not updated successfully" do
      let(:params) do
        {
          first_name: "",
          last_name: "",
        }
      end

      it "returns a unprocessable entity response" do
        expect(response).to be_unprocessable
      end
    end
  end

  context "when the employee does not exist" do
    let(:id) { "NOT_FOUND" }

    it "returns a not found response" do
      expect(response).to be_not_found
    end
  end
end
