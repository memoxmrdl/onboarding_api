# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationService, type: :service do
  describe '.generate_token' do
    context 'when no payload is provided' do
      it 'generates a token with only expiration time' do
        result = described_class.generate_token

        expect(result).to be_a(Hash)
        expect(result).to have_key(:token)
        expect(result).to have_key(:expires_at)
        expect(result[:token]).to be_present
        expect(result[:expires_at]).to be_a(Integer)
        expect(result[:expires_at]).to be > Time.current.to_i
      end
    end

    context 'when payload is provided' do
      let(:payload) { { user_id: 123, email: 'test@example.com' } }

      it 'generates a token with the provided payload and expiration time' do
        result = described_class.generate_token(payload)

        expect(result).to be_a(Hash)
        expect(result).to have_key(:token)
        expect(result).to have_key(:expires_at)
        expect(result[:token]).to be_present
        expect(result[:expires_at]).to be_a(Integer)
        expect(result[:expires_at]).to be > Time.current.to_i

        # Verify the token can be decoded and contains the payload
        decoded_token = JWT.decode(result[:token], Rails.application.secret_key_base, true, { algorithm: 'HS256' })
        decoded_payload = decoded_token[0]

        expect(decoded_payload['user_id']).to eq(123)
        expect(decoded_payload['email']).to eq('test@example.com')
        expect(decoded_payload['exp']).to eq(result[:expires_at])
      end
    end

    context 'when payload already has exp key' do
      let(:payload) { { user_id: 123, exp: 1234567890 } }

      it 'overwrites the exp key with new expiration time' do
        result = described_class.generate_token(payload)

        expect(result[:expires_at]).to be > Time.current.to_i
        expect(result[:expires_at]).not_to eq(1234567890)

        decoded_token = JWT.decode(result[:token], Rails.application.secret_key_base, true, { algorithm: 'HS256' })
        decoded_payload = decoded_token[0]

        expect(decoded_payload['exp']).to eq(result[:expires_at])
      end
    end
  end

  describe '.valid_token?' do
    let(:valid_payload) { { user_id: 123, email: 'test@example.com' } }
    let(:expired_payload) { { user_id: 123, exp: 1.hour.ago.to_i } }

    context 'when token is valid' do
      it 'returns true for a valid token' do
        token_data = described_class.generate_token(valid_payload)
        token = token_data[:token]

        expect(described_class.valid_token?(token)).to be true
      end

      it 'returns true for a token with Bearer prefix' do
        token_data = described_class.generate_token(valid_payload)
        bearer_token = "Bearer #{token_data[:token]}"

        expect(described_class.valid_token?(bearer_token)).to be true
      end
    end

    context 'when token is invalid' do
      it 'returns false for an expired token' do
        expired_token = JWT.encode(expired_payload, Rails.application.secret_key_base, 'HS256')

        expect(described_class.valid_token?(expired_token)).to be false
      end

      it 'returns false for a malformed token' do
        malformed_token = 'invalid.token.here'

        expect(described_class.valid_token?(malformed_token)).to be false
      end

      it 'returns false for an empty token' do
        expect(described_class.valid_token?('')).to be false
        expect(described_class.valid_token?(nil)).to be false
      end

      it 'returns false for a token with wrong signature' do
        wrong_secret_token = JWT.encode(valid_payload, 'wrong_secret', 'HS256')

        expect(described_class.valid_token?(wrong_secret_token)).to be false
      end

      it 'returns false for a token with wrong algorithm' do
        wrong_algorithm_token = JWT.encode(valid_payload, Rails.application.secret_key_base, 'HS512')

        expect(described_class.valid_token?(wrong_algorithm_token)).to be false
      end
    end

    context 'when token has extra whitespace' do
      it 'handles tokens with leading/trailing spaces' do
        token_data = described_class.generate_token(valid_payload)
        token_with_spaces = "  #{token_data[:token]}  "

        expect(described_class.valid_token?(token_with_spaces)).to be true
      end
    end
  end

  describe 'private methods' do
    let(:valid_payload) { { user_id: 123, email: 'test@example.com' } }
    let(:expired_payload) { { user_id: 123, exp: 1.hour.ago.to_i } }

    describe '#expired?' do
      it 'returns false for a valid token' do
        token_data = described_class.generate_token(valid_payload)
        token = token_data[:token]

        # Use send to access private method
        expect(described_class.send(:expired?, token)).to be false
      end

      it 'returns true for an expired token' do
        expired_token = JWT.encode(expired_payload, Rails.application.secret_key_base, 'HS256')

        expect(described_class.send(:expired?, expired_token)).to be true
      end

      it 'returns true for a malformed token' do
        malformed_token = 'invalid.token.here'

        expect(described_class.send(:expired?, malformed_token)).to be true
      end
    end

    describe '#decode' do
      it 'returns decoded payload for a valid token' do
        token_data = described_class.generate_token(valid_payload)
        token = token_data[:token]

        decoded = described_class.send(:decode, token)

        expect(decoded).to be_a(Hash)
        expect(decoded['user_id']).to eq(123)
        expect(decoded['email']).to eq('test@example.com')
        expect(decoded['exp']).to be_present
      end

      it 'returns nil for an expired token' do
        expired_token = JWT.encode(expired_payload, Rails.application.secret_key_base, 'HS256')

        decoded = described_class.send(:decode, expired_token)

        expect(decoded).to be_nil
      end

      it 'returns nil for a malformed token' do
        malformed_token = 'invalid.token.here'

        decoded = described_class.send(:decode, malformed_token)

        expect(decoded).to be_nil
      end

      it 'returns nil for a token with wrong signature' do
        wrong_secret_token = JWT.encode(valid_payload, 'wrong_secret', 'HS256')

        decoded = described_class.send(:decode, wrong_secret_token)

        expect(decoded).to be_nil
      end
    end
  end

  describe 'constants' do
    it 'has the correct SECRET_KEY' do
      expect(described_class::SECRET_KEY).to eq(Rails.application.secret_key_base)
    end

    it 'has the correct ALGORITHM' do
      expect(described_class::ALGORITHM).to eq('HS256')
    end

    it 'has the correct EXPIRATION_TIME' do
      expect(described_class::EXPIRATION_TIME).to eq(1.hour)
    end
  end

  describe 'integration tests' do
    let(:payload) { { user_id: 123, email: 'test@example.com', role: 'admin' } }

    it 'can generate and validate a complete token flow' do
      # Generate token
      token_data = described_class.generate_token(payload)
      token = token_data[:token]

      # Verify token is valid
      expect(described_class.valid_token?(token)).to be true

      # Verify token contains correct data
      decoded_token = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
      decoded_payload = decoded_token[0]

      expect(decoded_payload['user_id']).to eq(123)
      expect(decoded_payload['email']).to eq('test@example.com')
      expect(decoded_payload['role']).to eq('admin')
      expect(decoded_payload['exp']).to eq(token_data[:expires_at])
    end

    it 'handles Bearer token format correctly' do
      token_data = described_class.generate_token(payload)
      bearer_token = "Bearer #{token_data[:token]}"

      expect(described_class.valid_token?(bearer_token)).to be true
    end

    it 'token expires after the specified time' do
      # Create a token that expires in 1 second
      short_expiry_payload = payload.merge(exp: 1.second.from_now.to_i)
      short_token = JWT.encode(short_expiry_payload, Rails.application.secret_key_base, 'HS256')

      # Should be valid initially
      expect(described_class.valid_token?(short_token)).to be true

      # Wait for expiration
      sleep(2)

      # Should be invalid after expiration
      expect(described_class.valid_token?(short_token)).to be false
    end
  end
end
