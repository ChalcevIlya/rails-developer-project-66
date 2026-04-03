# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should login github' do
    sign_in users(:one)
    assert_redirected_to root_path
  end

  test 'should logout' do
    sign_in users(:one)
    delete session_url
    assert_redirected_to root_path
    assert { session[:user_id].nil? }
  end
end
