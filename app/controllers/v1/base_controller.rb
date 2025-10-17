# frozen_string_literal: true

module V1
  class BaseController < ApplicationController
    include ResponseHandlerErrors
  end
end
