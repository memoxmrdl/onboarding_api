# frozen_string_literal: true

module V1
  module Employees
    class CreateContract < Dry::Validation::Contract
      params do
        required(:first_name).filled(:string)
        required(:last_name).filled(:string)
        required(:email).filled(:string)
        required(:date_of_birth).filled(:string)
        required(:phone_number).filled(:string)
        optional(:registration_complete).filled(:string)
      end

      rule(:email) do
        key.failure('is invalid') if value && !value.match?(Employee::Constants::EMAIL_REGEXP)
      end

      rule(:phone_number) do
        key.failure('is invalid') if value && !value.match?(Employee::Constants::PHONE_NUMBER_REGEXP)
      end

      rule(:date_of_birth) do
        key.failure('is invalid') if value && !value.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      end

      rule(:registration_complete) do
        key.failure('is invalid') if value && !value.match?(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\z/)
      end
    end
  end
end
