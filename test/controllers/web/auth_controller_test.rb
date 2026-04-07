# frozen_string_literal: true

require 'test_helper'

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test 'check github auth' do
    post auth_request_path('github')
    assert_response :redirect
  end

  test 'create' do
    auth_hash = {
      provider: 'github',
      uid: '54321',
      info: {
        email: Faker::Internet.email,
        nickname: Faker::Internet.username
      },
      credentials: { token: 'fake_token' }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(auth_hash)

    get callback_auth_path('github')
    assert_response :redirect

    user = User.find_by!(email: auth_hash[:info][:email])
    assert { user.nickname == auth_hash[:info][:nickname] }
    assert { session[:user_id] == user.id }
  end

  test 'destroy' do
    sign_in users(:one)

    delete session_url
    assert_redirected_to root_path
    assert { session[:user_id].nil? }
  end
end
