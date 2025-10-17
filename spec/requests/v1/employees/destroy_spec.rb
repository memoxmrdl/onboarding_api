# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "V1::EmployeesController#destroy", type: :request do
  let(:employee) { create(:employee) }
  let(:id) { employee.id }
  let(:path) { employee_path(id) }
  let(:headers) { { "Accept" => "application/json" } }
  let(:action) { delete path, headers: }

  context "when the employee exists" do
    before { action }

    context "and is destroyed successfully" do
      it "returns a success response" do
        expect(response).to be_no_content
      end
    end
  end

  context "when the employee does not exist" do
    let(:id) { "NOT_FOUND" }

    before { action }

    it "returns a not found response" do
      expect(response).to be_not_found
    end
  end

  context "when the employee is not destroyed successfully" do
    before do
      allow_any_instance_of(Employee::Base).to receive(:destroy).and_return(false)

      action
    end

    it "returns a conflict response" do
      expect(response).to have_http_status(:conflict)
    end
  end
end
