# frozen_string_literal: true

module V1
  class BaseController < ApplicationController
    include ResponseHandlerErrors

    before_action :authenticate_token

    private

    def authenticate_token
      token = request.headers['Authorization']

      valid_token = AuthenticationService.valid_token?(token)

      head :unauthorized unless valid_token
    end

    def response_errors(object, status:)
      render "shared/errors", locals: { errors: parse_errors(object) }, status:
    end

    def parse_errors(object)
      raise "Object must respond to :errors" unless object.respond_to?(:errors)

      object.errors.map do |error|
        parse_error(error)
      end
    end

    def parse_error(error)
      {
        attribute: parse_error_attribute(error),
        message: parse_error_message(error),
      }
    end

    def parse_error_attribute(error)
      if error.respond_to?(:attribute)
        error.attribute
      elsif error.respond_to?(:path)
        error.path.first
      else
        error.to_s
      end
    end

    def parse_error_message(error)
      if error.respond_to?(:message)
        error.message
      elsif error.respond_to?(:text)
        error.text
      else
        error.to_s
      end
    end
  end
end
