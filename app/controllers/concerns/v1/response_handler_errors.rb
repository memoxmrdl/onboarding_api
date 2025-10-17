# frozen_string_literal: true

module V1
  module ResponseHandlerErrors
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError do |exception|
        case exception
        when ActiveRecord::RecordNotFound
          handle_not_found(exception)
        when ActiveRecord::RecordInvalid
          handle_record_invalid(exception)
        else
          handle_internal_server_error_response(exception)
        end
      end
    end

    private

    def handle_not_found(exception)
      head :not_found
    end

    def handle_record_invalid(exception)
      response_errors(exception.record, status: :unprocessable_entity)
    end

    def handle_internal_server_error_response(exception)
      head :internal_server_error if Rails.env.production?

      raise exception
    end
  end
end
