# frozen_string_literal: true

module SignInHelper
  def sign_in(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: user.id.to_s,
      info: { email: user.email, nickname: user.nickname },
      credentials: { token: user.token || 'fake_token' }
    )
    get callback_auth_path
  end
end
