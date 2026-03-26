# frozen_string_literal: true

require 'test_helper'

class Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @repository = repositories(:one)
  end

  test 'should create check' do
    sign_in @user

    assert_difference('Repository::Check.count', 1) do
      perform_enqueued_jobs do
        post repository_checks_url(@repository)
      end
    end

    check = @repository.checks.last
    assert { check.commit_id == 'testsha123456shatest' }
    assert { check.aasm_state == 'checked' }
    assert { check.result.present? }
  end

  test 'should redirect create when not logged in' do
    assert_no_difference('Repository::Check.count') do
      post repository_checks_url(@repository)
    end

    assert_redirected_to root_path
  end

  test 'should show check' do
    sign_in @user
    check = @repository.checks.create!(
      commit_id: 'testcommitid',
      aasm_state: 'checked',
      result: '{"offenses_count": 0}'
    )

    get repository_check_url(@repository, check)
    assert_response :success
    assert { response.body.include?('testcommitid') }
  end
end
