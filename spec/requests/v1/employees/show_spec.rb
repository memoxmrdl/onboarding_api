# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "V1::EmployeesController#show", type: :request do
  let(:employee) { create(:employee) }
  let(:id) { employee.id }
  let(:path) { employee_path(id) }
  let(:headers) { { "Accept" => "application/json" } }

  before { get path, headers: }

  context "when the employee exists" do
    it "returns a success response" do
      expect(response).to be_successful
    end
  end

  context "when the employee does not exist" do
    let(:id) { "NOT_FOUND" }

    it "returns a not found response" do
      expect(response).to be_not_found
    end
  end
end
