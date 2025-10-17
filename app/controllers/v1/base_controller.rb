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
  end
end
