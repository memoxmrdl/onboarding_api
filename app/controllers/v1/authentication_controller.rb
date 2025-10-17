# frozen_string_literal: true

module V1
  class AuthenticationController < BaseController
    skip_before_action :authenticate_token

    def create
      @auth = AuthenticationService.generate_token

      render :create, status: :created
    end
  end
end
