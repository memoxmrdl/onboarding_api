# frozen_string_literal: true

module Employee
  module Constants
    PHONE_NUMBER_REGEXP = /\A\+?[1-9]\d{1,14}\z/
    PHONE_NUMBER_MIN_LENGTH = 10
    PHONE_NUMBER_MAX_LENGTH = 15
    EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-]+\.[a-z]{2,}\z/i
  end
end
