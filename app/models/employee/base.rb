# frozen_string_literal: true

module Employee
  class Base < ApplicationRecord
    include Constants

    self.table_name = 'employees'

    validates :first_name,
              :last_name,
              :date_of_birth,
              :phone_number,
              presence: true

    validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEXP }

    validates :phone_number,
              presence: true,
              format: {
                with: PHONE_NUMBER_REGEXP,
              },
              length: {
                minimum: PHONE_NUMBER_MIN_LENGTH,
                maximum: PHONE_NUMBER_MAX_LENGTH,
              }
  end
end
