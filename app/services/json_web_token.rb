class JsonWebToken
  def self.encode(payload, exp = 5.years.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    body = JWT.decode(token, ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base)[0]
    HashWithIndifferentAccess.new body
  rescue
    nil
  end
end
