require 'rails_helper'

RSpec.describe Employee::Base, type: :model do
  describe 'validations' do
    subject { build(:employee) }

    let(:valid_emails) do
      [
        'test@example.com',
        'test+1@example.com',
      ]
    end

    let(:invalid_emails) do
      [
        'test@example',
        'test@example.com.com',
      ]
    end

    let(:valid_phone_numbers) do
      [
        '+1234567890',
        '1234567890',
        '+521234567890',
        '521234567890',
      ]
    end

    let(:valid_american_phone_numbers) do
      [
        '+1234567890',    # US/Canada
        '1234567890',     # US/Canada
        '+521234567890',  # Mexico
        '521234567890',   # Mexico
        '+541234567890',  # Argentina
        '541234567890',   # Argentina
        '+551234567890',  # Brazil
        '551234567890',   # Brazil
        '+571234567890',  # Colombia
        '571234567890'    # Colombia
      ]
    end

    let(:invalid_phone_numbers) do
      [
        '123',
        '1234567890123456',
        'abc123456789',
        '123-456-7890',
        '(123) 456-7890',
        '+0123456789',
        '',
        '0123456789',
      ]
    end

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:date_of_birth) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value(*valid_emails).for(:email) }
    it { should_not allow_value(*invalid_emails).for(:email) }
    it { should validate_length_of(:phone_number).is_at_least(10).is_at_most(15) }
    it { should allow_value(*valid_phone_numbers).for(:phone_number) }
    it { should allow_value(*valid_american_phone_numbers).for(:phone_number) }
    it { should_not allow_value(*invalid_phone_numbers).for(:phone_number) }
  end
end
