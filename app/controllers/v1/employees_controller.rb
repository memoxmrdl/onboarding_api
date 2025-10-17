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
      @employee = Employee::Base.create(employee_params)

      success = @employee.persisted?

      return response_errors(@employee, status: :unprocessable_entity) unless success

      render :show, status: :created
    end

    def update
      @employee = Employee::Base.find(params[:id])

      success = @employee.update(employee_params)

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

    def response_errors(object, status:)
      render "shared/errors", locals: { object: }, status:
    end
  end
end
