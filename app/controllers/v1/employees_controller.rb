# frozen_string_literal: true

module V1
  class EmployeesController < BaseController
    def index
      @employees = Employee::Base.all
    end

    def show
      @employee = Employee::Base.find(params[:id])
    end

    def create
      contract = V1::Employees::CreateContract.new.call(employee_params.to_h)
      return response_errors(contract, status: :unprocessable_entity) if contract.failure?

      @employee = Employee::Base.create(contract.to_h)
      success = @employee.persisted?

      return response_errors(@employee, status: :unprocessable_entity) unless success

      render :show, status: :created
    end

    def update
      @employee = Employee::Base.find(params[:id])

      contract = V1::Employees::UpdateContract.new.call(employee_params.to_h)
      return response_errors(contract, status: :unprocessable_entity) if contract.failure?

      success = @employee.update(contract.to_h)
      return response_errors(@employee, status: :unprocessable_entity) unless success

      render :show, status: :ok
    end

    def destroy
      @employee = Employee::Base.find(params[:id])

      success = @employee.destroy

      return response_errors(@employee, status: :conflict) unless success

      head :no_content
    end

    private

    def employee_params
      params.permit(
        :first_name,
        :last_name,
        :email,
        :date_of_birth,
        :phone_number,
        :registration_complete,
      )
    end
  end
end
