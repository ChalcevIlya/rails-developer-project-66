# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
  end

  test 'should create + run check' do
    payload = {
      after: 'hookSHA',
      repository: { id: @repository.github_id }
    }.to_json

    assert_difference('Repository::Check.count', 1) do
      perform_enqueued_jobs do
        post api_checks_url, params: payload, headers: { 'Content-Type' => 'application/json' }
      end
    end

    assert_response :ok

    check = @repository.checks.last
    assert { check.commit_id == 'hookSHA' }
    assert { check.aasm_state == 'finished' }
    assert { JSON.parse(check.result)['offenses_count'].zero? }
  end

  test 'should return not found for unknown repository' do
    payload = { after: 'otherSHA', repository: { id: 0 } }.to_json

    assert_no_difference('Repository::Check.count') do
      post api_checks_url, params: payload, headers: { 'Content-Type' => 'application/json' }
    end

    assert_response :not_found
  end
end
