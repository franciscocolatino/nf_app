class Users::CheckAuth
  prepend SimpleCommand

  def initialize(cookies = {})
    @cookies = cookies
  end

  def call
    user
  end

  private

  attr_reader :cookies

  def user
    @user ||= ::User.where(id: decoded_auth_token[:user_id]).try(:first) if decoded_auth_token
    return unless @user

    @user
  end

  def decoded_auth_token
    decoded_auth_token ||= JsonWebToken.decode(get_token)
  end

  def get_token
    return cookies.encrypted[:auth_token].split(' ').last if cookies.encrypted[:auth_token].present?

    errors.add(:token, 'Missing token')
    nil
  end
end
