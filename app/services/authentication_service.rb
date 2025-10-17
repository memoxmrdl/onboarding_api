# frozen_string_literal: true

class AuthenticationService
  SECRET_KEY = Rails.application.secret_key_base
  ALGORITHM = 'HS256'
  EXPIRATION_TIME = 1.hour

  class << self
    def generate_token(payload = {})
      payload[:exp] = EXPIRATION_TIME.from_now.to_i

      token = JWT.encode(payload, SECRET_KEY, ALGORITHM)

      { token: token, expires_at: payload[:exp] }
    end

    def valid_token?(token)
      sanitized_token = token.to_s.split(' ').last

      return false if sanitized_token.blank?

      decode(sanitized_token).present? && !expired?(sanitized_token)
    end

    private

    def expired?(token)
      decoded = decode(token)

      return true if decoded.nil?

      Time.at(decoded['exp']) < Time.current
    end

    def decode(token)
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
      decoded[0]
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      nil
    end
  end
end
